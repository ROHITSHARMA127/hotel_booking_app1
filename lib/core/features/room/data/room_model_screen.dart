class RoomModel {
  final int id;
  final int hotelId;
  final String roomType;
  final double price;
  final int totalRooms;
  final int availableRooms;
  final String description;
  final String imageUrl;

  RoomModel({
    required this.id,
    required this.hotelId,
    required this.roomType,
    required this.price,
    required this.totalRooms,
    required this.availableRooms,
    required this.description,
    required this.imageUrl,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      hotelId: json['hotel_id'],
      roomType: json['room_type'],
      price: double.parse(json['price'].toString()),
      totalRooms: json['total_rooms'],
      availableRooms: json['available_rooms'],
      description: json['description'],
      imageUrl: json['image'], // API me key "image" hai
    );
  }
}

