import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;

class RatingApiServices {
  // Hotel की rating fetch करना
  static Future<Map<String, dynamic>> fetchHotelRating(int hotelId) async {
    final res = await http.get(Uri.parse("https://hotelbooking.edugaondev.com/api/rating/hotel/$hotelId"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // API return करती है: { "rating": 4.6, "total_reviews": 537 }
      return {
        "rating": (data['rating'] ?? 0).toDouble(),
        "total_reviews": data['total_reviews'] ?? 0,
      };
    } else {
      throw Exception("Failed to load hotel rating");
    }
  }
}

