// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_services.dart';
// import 'bottom_navigation/bottom_navigation.dart';
// import 'login_screen.dart';
//
// class AuthProvider extends ChangeNotifier {
//   var nameController = TextEditingController();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   String selectedGender = "male";
//   String selectMaritalStatus = "married";
//
//   String name = "";
//   String email = "";
//   String password = "";
//
//
//   Future<void> loginNow(BuildContext context) async {
//     var data = {
//       "email": emailController.text,
//       "password": passwordController.text,
//     };
//
//     var res = await AuthHelper.login(data);
//
//     if (res != null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Login Successfully")));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Login Failed")));
//     }
//     var sharePreference = await SharedPreferences.getInstance();
//     var email = sharePreference.getString("email_key");
//     var password = sharePreference.getString("password_key");
//     if (email == emailController.text.trim() &&
//         password == passwordController.text.trim()) {
//       sharePreference.setBool("login_status_key", true);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => BottomNavigation()));
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login Successful")));
//     }
//     else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login Failed")));
//     }
//   }
//
//   // login(BuildContext context) async {
//   //   var sharePreference = await SharedPreferences.getInstance();
//   //   var email = sharePreference.getString("email_key");
//   //   var password = sharePreference.getString("password_key");
//   //   if (email == emailController.text.trim() &&
//   //       password == passwordController.text.trim()) {
//   //     sharePreference.setBool("login_status_key", true);
//   //     Navigator.push(
//   //         context, MaterialPageRoute(builder: (context) => BottomNavigation()));
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Login Successful")));
//   //   }
//   //   else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Login Failed")));
//   //   }
//   // }
//
//
//
//   signupNow(BuildContext context) async {
//     var data = {
//       "email": emailController.text,
//       "password": passwordController.text,
//       "gender": selectedGender.toString(),
//     };
//     var res = await AuthHelper.signup(data);
//     if (res != null) {
//       // ScaffoldMessenger.of(
//       //   context,
//       // ).showSnackBar(SnackBar(content: Text("SignUp Successfully")));
//     } else {
//       // ScaffoldMessenger.of(
//       //   context,
//       // ).showSnackBar(SnackBar(content: Text("SignUp Failed")));
//     }
//
//     try {
//       var sharePreference = await SharedPreferences.getInstance();
//       await sharePreference.setString(
//           "name_key", nameController.text.toString());
//       await sharePreference.setString(
//           "email_key", emailController.text.toString());
//       await sharePreference.setString(
//           "password_key", passwordController.text.toString());
//       await sharePreference.setString(
//           "gender_key", selectedGender.toString());
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(content: Text("Registration Successful!")));
//     }
//     catch (_) {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(content: Text("Registration failed!")));
//     }
//   }
//
//
//
//
//   // register(BuildContext context) async {
//   //   try {
//   //     var sharePreference = await SharedPreferences.getInstance();
//   //     await sharePreference.setString(
//   //         "name_key", nameController.text.toString());
//   //     await sharePreference.setString(
//   //         "email_key", emailController.text.toString());
//   //     await sharePreference.setString(
//   //         "password_key", passwordController.text.toString());
//   //     await sharePreference.setString(
//   //         "gender_key", selectedGender.toString());
//   //     Navigator.push(
//   //         context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Registration Successful!")));
//   //   }
//   //   catch (_) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text("Registration failed!")));
//   //   }
//   // }
//
//
//
//
//
//   Future<void> updateProfile(String newName, String newEmail, String newGender, String newMarital) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     name = newName;
//     email = newEmail;
//     selectedGender = newGender;
//     selectMaritalStatus = newMarital;
//
//     await prefs.setString("name_key", name);
//     await prefs.setString("email_key", email);
//     await prefs.setString("gender_key", selectedGender);
//     await prefs.setString("marital_key", selectMaritalStatus);
//
//     notifyListeners();
//   }
//
//   Future<void> deleteProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();   // Remove saved data
//
//     name = "";
//     email = "";
//     selectedGender = "male";
//     selectMaritalStatus = "married";
//     notifyListeners();
//   }
//
//
//   getData() async {
//     var sharePreference = await SharedPreferences.getInstance();
//     name = sharePreference.getString("name_key").toString();
//     email = sharePreference.getString("email_key").toString();
//     password = sharePreference.getString("password_key").toString();
//     selectedGender = sharePreference.getString("gender_key") ?? "male";
//     selectMaritalStatus = sharePreference.getString("marital_key") ?? "married";
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_services.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'login_screen.dart';

class AuthProvider extends ChangeNotifier {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String selectedGender = "male";
  String selectMaritalStatus = "married";

  String name = "";
  String email = "";
  String password = "";

  // --------------------------- LOGIN -----------------------------
  Future<void> loginNow(BuildContext context) async {
    var data = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    var res = await AuthHelper.login(data);

    if (res != null) {
      // Save login details
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("login_status_key", true);
      await prefs.setString("email_key", data["email"]!);
      await prefs.setString("password_key", data["password"]!);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Successful")));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => BottomNavigation()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Email or Password")));
    }
  }

  // --------------------------- SIGNUP -----------------------------
  Future<void> signupNow(BuildContext context) async {
    var data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "gender": selectedGender,
      "marital": selectMaritalStatus,
    };

    var res =  await AuthHelper.signup(data);

    if (res != null) {
      // Save registered details
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name_key", data["name"]!);
      await prefs.setString("email_key", data["email"]!);
      await prefs.setString("password_key", data["password"]!);
      await prefs.setString("gender_key", selectedGender);
      await prefs.setString("marital_key", selectMaritalStatus);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup Failed")));
    }
  }

  // --------------------------- UPDATE PROFILE -----------------------------
  Future<void> updateProfile(
      String newName, String newEmail, String newGender, String newMarital) async {
    final prefs = await SharedPreferences.getInstance();

    name = newName;
    email = newEmail;
    selectedGender = newGender;
    selectMaritalStatus = newMarital;

    await prefs.setString("name_key", name);
    await prefs.setString("email_key", email);
    await prefs.setString("gender_key", selectedGender);
    await prefs.setString("marital_key", selectMaritalStatus);

    notifyListeners();
  }

  // --------------------------- DELETE PROFILE -----------------------------
  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    name = "";
    email = "";
    password = "";
    selectedGender = "male";
    selectMaritalStatus = "married";

    notifyListeners();
  }

  // --------------------------- LOAD DATA -----------------------------
  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();

    name = prefs.getString("name_key") ?? "";
    email = prefs.getString("email_key") ?? "";
    password = prefs.getString("password_key") ?? "";
    selectedGender = prefs.getString("gender_key") ?? "male";
    selectMaritalStatus = prefs.getString("marital_key") ?? "married";

    notifyListeners();
  }
}

