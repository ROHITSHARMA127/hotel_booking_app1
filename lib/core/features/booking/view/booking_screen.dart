// BookingHistoryScreen - Improved & Production Ready
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_booking_app/core/features/booking/view/bookin_cancel_screen.dart';
import '../data/booking_model_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  final int userId;
  const BookingHistoryScreen({super.key, required this.userId});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Booking> allBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      setState(() => isLoading = true);

      final uri = Uri.parse(
        "https://hotelbooking.edugaondev.com/api/booking/user/${widget.userId}",
      );

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      final body = response.body.trim();

      if (!body.startsWith("{") && !body.startsWith("[")) {
        throw Exception("Invalid server response");
      }

      final data = json.decode(body);

      if (data is Map && data['data'] is List) {
        setState(() {
          allBookings =
              (data['data'] as List).map((e) => Booking.fromJson(e)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load bookings")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Booking> pendingBookings() => allBookings
      .where((b) => b.status.toLowerCase() == "pending")
      .toList();

  List<Booking> cancelledBookings() => allBookings
      .where((b) => b.status.toLowerCase() == "cancelled")
      .toList();

  String formatDate(DateTime date) =>
      "${date.day}-${date.month}-${date.year}";

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "cancelled":
        return Colors.red;
      case "pending":
        return Colors.orange;
      case "confirmed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Booking History"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchBookings,
        child: TabBarView(
          controller: _tabController,
          children: [
            buildBookingList(pendingBookings(),
                key: const ValueKey("pending")),
            buildBookingList(cancelledBookings(),
                key: const ValueKey("cancelled")),
          ],
        ),
      ),
    );
  }

  Widget buildBookingList(List<Booking> bookings, {required Key key}) {
    if (bookings.isEmpty) {
      return ListView(
        key: key,
        children: const [
          SizedBox(height: 120),
          Center(
            child: Column(
              children: [
                Icon(Icons.hotel_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text("No bookings found",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      key: key,
      padding: const EdgeInsets.all(12),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final isCancelled =
            booking.status.toLowerCase() == "cancelled";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel name + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${booking.hotelName} (${booking.city})",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor(booking.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Room: ${booking.roomName}"),
                const SizedBox(height: 4),
                Text("Check-in: ${formatDate(booking.checkIn)}"),
                Text("Check-out: ${formatDate(booking.checkOut)}"),
                const SizedBox(height: 4),
                Text("Guests: ${booking.guests}"),
                Text("Total: ₹${booking.totalPrice.toStringAsFixed(0)}"),
                const SizedBox(height: 8),

                if (!isCancelled)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon:
                      const Icon(Icons.cancel, color: Colors.red),
                      label: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => showCancelDialog(booking),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCancelDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Booking"),
        content:
        const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
            onPressed: () async {
              Navigator.pop(context);

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingCancelScreen(booking.id),
                ),
              );
              if (result == true) {
                setState(() {
                  final index = allBookings
                      .indexWhere((b) => b.id == booking.id);
                  if (index != -1) {
                    allBookings[index] =
                        allBookings[index].copyWith(
                          status: "cancelled",
                        );
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}