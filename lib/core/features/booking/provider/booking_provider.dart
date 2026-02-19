import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/booking_model_screen.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> fetchBookings(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://hotelbooking.edugaondev.com/api/booking/user/$userId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _bookings = data.map((json) => Booking.fromJson(json)).toList();
      } else {
        // handle error
        print("Error fetching bookings: ${response.body}");
      }
    } catch (e) {
      print("Exception fetching bookings: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
