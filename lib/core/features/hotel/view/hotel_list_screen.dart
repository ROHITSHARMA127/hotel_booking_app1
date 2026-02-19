import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/auth/provider/auth_provider.dart';
import 'package:hotel_booking_app/core/features/google_map/view/map_screen.dart';
import 'package:hotel_booking_app/core/features/hotel/provider/hotel_provider.dart'
    hide HotelApiServices;
import 'package:hotel_booking_app/core/features/auth/view/profile_screen.dart';
import 'package:hotel_booking_app/core/features/search/view/search_screen.dart';
import 'package:hotel_booking_app/core/features/payment/view/payment_screen.dart';
import 'package:hotel_booking_app/core/features/room/view/room_details_screen.dart';
import 'package:provider/provider.dart';

import '../data/hotel_api_services.dart';
import 'search_hotel_screen.dart';
import '../../../widget/drawer_class.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  final List<Map<String, String>> cities = [
    {"name": "Bangalore", "image": "assets/banglore.jpg"},
    {"name": "Patna", "image": "assets/Patna.jpg"},
    {"name": "Delhi", "image": "assets/newdelhi.jpg"},
    {"name": "Kolkata", "image": "assets/kolkata.jpg"},
    {"name": "Chennai", "image": "assets/chennai.jpg"},
    {"name": "Mumbai", "image": "assets/mumbai.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HotelProvider>(context, listen: false).getHotels();
      Provider.of<AuthProvider>(context, listen: false).getData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFF512F), Color(0xffDD2476)],
            ),
          ),
        ),
        title: const Text(
          "Rx HOTEL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(child: AppDrawer()),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // 🔍 Search Bar
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchScreen()),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        "Search your city",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🌆 Cities List
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SearchHotelScreen(keyword: city["name"]!),
                            ),
                          );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xffFF512F), Color(0xffDD2476)],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage(city["image"]!),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            city["name"]!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 🏨 Hotel List
            Expanded(
              child: Consumer<HotelProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.hotels.isEmpty) {
                    return const Center(child: Text("No Hotels Found"));
                  }

                  return ListView.builder(
                    itemCount: provider.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = provider.hotels[index];
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
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🖼 Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      hotel.imageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(hotel.rating.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 📄 Details
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      hotel.location,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      hotel.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "₹${hotel.price}/night",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
