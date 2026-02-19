import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:hotel_booking_app/core/features/hotel/data/hotel_api_services.dart';
import '../../hotel/data/hotel_model_screen.dart';
import '../../hotel/view/search_hotel_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> cityName = [
    "Search nearby Hotels",
    "Patna",
    "Delhi",
    "Bangalore",
    "Kolkata",
    "Chennai",
    "Pune",
    "Mumbai",
    "Ranchi",
    "Lucknow",
    "Ahmedabad",
  ];

  TextEditingController searchController = TextEditingController();
  List<String> filteredCities = [];
  List<HotelModel> hotels = [];
  bool isLoading = false;

  DateTime? checkInDate;
  DateTime? checkOutDate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(const Duration(days: 1));
    filteredCities = cityName;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  int getNights() {
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  Future pickCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        checkInDate = picked;
        checkOutDate = picked.add(const Duration(days: 1));
      });
    }
  }

  Future pickCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate!,
      firstDate: checkInDate!,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  void filterCities(String keyword) {
    if (keyword.isEmpty) {
      filteredCities = cityName;
    } else {
      filteredCities = cityName
          .where((city) => city.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  Future<void> searchHotels(String keyword) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (keyword.isEmpty) return;

      setState(() => isLoading = true);
      hotels = await HotelApiServices.searchHotels(keyword);
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Column(
        children: [
          /// COLORFUL HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff6A11CB),
                  Color(0xff2575FC),
                  Color(0xffFF512F),
                  Color(0xffDD2476),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Find Your Perfect Hotel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                /// SEARCH FIELD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search city, area or hotel",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) {
                      filterCities(value);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                /// DATE + ROOM ROW
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: pickCheckInDate,
                        child: Text(
                          formatDate(checkInDate!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "${getNights()}N",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: pickCheckOutDate,
                        child: Text(
                          formatDate(checkOutDate!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Text(
                        "| 1 Room 1 Guest",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /// SEARCH BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (searchController.text.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchHotelScreen(
                              keyword: searchController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Search Hotels",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff2575FC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// CITY LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                var cityData = filteredCities[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xff2575FC),
                      child: Icon(Icons.location_on, color: Colors.white),
                    ),
                    title: Text(
                      cityData,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      searchController.text = cityData;
                      searchHotels(cityData);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
