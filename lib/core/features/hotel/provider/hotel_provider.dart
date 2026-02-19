import 'package:flutter/cupertino.dart';

import '../data/hotel_api_services.dart';
import '../data/hotel_model_screen.dart';

class HotelProvider extends ChangeNotifier{
  List<HotelModel> hotels = [];
  bool isLoading = false;

  Future<void> getHotels() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await HotelApiServices.fetchHotels();
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
}