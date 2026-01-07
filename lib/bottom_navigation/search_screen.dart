import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List cityName = [
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

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(Duration(days: 1));
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
        checkOutDate = picked.add(Duration(days: 1)); // default 1 night
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SEARCH HEADER
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search for City",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// ---- DATE ROW ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// TODAY / CHECK-IN
                      TextButton(
                        onPressed: pickCheckInDate,
                        child: Text(formatDate(checkInDate!)),
                      ),

                      /// Nights Count
                      Text("${getNights()}N"),

                      /// TOMORROW / CHECK-OUT
                      TextButton(
                        onPressed: pickCheckOutDate,
                        child: Text(formatDate(checkOutDate!)),
                      ),

                      Container(height: 20, width: 1, color: Colors.grey),

                      /// Rooms & Guests (static for now)
                      TextButton(
                        onPressed: () {},
                        child: const Text("1 room 1 guest"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Search Hotels",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// City list
            Expanded(
              child: ListView.builder(
                itemCount: cityName.length,
                itemBuilder: (context, index) {
                  var cityData = cityName[index];
                  return TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_sharp),
                          SizedBox(width: 10),
                          Text("$cityData"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
