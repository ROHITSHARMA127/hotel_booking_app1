import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/room/view/room_details_screen.dart';

import '../data/hotel_api_services.dart';
import '../data/hotel_model_screen.dart';

class SearchHotelScreen extends StatefulWidget {
  final String keyword;
  const SearchHotelScreen({super.key, required this.keyword});

  @override
  State<SearchHotelScreen> createState() => _SearchHotelScreenState();
}

class _SearchHotelScreenState extends State<SearchHotelScreen> {
  List<HotelModel> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    hotels = await HotelApiServices.searchHotels(widget.keyword);
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Hotels in ${widget.keyword}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hotels.isEmpty
          ? const Center(child: Text("No hotels found"))
          : ListView.builder(
        itemCount: hotels.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoomDetailsScreen(
                    hotelId: hotel.id,
                    hotelName: hotel.name,
                    hotelPrice: hotel.price,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                    child: Stack(
                      children: [
                        Image.network(
                          hotel.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(hotel.rating.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hotel.location,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotel.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${hotel.price}/night",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 14, vertical: 6),
                            //   decoration: BoxDecoration(
                            //     gradient: const LinearGradient(
                            //       colors: [
                            //         Color(0xffFF512F),
                            //         Color(0xffDD2476),
                            //       ],
                            //     ),
                            //     borderRadius:
                            //     BorderRadius.circular(20),
                            //   ),
                            //   child: const Text(
                            //     "Book Now",
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
