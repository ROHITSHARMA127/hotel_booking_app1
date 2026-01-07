import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/api_services.dart';
import '../bottom_navigation/bottom_navigation.dart';
import '../hotels_models/hotel_model_screen.dart';
import '../login_screen.dart';

class AuthProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedGender = "male";
  String selectMaritalStatus = "married";

  String name = "";
  String email = "";
  String password = "";

  // LOGIN (calls AuthHelper.login and saves userId + token)
  Future<void> loginNow(BuildContext context) async {
    final data = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final res = await AuthHelper.login(data);

    if (res != null) {
      final prefs = await SharedPreferences.getInstance();


      int? userId;
      String? token;

      try {
        if (res['user'] != null && (res['user']['id'] is int)) {
          userId = res['user']['id'] as int;
        } else if (res['user'] != null && (res['user']['_id'] is String)) {

        }
      } catch (_) {}


      if (res.containsKey('token')) token = res['token']?.toString();

      await prefs.setBool("login_status_key", true);
      await prefs.setString("email_key", data["email"]!);
      await prefs.setString("password_key", data["password"]!);

      if (userId != null) await prefs.setInt("userId", userId);
      if (token != null) await prefs.setString("auth_token", token);

      final serverName = res['user']?['name']?.toString() ?? res['name']?.toString();
      if (serverName != null) await prefs.setString("name_key", serverName);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful")));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavigation()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Email or Password")));
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

    final res = await AuthHelper.signup(data);

    if (res != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name_key", data["name"]!);
      await prefs.setString("email_key", data["email"]!);
      await prefs.setString("password_key", data["password"]!);
      await prefs.setString("gender_key", selectedGender);
      await prefs.setString("marital_key", selectMaritalStatus);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
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
  // ================= HOTELS =================

  List<HotelModel> hotels = [];
  bool isLoading = false;

  Future<void> getHotels() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await AuthHelper.fetchHotels();
      hotels = result;

      debugPrint("Hotels loaded: ${hotels.length}");
    } catch (e) {
      debugPrint("GetHotels Error: $e");
      hotels = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
