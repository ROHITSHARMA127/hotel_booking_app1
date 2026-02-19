import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingApiService {
  // Create Booking
  static Future<Map<String, dynamic>> createBooking({
    required int userId,
    required int hotelId,
    required int roomId,
    required String checkIn,
    required String checkOut,
    required double totalPrice,
    required int guests,
  }) async {
    final url = Uri.parse("https://hotelbooking.edugaondev.com/api/booking/create");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "hotel_id": hotelId,
        "room_id": roomId,
        "check_in": checkIn,
        "check_out": checkOut,
        "total_price": totalPrice,
        "guests": guests,
      }),
    );

    return jsonDecode(response.body);
  }

  // User Booking History
  static Future<List<dynamic>> getBookingHistory(int userId) async {
    final url = Uri.parse("https://hotelbooking.edugaondev.com/api/booking/user/$userId");

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["data"];
    } else {
      throw Exception(data["message"]);
    }
  }

  // Single Booking
  static Future<Map<String, dynamic>> getSingleBooking(int bookingId) async {
    final url = Uri.parse("https://hotelbooking.edugaondev.com/api/booking/$bookingId");

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["booking"];
    } else {
      throw Exception(data["message"]);
    }
  }

  // Cancel Booking
  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final url = Uri.parse("https://hotelbooking.edugaondev.com/api/booking/cancel/$bookingId");

    final response = await http.put(url);
    return jsonDecode(response.body);
  }
}
