// api_services/razorpay_services.dart
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorApiServices {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  void openCheckout(int amount) {
    var options = {
      'key': 'rzp_test_xxxxxxxx', // Sirf TEST key use karo testing ke time
      'amount': amount,          // Paisa me hona chahiye (500 INR = 50000)
      'currency': 'INR',
      'name': 'Hotel Booking App',
      'description': 'Room Booking Payment',
      'retry': {
        'enabled': true,
        'max_count': 1,
      },
      'prefill': {
        'contact': '9999999999',
        'email': 'test@razorpay.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay Open Error: $e");
    }
  }


  void dispose() {
    _razorpay.clear();
  }
}
