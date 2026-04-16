import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/hotel/data/hotel_model_screen.dart';
import 'package:hotel_booking_app/core/features/room/data/room_model_screen.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../../booking/view/Booking_confirmed_screen.dart';
import '../../booking/data/booking_api_services.dart';
import '../../rating/data/rating_api_services.dart';
import '../data/room_api_services.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int hotelId;
  final String hotelName;
  final String hotelPrice;
  final String hotelAmenities;
  final String hotelAbout;

  const RoomDetailsScreen({
    super.key,
    required this.hotelId,
    required this.hotelName,
    required this.hotelPrice,
    required this.hotelAmenities,
    required this.hotelAbout,
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

  int guests = 1;
  TextEditingController bookingNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    roomsFuture = RoomApiServices.fetchRooms(widget.hotelId);
    hotelRatingFuture = RatingApiServices.fetchHotelRating(widget.hotelId);
    Provider.of<AuthProvider>(context, listen: false).getData();
  }

  Future<void> pickDate({required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
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
          if (rooms.isNotEmpty && selectedRoom == null) {
            selectedRoom = rooms.first;
          }

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 180),
                children: [
                  /// ================= ROOMS LIST =================
                  ...rooms.map((room) {
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
                            child: Image.network(
                              room.imageUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      "Available Rooms: ${room.availableRooms}",
                                      style: TextStyle(
                                        color: room.availableRooms > 0
                                            ? Colors.blue
                                            : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          selectedRoom == room
                                              ? "Selected"
                                              : "Select",
                                          style: TextStyle(
                                            color: selectedRoom == room
                                                ? Colors.white
                                                : Colors.black,
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
                  }).toList(),

                  /// ================= BOOKING DETAILS =================
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your booking details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => pickDate(isCheckIn: true),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.date_range_sharp),
                                      SizedBox(width: 10),
                                      Text(
                                        "Dates",
                                        style: TextStyle(
                                        ),
                                      ),
                                      SizedBox(width: 100),
                                      Text(
                                        "${checkInDate.day}-${checkInDate.month}-${checkInDate.year}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                        ),
                                      ),
                                      Text(" - "),
                                      Text(
                                        "${checkOutDate.day}-${checkOutDate.month}-${checkOutDate.year}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person_rounded),
                                    SizedBox(width: 10),
                                    Text(
                                      "Guest",
                                      style: TextStyle(
                                      ),
                                    ),
                                    SizedBox(width: 180),
                                    GestureDetector(
                                      onTap: guests > 1
                                          ? () => setState(() => guests--)
                                          : null,
                                      child: Icon(Icons.remove,color: Colors.blue,),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      guests.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => setState(() => guests++),
                                      child: Icon(Icons.add,color: Colors.blueAccent,),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person_rounded),
                                    SizedBox(width: 10),
                                    Text(
                                      "Booking for",
                                      style: TextStyle(

                                      ),
                                    ),
                                    SizedBox(width: 140),
                                    Consumer<AuthProvider>(
                                      builder: (context, provider, child ){
                                        return Text(provider.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent),);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ================= AMENITIES =================
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Amenities",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: 8),
                        Text(widget.hotelAmenities),
                         SizedBox(height: 16),
                         Text(
                          "About Hotel",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: 8),
                        Text(widget.hotelAbout,),
                      ],
                    ),
                  ),
                ],
              ),

              /// ================= BOTTOM BAR =================
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
                          const Text("Total Price"),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () async {
                            if (selectedRoom == null) return;

                            final result =
                                await BookingApiService.createBooking(
                                  userId: 1,
                                  hotelId: widget.hotelId,
                                  roomId: selectedRoom!.id,
                                  checkIn: checkInDate.toIso8601String().split(
                                    "T",
                                  )[0],
                                  checkOut: checkOutDate
                                      .toIso8601String()
                                      .split("T")[0],
                                  totalPrice: double.parse(widget.hotelPrice),
                                  guests: guests,
                                  bookingName: bookingNameController.text,
                                );

                            if (result["message"] ==
                                "Booking created successfully") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingConformedScreen(
                                    bookingId: result["booking_id"],
                                    room: selectedRoom!,
                                    //hotel: selectedHotel!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("Book Now",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
