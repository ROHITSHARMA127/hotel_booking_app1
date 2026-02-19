import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/auth/data/auth_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget/bottom_navigation.dart';
import '../../hotel/data/hotel_model_screen.dart';
import '../view/login_screen.dart';

class AuthProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedGender = "";
  String selectMaritalStatus = "married";

  String name = "";
  String email = "";
  String password = "";

  // LOGIN (calls AuthHelper.login and saves userId + token)
  //

  // LOGIN
  Future<void> loginNow(BuildContext context) async {
    final data = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final res = await AuthApiServices.login(data);

    if (res != null) {
      final prefs = await SharedPreferences.getInstance();

      int? userId;
      String? token;

      if (res['user'] != null && res['user']['id'] is int) {
        userId = res['user']['id'];
      }

      if (res.containsKey('token')) token = res['token']?.toString();

      await prefs.setBool("login_status_key", true);
      await prefs.setString("email_key", data["email"]!);
      await prefs.setString("password_key", data["password"]!);

      if (userId != null) await prefs.setInt("userId", userId);
      if (token != null) await prefs.setString("auth_token", token);

      final serverName =
          res['user']?['name']?.toString() ?? res['name']?.toString() ?? "";

      await prefs.setString("name_key", serverName);

      // 🔥 Provider state update
      name = serverName;
      email = data["email"]!;
      password = data["password"]!;
      notifyListeners();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful")));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
            (route) => false,
      );
      emailController.clear();
      passwordController.clear();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Email or Password")));
    }
  }


  // SIGNUP
  Future<void> signupNow(BuildContext context) async {
    final data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "gender": selectedGender,
      "marital": selectMaritalStatus,
    };

    final res = await AuthApiServices.signup(data);

    if (res != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("password_key", data["password"]!);
      await prefs.setString("gender_key", selectedGender);
      await prefs.setString("marital_key", selectMaritalStatus);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));

      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup Failed")));
    }
  }

  // LOCAL update: update provider state & SharedPreferences
  Future<void> updateProfile(String newName, String newEmail, String newGender, String newMarital) async {
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


  // DELETE PROFILE (local clear)
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

  // LOAD DATA from SharedPreferences
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
