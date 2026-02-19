// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthApiServices {
//   static const String baseUrl =
//       "https://hotelbooking.edugaondev.com/api/user";
//
//
//   // LOGIN
//   static Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
//     try {
//       final res = await http.post(
//         Uri.parse("$baseUrl/login"),
//         body: jsonEncode(data),
//       );
//
//       if (res.statusCode == 200) {
//         return jsonDecode(res.body) as Map<String, dynamic>;
//       } else {
//         print("Login failed: ${res.statusCode} ${res.body}");
//       }
//     } catch (e) {
//       print("Error during login: $e");
//     }
//     return null;
//   }
//
//   // SIGNUP
//   static Future<Map<String, dynamic>?> signup(Map<String, dynamic> data) async {
//     try {
//       final res = await http.post(
//         Uri.parse("$baseUrl/register"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         return jsonDecode(res.body) as Map<String, dynamic>;
//       } else {
//         print("Signup failed: ${res.statusCode} ${res.body}");
//       }
//     } catch (e) {
//       print("Error during signup: $e");
//     }
//     return null;
//   }
//
//
// // get profile
//   static Future<Map<String, dynamic>?> getProfile() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//
//       final int? userId = prefs.getInt("userId");
//       if (userId == null) {
//         print("getProfile: no userId saved");
//         return null;
//       }
//
//       final token = prefs.getString("auth_token");
//       final uri = Uri.parse("$baseUrl/profile/$userId");
//
//       final res = await http.get(uri, headers: {
//         "Content-Type": "application/json",
//         if (token != null) "Authorization": "Bearer $token",
//       });
//
//       if (res.statusCode == 200) {
//         return jsonDecode(res.body) as Map<String, dynamic>;
//       } else {
//         print("Get profile failed: ${res.statusCode} ${res.body}");
//       }
//     } catch (e) {
//       print("Error in getProfile: $e");
//     }
//     return null;
//   }
//
//
// // update profile
//   static Future<bool> updateProfile(String name, String email, {String? gender, String? marital}) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final int? userId = prefs.getInt("userId");
//       if (userId == null) {
//         print("updateProfile: no userId saved");
//         return false;
//       }
//
//       final token = prefs.getString("auth_token");
//       final uri = Uri.parse("$baseUrl/profile/$userId");
//
//       final body = <String, dynamic>{
//         "name": name,
//         "email": email,
//       };
//       if (gender != null) body["gender"] = gender;
//       if (marital != null) body["marital"] = marital;
//
//       final res = await http.put(
//         uri,
//         headers: {
//           "Content-Type": "application/json",
//           if (token != null) "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(body),
//       );
//
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         return true;
//       } else {
//         print("updateProfile failed: ${res.statusCode} ${res.body}");
//       }
//     } catch (e) {
//       print("Error during updateProfile: $e");
//     }
//     return false;
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiServices {
  static const String baseUrl =
      "https://hotelbooking.edugaondev.com/api/user";

  // LOGIN (✅ FIXED)
  static Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json", // ✅ FIX
        },
        body: jsonEncode(data),
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;

        // ✅ SAVE token & userId
        final prefs = await SharedPreferences.getInstance();
        if (decoded["token"] != null) {
          prefs.setString("auth_token", decoded["token"]);
        }
        if (decoded["user"] != null && decoded["user"]["id"] != null) {
          prefs.setInt("userId", decoded["user"]["id"]);
        }

        return decoded;
      } else {
        print("Login failed: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Error during login: $e");
    }
    return null;
  }

  // SIGNUP (NO CHANGE)
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

  // GET PROFILE (NO CHANGE)
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

  // UPDATE PROFILE (NO CHANGE)
  static Future<bool> updateProfile(
      String name,
      String email, {
        String? gender,
        String? marital,
      }) async {
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
}
