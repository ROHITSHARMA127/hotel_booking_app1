import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../hotels_models/hotel_model_screen.dart';
import '../rooms_models/room_model_screen.dart';

class AuthHelper {
  static const String baseUrl =
      "http://hotelbooking.edugaondev.com/api/user";


  // LOGIN
  static Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        print("Login failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during login: $e");
    }
    return null;
  }

  // SIGNUP
  static Future<Map<String, dynamic>?> signup(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
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
      final prefs = await SharedPreferences.getInstance();


      final int? userId = prefs.getInt("userId");
      if (userId == null) {
        print("getProfile: no userId saved");
        return null;
      }

      final token = prefs.getString("auth_token");
      final uri = Uri.parse("$baseUrl/profile/$userId");

      final res = await http.get(uri, headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        print("Get profile failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error in getProfile: $e");
    }
    return null;
  }


// update profile
  static Future<bool> updateProfile(String name, String email, {String? gender, String? marital}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt("userId");
      if (userId == null) {
        print("updateProfile: no userId saved");
        return false;
      }

      final token = prefs.getString("auth_token");
      final uri = Uri.parse("$baseUrl/profile/$userId");

      final body = <String, dynamic>{
        "name": name,
        "email": email,
      };
      if (gender != null) body["gender"] = gender;
      if (marital != null) body["marital"] = marital;

      final res = await http.put(
        uri,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        print("updateProfile failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during updateProfile: $e");
    }
    return false;
  }

  // Hotel api............

  static Future<List<HotelModel>> fetchHotels() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl"));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => HotelModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load hotels");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Rooms api...........


  static Future<List<RoomModel>> fetchRooms(int hotelId) async {
    final res = await http.get(Uri.parse("$baseUrl/$hotelId"));

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => RoomModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load rooms");
    }
  }

}