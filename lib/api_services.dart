import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {

  // login

  static Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    try {
      var res = await http.post(
        Uri.parse("https://online-users-e1o8.onrender.com/api/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.body);
        return jsonResponse;
      } else {
        print("Login failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during login: $e");
    }
    return null;
  }

  //register

  static Future<Map<String, dynamic>?> signup(Map<String, dynamic> data) async {
    try {
      var res = await http.post(
        Uri.parse("https://online-users-e1o8.onrender.com/api/user/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        var jsonResponse = jsonDecode(res.body);
        return jsonResponse;
      } else {
        print("Signup failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during signup: $e");
    }
    return null;
  }

// get profile


  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) return null;

      var res = await http.get(
        Uri.parse("https://online-users-e1o8.onrender.com/api/user/profile/:id"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        print("Get profile failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in getProfile: $e");
    }
    return null;
  }

// update profile

  static Future<bool> updateProfile(String name, String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) return false;

      var res = await http.put(
        Uri.parse("https://online-users-e1o8.onrender.com/api/user/profile/:id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
        }),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        print("Update profile failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during updateProfile: $e");
    }
    return false;
  }



}

