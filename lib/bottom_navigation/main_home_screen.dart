import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/bottom_navigation/search_screen.dart';

import '../profile_screen.dart';
import '../room_details_screen.dart';
import '../widgets/custom_widget.dart';
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  List roomDetails = [
    {
      "imageUrl":
      "https://cache.marriott.com/marriottassets/marriott/KULDT/kuldt-guestroom-0065-hor-clsc.jpg?interpolation=progressive-bilinear&",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
    {
      "imageUrl":
      "https://th.bing.com/th/id/R.b728f21f7c5bf2562b495ae8cf595585?rik=4EmhAElBy1VZ%2bg&riu=http%3a%2f%2fwww.marinabaysands.com%2fcontent%2fdam%2fsingapore%2fmarinabaysands%2fmaster%2fmain%2fhome%2fhotel%2fsuites%2fdeluxe-room-city-view.jpg&ehk=ijHur6xSM0heSb4ZIklf7ghlXkKiKAX7qJ5xblZXN0A%3d&risl=&pid=ImgRaw&r=0",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
    {
      "imageUrl":
      "https://th.bing.com/th/id/R.b728f21f7c5bf2562b495ae8cf595585?rik=4EmhAElBy1VZ%2bg&riu=http%3a%2f%2fwww.marinabaysands.com%2fcontent%2fdam%2fsingapore%2fmarinabaysands%2fmaster%2fmain%2fhome%2fhotel%2fsuites%2fdeluxe-room-city-view.jpg&ehk=ijHur6xSM0heSb4ZIklf7ghlXkKiKAX7qJ5xblZXN0A%3d&risl=&pid=ImgRaw&r=0",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
    {
      "imageUrl":
      "https://th.bing.com/th/id/R.b728f21f7c5bf2562b495ae8cf595585?rik=4EmhAElBy1VZ%2bg&riu=http%3a%2f%2fwww.marinabaysands.com%2fcontent%2fdam%2fsingapore%2fmarinabaysands%2fmaster%2fmain%2fhome%2fhotel%2fsuites%2fdeluxe-room-city-view.jpg&ehk=ijHur6xSM0heSb4ZIklf7ghlXkKiKAX7qJ5xblZXN0A%3d&risl=&pid=ImgRaw&r=0",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
    {
      "imageUrl":
      "https://th.bing.com/th/id/R.b728f21f7c5bf2562b495ae8cf595585?rik=4EmhAElBy1VZ%2bg&riu=http%3a%2f%2fwww.marinabaysands.com%2fcontent%2fdam%2fsingapore%2fmarinabaysands%2fmaster%2fmain%2fhome%2fhotel%2fsuites%2fdeluxe-room-city-view.jpg&ehk=ijHur6xSM0heSb4ZIklf7ghlXkKiKAX7qJ5xblZXN0A%3d&risl=&pid=ImgRaw&r=0",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
    {
      "imageUrl":
      "https://th.bing.com/th/id/R.b728f21f7c5bf2562b495ae8cf595585?rik=4EmhAElBy1VZ%2bg&riu=http%3a%2f%2fwww.marinabaysands.com%2fcontent%2fdam%2fsingapore%2fmarinabaysands%2fmaster%2fmain%2fhome%2fhotel%2fsuites%2fdeluxe-room-city-view.jpg&ehk=ijHur6xSM0heSb4ZIklf7ghlXkKiKAX7qJ5xblZXN0A%3d&risl=&pid=ImgRaw&r=0",
      "rating": "4.6",
      "details": "Super room best design, Near indra gandhi gurgaon new delhi",
    },
  ];

  List city = [
    {
      "imageUrl":
      "https://tse1.mm.bing.net/th/id/OIP.Xdbd6eGTSYsdiwgms62HcQHaHa?pid=ImgDet&w=202&h=202&c=7&dpr=1.3&o=7&rm=3",
      "cityName": "Nearby",
    },
    {
      "imageUrl":
      "https://tse3.mm.bing.net/th/id/OIP.1tANSZrMu2w7Lf1vDk0nXAHaEn?rs=1&pid=ImgDetMain&o=7&rm=3",
      "cityName": "Bangalore",
    },
    {
      "imageUrl":
      "https://tse4.mm.bing.net/th/id/OIP.Hu8KYO__XfezG1HVv9WXewHaFG?rs=1&pid=ImgDetMain&o=7&rm=3",
      "cityName": "Delhi",
    },
    {
      "imageUrl":
      "https://ik.imagekit.io/shortpedia/Voices/wp-content/uploads/2022/07/budha-smiriti-udhyan@tripoto.jpg",
      "cityName": "Patna",
    },
    {
      "imageUrl":
      "https://www.thepackersmovers.com/blog/wp-content/uploads/2017/03/domestic-warehousing-services-in-kolkata-facts-you-must-know.jpg",
      "cityName": "Kolkata",
    },
    {
      "imageUrl":
      "https://lp-cms-production.imgix.net/2019-06/ab5c55eb6f981026230a95dfb052a51d-taj-mahal-palace-mumbai.jpg?auto=format&q=40&ar=16:9&fit=crop&crop=center&fm=auto&w=5500",
      "cityName": "Mumbai",
    },
    {
      "imageUrl":
      "https://i0.wp.com/www.winmeen.com/wp-content/uploads/2020/02/Chennai-Corporation.png?ssl=1",
      "cityName": "Chennai",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("VIP HOTEL"), titleSpacing: 70),
        drawer: Drawer(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("User Name"),
                  subtitle: Text("558557854745"),
                ),
              ),
              Container(height: 1, width: double.infinity, color: Colors.black),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.search,size: 30,),
                        SizedBox(width: 10,),
                        Text("Search City",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: city.length,
                    itemBuilder: (context, index) {
                      var data = city[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Column(
                          children: [
                            InkWell(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                  "${data["imageUrl"]}",
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),));
                              },
                            ),
                            SizedBox(height: 10),
                            Text("${data["cityName"]}"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: roomDetails.length,
                  itemBuilder: (context, index) {
                    var data = roomDetails[index];
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RoomDetailsScreen(),));
                              },
                              child: Image.network(
                                data["imageUrl"],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      data["rating"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  data["details"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
