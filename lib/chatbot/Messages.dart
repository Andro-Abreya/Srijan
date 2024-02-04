import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment(0, 0),
            constraints: BoxConstraints(minWidth: 150),
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: widget.messages[index]['isUserMessage']
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.messages[index]['isUserMessage']
                      ? [
                          
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          20,
                                        ),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(
                                            widget.messages[index]['isUserMessage']
                                                ? 0
                                                : 20),
                                        bottomLeft: Radius.circular(
                                            widget.messages[index]['isUserMessage']
                                                ? 20
                                                : 0),
                                      ),
                                      color: widget.messages[index]['isUserMessage']
                                          ? const Color.fromARGB(255, 246, 167, 167)
                                          : Colors.grey.withOpacity(0.8)),
                                  constraints: BoxConstraints(
                                      maxWidth: w * 2 / 3, minWidth: w * 1 / 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.messages[index]['isUserMessage']
                                            ? 'You'
                                            : 'Srijan Bot',
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget
                                          .messages[index]['message'].text.text[0])
                                    ],
                                  )),
                            ],
                          ),
                              SizedBox(
                            width: 5,
                          ),
                              Container(
                              width: 35,
                              height: 35,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36),
                                  color: Color.fromARGB(224, 255, 193, 7)),
                              child: Image.asset('assets/images/woman.png')),
                        ]
                      : [
                          Container(
                              width: 35,
                              height: 35,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36),
                                  color: Color.fromARGB(224, 255, 193, 7)),
                              child: Image.asset('assets/images/bot.png')),
                               SizedBox(
                            width: 5,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      20,
                                    ),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(
                                        widget.messages[index]['isUserMessage']
                                            ? 0
                                            : 20),
                                    bottomLeft: Radius.circular(
                                        widget.messages[index]['isUserMessage']
                                            ? 20
                                            : 0),
                                  ),
                                  color: widget.messages[index]['isUserMessage']
                                      ? const Color.fromARGB(255, 246, 167, 167)
                                      : Colors.grey.withOpacity(0.8)),
                              constraints: BoxConstraints(
                                  maxWidth: w * 2 / 3, minWidth: w * 1 / 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.messages[index]['isUserMessage']
                                        ? 'You'
                                        : 'Srijan Bot',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget
                                      .messages[index]['message'].text.text[0])
                                ],
                              )),
                               
                         
                        ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: widget.messages.length);
  }
}
