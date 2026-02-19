import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final int userId;
  final int bookingId;
  final double amount;
  final String hotelPrice;

  PaymentPage({
    required this.userId,
    required this.bookingId,
    required this.amount, required this.hotelPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  int? paymentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // =================== CREATE PAYMENT ===================
  Future<void> _createPayment() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse("https://hotelbooking.edugaondev.com/api/payment/create");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": widget.userId,
          "booking_id": widget.bookingId,
          "amount": widget.amount,
          "payment_method": "razorpay"
        }),
      );

      final data = jsonDecode(response.body);

      setState(() => isLoading = false);

      if (response.statusCode == 201) {
        // ✅ Null-safe parsing
        final orderId = data['razorpay_order_id']?.toString();
        final amount = (data['amount'] is int)
            ? data['amount']
            : int.tryParse(data['amount']?.toString() ?? "0") ?? 0;

        if (orderId == null || amount == 0) {
          print("Payment order missing data: $data");
          _showDialog("Error", "Payment order data invalid");
          return;
        }

        paymentId = data['payment_id'];
        _openRazorpay(orderId, amount);
      } else {
        print("Payment creation failed: ${data['message']}");
        _showDialog("Error", "Payment creation failed: ${data['message']}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Create payment error: $e");
      _showDialog("Error", "Payment creation error: $e");
    }
  }

  // =================== OPEN RAZORPAY ===================
  void _openRazorpay(String orderId, int amount) {
    var options = {
      'key': 'rzp_test_xxxxx', // Your Razorpay key_id
      'amount': amount, // paise
      'name': 'Hotel Booking',
      'order_id': orderId,
      'description': 'Booking Payment',
      'prefill': {'contact': '', 'email': ''},
      'theme': {'color': '#F37254'}
    };
    _razorpay.open(options);
  }

  // =================== PAYMENT SUCCESS ===================
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (paymentId == null) return;

    try {
      final url =
      Uri.parse("http://10.0.2.2:3000/api/payment/success/$paymentId");
      final res = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "razorpay_payment_id": response.paymentId,
          "razorpay_order_id": response.orderId,
          "razorpay_signature": response.signature
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showDialog("Success", "Payment Successful & Booking Confirmed");
      } else {
        _showDialog("Error", "Payment success update failed");
      }
    } catch (e) {
      print("Payment success error: $e");
      _showDialog("Error", "Payment success error: $e");
    }
  }

  // =================== PAYMENT FAILURE ===================
  void _handlePaymentError(PaymentFailureResponse response) async {
    if (paymentId != null) {
      try {
        final url =
        Uri.parse("http://10.0.2.2:3000/api/payment/fail/$paymentId");
        await http.put(url);
      } catch (e) {
        print("Payment fail update error: $e");
      }
    }
    _showDialog("Failed", "Payment Failed: ${response.message}");
  }

  // =================== DIALOG ===================
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _createPayment,
          child: Text("Pay Rs ${widget.amount}"),
        ),
      ),
    );
  }
}
