import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/hotel/view/hotel_list_screen.dart';
import 'package:hotel_booking_app/core/features/search/view/search_screen.dart';
import '../features/booking/view/booking_screen.dart';
import '../features/help/view/help_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with TickerProviderStateMixin {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HotelListScreen(),
    BookingHistoryScreen(userId:  1),
    SearchScreen(),
    HelpScreen(),
  ];

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget buildIcon(IconData iconData, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? const LinearGradient(
          colors: [Color(0xffFF512F), Color(0xffDD2476)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSelected ? null : Colors.transparent,
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ]
            : [],
      ),
      child: Icon(
        iconData,
        size: isSelected ? 28 : 24,
        color: isSelected ? Colors.white : Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            onTap: onTapped,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            items: [
              BottomNavigationBarItem(
                  icon: buildIcon(Icons.home_outlined, selectedIndex == 0),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: buildIcon(Icons.book_online_outlined, selectedIndex == 1),
                  label: "Booking"),
              BottomNavigationBarItem(
                  icon: buildIcon(Icons.search_outlined, selectedIndex == 2),
                  label: "Search"),
              BottomNavigationBarItem(
                  icon: buildIcon(Icons.help_outline, selectedIndex == 3),
                  label: "Help"),
            ],
          ),
        ),
      ),
    );
  }
}
