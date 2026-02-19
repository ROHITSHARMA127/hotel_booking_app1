import 'dart:convert';

import 'package:http/http.dart' as http;

import 'hotel_model_screen.dart';

class HotelApiServices {

  // Get all hotels

  static Future<List<HotelModel>> fetchHotels() async {
    try {
      final response = await http.get(Uri.parse("https://hotelbooking.edugaondev.com/api/hotels"));
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

  /// Search hotels by location
  static Future<List<HotelModel>> searchHotels(String keyword) async {
    if (keyword.isEmpty) return [];

    try {
      final uri = Uri.https(
        "hotelbooking.edugaondev.com",
        "/api/hotels/search",
        {"location": keyword},
      );

      print("Requesting URL: $uri");

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['hotels'] ?? [];
        return data.map((e) => HotelModel.fromJson(e)).toList();
      } else {
        print("Failed to search hotels: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }
}