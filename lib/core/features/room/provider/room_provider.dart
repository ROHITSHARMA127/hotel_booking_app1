import 'package:flutter/cupertino.dart';
import 'package:hotel_booking_app/core/features/room/data/room_api_services.dart';

import '../data/room_model_screen.dart';

class RoomProvider extends ChangeNotifier{
  List<RoomModel> rooms = [];
  bool isLoading = false;
  String errorMessage = "";

  // Rooms by Hotel
  Future<void> getRoomsByHotel(int hotelId) async {
    isLoading = true;
    errorMessage = "";
    notifyListeners();

    try {
      final result = await RoomApiServices.fetchRooms(hotelId);
      rooms = result;
    } catch (e) {
      errorMessage = "Failed to load rooms";
      rooms = [];
      debugPrint("RoomProvider Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear rooms (jab hotel change ho)
  void clearRooms() {
    rooms = [];
    notifyListeners();
  }
}