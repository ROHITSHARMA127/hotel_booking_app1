import 'package:flutter/material.dart';
import 'package:hotel_booking_app/bottom_navigation/main_home_screen.dart';
import 'package:hotel_booking_app/bottom_navigation/search_screen.dart';
import 'package:hotel_booking_app/login_screen.dart';
import 'package:hotel_booking_app/profile_screen.dart';
import 'package:hotel_booking_app/register_screen.dart';
import 'package:hotel_booking_app/room_details_screen.dart';
import 'package:hotel_booking_app/splash_screen.dart';
import 'package:provider/provider.dart';

import 'auth_provider/auth_provider.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'help_chat_screen.dart';

void main()
{
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider(),)
  ],
    child: Myapp(),
  ));
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
