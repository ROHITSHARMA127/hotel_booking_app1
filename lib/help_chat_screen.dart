import 'package:flutter/material.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> messages = [
    {"msg": "I have a problem", "isMe": true},
    {"msg": "What a problem", "isMe": false},
    {"msg": "My room is ver short", "isMe": true},
    {"msg": "Ok I solved your problem", "isMe": false},
    {"msg": "Light not on and AC", "isMe": true},
    {"msg": "What is your room no.", "isMe": false},
  ];

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({"msg": messageController.text, "isMe": true});
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202124),

      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.support_agent, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Support Bot",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isMe = messages[index]["isMe"];

                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    constraints: const BoxConstraints(maxWidth: 260),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xFF9A6CFF)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      messages[index]["msg"],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ------------------- MESSAGE INPUT AREA -------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2B2F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write anything",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF3A3B3F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                GestureDetector(
                  onTap: sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF9A6CFF),
                    radius: 25,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
