import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'room_model_screen.dart';

class RoomApiServices {
  static Future<List<RoomModel>> fetchRooms(int hotelId) async {
    final url =
        "https://hotelbooking.edugaondev.com/api/rooms/$hotelId";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      // yahan se actual list nikaalni hai
      final List data = decoded['data'];

      return data.map((e) => RoomModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load rooms");
    }
  }
}
