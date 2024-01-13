import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For http library
import 'dart:convert'; // For JSON decoding

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://api.brainshop.ai/get?bid=173331&key=pNkDalUOuZmmwzUg&uid=${mAuth.currentUser?.uid}&msg=${_messageController.text}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        _messages.add(ChatMessage(
          text: data['cnt'].toString(),
          isMe: false,
        ));
      });

      // Process the received data
    } else {
      // Handle error
      _messages.add(ChatMessage(
        text: "Sorry cannot understand your question",
        isMe: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
        _messages.add(ChatMessage(
          text: 'How may I help you Mama...?',
          isMe: false,
        ));
      });
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple[700],
        title: Text(
          "Mama's Assistant",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.purple,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        // border: Border(
        //   top: BorderSide(color: Colors.grey),
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w300)
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,color: Colors.white,),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
          isMe: true,
        ));

        // Simulate a reply from the other person
        // _messages.add(ChatMessage(
        //   text: 'Thanks for your message!',
        //   isMe: false,
        // ));
        fetchData();
        _messageController.clear();
      });
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children:isMe ?[
         
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: isMe
                      ? Color.fromARGB(134, 212, 45, 109)
                      : Color.fromARGB(255, 161, 185, 203),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    softWrap: true,
                    isMe ? 'You' : 'Bloom Bot',
                    style: TextStyle(
                      // backgroundColor: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(top: 5.0),
                    // decoration: BoxDecoration(
                    //     color: isMe
                    //         ? Color.fromARGB(134, 212, 45, 109)
                    //         : Color.fromARGB(255, 121, 158, 187),
                    //     borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        Container(
            width: 35,
            height:35,
           
            child: Image.asset('assets/images/woman.png')),
        ]:[
           Container(
            width: 35,
            height:35,
             padding: EdgeInsets.all(1),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(36), color: Color.fromARGB(224, 255, 193, 7)),
            child: Image.asset('assets/images/bot.png')),
          SizedBox(
            width: 5,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: isMe
                      ? Color.fromARGB(134, 212, 45, 109)
                      : Color.fromARGB(255, 161, 185, 203),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    softWrap: true,
                    isMe ? 'You' : 'Bloom Bot',
                    style: TextStyle(
                      // backgroundColor: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(top: 5.0),
                    // decoration: BoxDecoration(
                    //     color: isMe
                    //         ? Color.fromARGB(134, 212, 45, 109)
                    //         : Color.fromARGB(255, 121, 158, 187),
                    //     borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
