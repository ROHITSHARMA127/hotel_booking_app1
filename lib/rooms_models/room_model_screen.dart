class RoomModel {
  final int id;
  final int hotelId;
  final String roomType;
  final int price;
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
      price: json['price'],
      totalRooms: json['totalRooms'],
      availableRooms: json['availableRooms'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'roomType': roomType,
      'price': price,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
