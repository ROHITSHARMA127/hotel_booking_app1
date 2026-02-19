class Booking {
  final int id;
  final String hotelName;
  final String city;
  final String roomName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.hotelName,
    required this.city,
    required this.roomName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      hotelName: json['hotel_name'] ?? "",
      city: json['city'] ?? "",
      roomName: json['room_name'] ?? "",
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      guests: json['guests'] ?? 0,
      totalPrice: double.parse((json['total_price'] ?? 0).toString()),

      // yahi main fix hai
      status: json['status'] ?? "pending",
    );
  }

  Booking copyWith({
    String? status,
  }) {
    return Booking(
      id: id,
      hotelName: hotelName,
      city: city,
      roomName: roomName,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      totalPrice: totalPrice,
      status: status ?? this.status,
    );
  }
}
