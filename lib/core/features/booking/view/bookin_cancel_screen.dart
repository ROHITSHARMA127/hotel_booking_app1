import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookinCancelScreen extends StatefulWidget {
  final int bookingId;
  const BookinCancelScreen(this.bookingId, {super.key});

  @override
  State<BookinCancelScreen> createState() => _BookinCancelScreenState();
}

class _BookinCancelScreenState extends State<BookinCancelScreen> {
  bool isLoading = false;
  bool isSuccess = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    // Screen open hote hi cancel API call
    cancelBooking();
  }

  Future<void> cancelBooking() async {
    setState(() {
      isLoading = true;
      error = "";
      isSuccess = false;
    });

    try {
      final uri = Uri.parse(
        "https://hotelbooking.edugaondev.com/api/booking/cancel/${widget.bookingId}",
      );

      final response = await http.put(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          setState(() {
            isSuccess = true;
          });

          // 1 second baad previous screen ko true return
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true);
          });
        } else {
          setState(() {
            error = data["message"] ?? "Cancel failed";
          });
        }
      } else {
        setState(() {
          error = "Server error : ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        error = "Something went wrong : $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancel Booking"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text(
              "Cancelling your booking...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
            : error.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 10),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cancelBooking,
              child: const Text("Retry"),
            )
          ],
        )
            : isSuccess
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 90,
            ),
            SizedBox(height: 12),
            Text(
              "Booking Cancelled Successfully!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
            : const SizedBox(),
      ),
    );
  }
}
