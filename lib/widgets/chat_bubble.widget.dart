import 'package:flutter/material.dart';
import 'package:manufacturer/models/chat.model.dart';

class ChatBubble extends StatelessWidget {
  final Chat chat;

  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chat.fromBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              chat.fromBot ? Colors.grey[300] : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          chat.message,
          style: TextStyle(
            color: chat.fromBot ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
