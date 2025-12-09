import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/help_chat_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(child: Image.network("https://tse2.mm.bing.net/th/id/OIP.eZneNJi8sOqNdzace-5uzwAAAA?pid=ImgDet&w=202&h=202&c=7&dpr=1.3&o=7&rm=3")),
            SizedBox(height: 200,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.call_sharp,size: 60,),
                    Text("Calls",style: TextStyle(fontSize: 30),)
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.mail,size: 65,),
                    Text("Mail",style: TextStyle(fontSize: 30),)
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SupportChatScreen(),));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.wechat_sharp,size: 65,),
                      Text("Chats",style: TextStyle(fontSize: 30),)
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
