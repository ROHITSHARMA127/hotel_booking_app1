import 'package:flutter/material.dart';
import 'package:hotel_booking_app/bottom_navigation/main_home_screen.dart';
import 'package:hotel_booking_app/bottom_navigation/search_screen.dart';

import 'booking_screen.dart';
import 'help_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectIndex = 0;

  List <Widget> screen = [
    MainHomeScreen(),
    BookingScreen(),
    SearchScreen(),
    HelpScreen()
  ];

  void onTaped(int index){
    setState(() {
      selectIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: screen[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book),label: "Booking"),
        BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.help_center),label: "Help"),
      ],
        onTap: onTaped,
        currentIndex: selectIndex,
      ),
    ));
  }
}
