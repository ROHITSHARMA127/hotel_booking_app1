class HotelModel {
  final int id;
  final String name;
  final String location;
  final String description;
  final String price;
  final String rating;
  final String imageUrl;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      rating: json['rating']?.toString() ?? '0',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}
