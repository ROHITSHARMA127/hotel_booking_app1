import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      getData();
    });
  }

  getData()async{
    var sharePreference =await SharedPreferences.getInstance(); // object created
    bool status = sharePreference.getBool("login_status_key")??false;
    if(status){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Image.network("https://d1csarkz8obe9u.cloudfront.net/posterpreviews/vip-hotel-logo-design-template-eb72f8981df652fe0be27a9a517ae471_screen.jpg?ts=1660122446",fit: BoxFit.fill,))
    );
  }
}
