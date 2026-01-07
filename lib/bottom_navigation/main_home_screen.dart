import 'package:flutter/material.dart';
import 'package:hotel_booking_app/auth_provider/auth_provider.dart';
import 'package:hotel_booking_app/bottom_navigation/search_screen.dart';
import 'package:provider/provider.dart';



class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {



  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthProvider>().getHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: const Text("VIP HOTEL",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.search),
                      Text("Search your city",style: TextStyle(fontSize: 17),)
                    ],
                  ),
                ),
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.hotels.isEmpty) {
                  return const Center(child: Text("No Hotels Found"));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = provider.hotels[index];
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(child: Image.network(hotel.imageUrl)),
                            Row(
                              children: [
                                Icon(Icons.star,size: 20,color: Colors.red,),
                                Text(hotel.rating),
                              ],
                            ),
                            Text(hotel.description,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(hotel.location,),
                            Text("₹${hotel.price}",style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
