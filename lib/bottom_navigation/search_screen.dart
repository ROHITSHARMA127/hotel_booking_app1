import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Today")),
                      const Text("1N"),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Tomorrow"),
                      ),
                      Container(height: 20, width: 1, color: Colors.grey),
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
