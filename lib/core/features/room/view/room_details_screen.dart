import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/room/data/room_model_screen.dart';

import '../../booking/view/Booking_confirmed_screen.dart';
import '../../booking/data/booking_api_services.dart';
import '../../rating/data/rating_api_services.dart';
import '../data/room_api_services.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int hotelId;
  final String hotelName;
  final String hotelPrice;

  const RoomDetailsScreen({
    super.key,
    required this.hotelId,
    required this.hotelName,
    required this.hotelPrice,
  });

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  late Future<List<RoomModel>> roomsFuture;
  late Future<Map<String, dynamic>> hotelRatingFuture;
  RoomModel? selectedRoom;

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    roomsFuture = RoomApiServices.fetchRooms(widget.hotelId);
    hotelRatingFuture = RatingApiServices.fetchHotelRating(widget.hotelId);
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  // 🔥 Select date (checkIn or checkOut)
  Future<void> selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime(2000), // user can pick any past/future date
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          // Optional: auto adjust check-out if before check-in
          if (checkOutDate.isBefore(checkInDate)) {
            checkOutDate = checkInDate.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      body: FutureBuilder<List<RoomModel>>(
        future: roomsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!;
          selectedRoom ??= rooms[0];

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 180),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                room.imageUrl,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 30,
                                right: 20,
                                child: FutureBuilder<Map<String, dynamic>>(
                                  future: hotelRatingFuture,
                                  builder: (context, ratingSnap) {
                                    if (!ratingSnap.hasData) {
                                      return const SizedBox();
                                    }
                                    final rating = ratingSnap.data!;
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            rating["rating"].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hotelName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                room.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹${widget.hotelPrice}/night",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "Available: ${room.availableRooms}",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRoom = room;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectedRoom == room
                                            ? Colors.red
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        selectedRoom == room
                                            ? "Selected"
                                            : "Select",
                                        style: TextStyle(
                                          color: selectedRoom == room
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Price",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "₹${widget.hotelPrice}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 160,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedRoom == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Please select a room first")),
                              );
                              return;
                            }

                            try {
                              final result =
                              await BookingApiService.createBooking(
                                userId: 1,
                                hotelId: widget.hotelId,
                                roomId: selectedRoom!.id,
                                checkIn: checkInDate
                                    .toIso8601String()
                                    .split("T")[0],
                                checkOut: checkOutDate
                                    .toIso8601String()
                                    .split("T")[0],
                                totalPrice:
                                double.parse(widget.hotelPrice),
                                guests: 1,
                              );

                              if (result["message"] ==
                                  "Booking created successfully") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingConfirmedScreen(
                                      bookingId: result["booking_id"],
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          result["message"].toString())),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                          child: const Text("Book Now"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 450,
                left: 0,
                right: 0, // <-- this makes it stretch full width
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10), // optional margin
                  //,
                ),
              )

            ],
          );
        },
      ),
    );
  }
  // Widget bookingDetailsCard() {
  //   return Container(
  //     width: double.infinity, // Full screen width
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.black),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Your booking details",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //
  //         // Dates Row
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: const [
  //                 Icon(Icons.calendar_month, color: Colors.black54),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   "Dates",
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => selectDate(true),
  //                   child: Text(
  //                     _formatDate(checkInDate),
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       color: Colors.blue,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //                 const Text(" - "),
  //                 GestureDetector(
  //                   onTap: () => selectDate(false),
  //                   child: Text(
  //                     _formatDate(checkOutDate),
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       color: Colors.blue,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //
  //         const Divider(height: 25),
  //
  //         // Guest Row
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: const [
  //                 Icon(Icons.people_outline, color: Colors.black54),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   "Guest",
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ],
  //             ),
  //             const Text(
  //               "1 room • 1 guest",
  //               style: TextStyle(
  //                 fontSize: 15,
  //                 color: Colors.blue,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         const Divider(height: 25),
  //
  //         // Booking for Row
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: const [
  //                 Icon(Icons.person_outline, color: Colors.black54),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   "Booking for",
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               ],
  //             ),
  //             const Text(
  //               "Rohit",
  //               style: TextStyle(
  //                 fontSize: 15,
  //                 color: Colors.blue,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
