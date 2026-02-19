// import 'package:flutter/material.dart';
// import 'package:hotel_booking_app/bottom_navigation/hotel_list_screen.dart';
// import 'package:hotel_booking_app/bottom_navigation/search_screen.dart';
// import 'package:hotel_booking_app/login_screen.dart';
// import 'package:hotel_booking_app/profile_screen.dart';
// import 'package:hotel_booking_app/register_screen.dart';
// import 'package:hotel_booking_app/room_details_screen.dart';
// import 'package:hotel_booking_app/splash_screen.dart';
// import 'package:provider/provider.dart';
//
// import 'auth_provider/auth_provider.dart';
// import 'bottom_navigation/bottom_navigation.dart';
// import 'help_chat_screen.dart';
//
// void main()
// {
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(create: (context) => AuthProvider(),)
//   ],
//     child: Myapp(),
//   ));
// }
// class Myapp extends StatelessWidget {
//   const Myapp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/hotel/provider/hotel_provider.dart';
import 'package:hotel_booking_app/core/features/room/provider/room_provider.dart';
import 'package:hotel_booking_app/core/features/hotel/view/hotel_list_screen.dart';
import 'package:hotel_booking_app/core/features/search/view/search_screen.dart';
import 'package:hotel_booking_app/core/features/auth/view/login_screen.dart';
import 'package:hotel_booking_app/core/features/auth/view/profile_screen.dart';
import 'package:hotel_booking_app/core/features/auth/view/register_screen.dart';
import 'package:hotel_booking_app/core/features/payment/view/payment_screen.dart';
import 'package:hotel_booking_app/core/features/room/view/room_details_screen.dart';
import 'package:hotel_booking_app/core/features/auth/view/splash_screen.dart';
import 'package:provider/provider.dart';

import 'core/features/auth/provider/auth_provider.dart';
import 'core/features/booking/provider/booking_provider.dart';
import 'core/widget/bottom_navigation.dart';
import 'core/features/help/view/help_chat_screen.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {

  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HotelProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
