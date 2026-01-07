import 'package:flutter/material.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({super.key});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "₹1302",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "+ ₹143 taxes & fees",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Book now & pay at hotel",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://cache.marriott.com/marriottassets/marriott/KULDT/kuldt-guestroom-0065-hor-clsc.jpg?interpolation=progressive-bilinear&",
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Super Townhouse Sector 47 Near Medanta",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.red, size: 22),
                  const SizedBox(width: 5),
                  const Text(
                    "4.6",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    " (537 ratings) • 33 reviews",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "5.0 · Check-in rating · Delightful experience",
                style: TextStyle(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Plot No 812, Sector 47, Near Medanta Hospital, Gurgaon",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../api/room_api_service.dart';
// import '../models/room_model.dart';
//
// class RoomsScreen extends StatefulWidget {
//   final int hotelId;
//   final String hotelName;
//
//   const RoomsScreen({
//     super.key,
//     required this.hotelId,
//     required this.hotelName,
//   });
//
//   @override
//   State<RoomsScreen> createState() => _RoomsScreenState();
// }
//
// class _RoomsScreenState extends State<RoomsScreen> {
//   final RoomApiService api = RoomApiService();
//   late Future<List<RoomModel>> roomsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     roomsFuture = api.fetchRooms(widget.hotelId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.hotelName} Rooms"),
//       ),
//       body: FutureBuilder<List<RoomModel>>(
//         future: roomsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//
//           final rooms = snapshot.data!;
//
//           if (rooms.isEmpty) {
//             return const Center(child: Text("No rooms available"));
//           }
//
//           return ListView.builder(
//             itemCount: rooms.length,
//             itemBuilder: (context, index) {
//               final room = rooms[index];
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   leading: Image.network(
//                     room.imageUrl,
//                     width: 60,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(room.roomType),
//                   subtitle: Text("₹${room.price} / night"),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

