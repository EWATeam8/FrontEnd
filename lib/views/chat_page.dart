import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manufacturer/models/chat.model.dart';
import 'package:manufacturer/views/orders_page.dart';
import 'package:manufacturer/widgets/chat_bubble.widget.dart';

class ChatPage extends StatefulWidget {
  static const routeID = '/chatPage';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Chat> _messages = [
    Chat(message: "Hello", dateTime: DateTime.now(), fromBot: true),
    Chat(message: "buye", dateTime: DateTime.now(), fromBot: false),
    Chat(message: "Sayonara", dateTime: DateTime.now(), fromBot: true),
    Chat(message: "Adios", dateTime: DateTime.now(), fromBot: true),
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        int random = Random.secure().nextInt(2);
        _messages.add(
          Chat(
            message: _messageController.text.trim(),
            dateTime: DateTime.now(),
            fromBot: random == 0,
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Talk to your bot'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrdersPage.routeID);
            },
            icon: const Icon(CupertinoIcons.cube_box_fill),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {},
                  iconSize: 30,
                  icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                ),
                IconButton(
                  onPressed: () {},
                  iconSize: 30,
                  icon: const Icon(CupertinoIcons.question_circle_fill),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(chat: _messages[index]);
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 25,
                          ),
                          hintText: 'Type a message',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      height: 66,
                      color: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
