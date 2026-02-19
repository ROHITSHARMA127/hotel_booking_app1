import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/bottom_navigation.dart';
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
        body: Center(child:
        Image.asset("assets/Rx hotel logo.jpg",width: 250,height: 250,)),
    );
  }
}
