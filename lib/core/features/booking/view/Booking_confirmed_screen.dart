import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/payment/view/payment_screen.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../../room/data/room_model_screen.dart';

class BookingConformedScreen extends StatefulWidget {
  final int bookingId;
  final RoomModel room;   // 👈 Room model added

  const BookingConformedScreen({
    super.key,
    required this.bookingId,
    required this.room,
  });

  @override
  State<BookingConformedScreen> createState() =>
      _BookingConformedScreenState();
}

class _BookingConformedScreenState extends State<BookingConformedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Confirmed"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(   // 👈 overflow fix
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// ✅ Room Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.room.imageUrl,  // 👈 image url
                  height: 180,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 15),

              /// ✅ Room Name
              Text(
                widget.room.description,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              /// ✅ Room Price
              Text(
                "₹ ${widget.room.price} per night",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              /// ✅ Room Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.room.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),

              const SizedBox(height: 15),

              const Text(
                "Booking Confirmed!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Booking ID: ${widget.bookingId}",
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return Text(
                    provider.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Pay now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}