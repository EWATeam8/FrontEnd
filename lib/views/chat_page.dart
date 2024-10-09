import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manufacturer/logic/manufacturer.interface.dart';
import 'package:manufacturer/models/chat.model.dart';
import 'package:manufacturer/models/product.model.dart';
import 'package:manufacturer/theme/theme.dart';
import 'package:manufacturer/views/orders_page.dart';

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
    Chat(message: "bye", dateTime: DateTime.now(), fromBot: false),
    Chat(message: "Sayonara", dateTime: DateTime.now(), fromBot: true),
    Chat(message: "Adios", dateTime: DateTime.now(), fromBot: true),
  ];
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final DateFormat _dateFormat = DateFormat.Hm();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    setState(() {
      _messages
          .add(Chat(message: text, dateTime: DateTime.now(), fromBot: false));
      if (text.toLowerCase().contains('recommend')) {
        _addRecommendations();
      } else {
        _messages.add(Chat(
          message:
              "I'm sorry, I don't understand. Try asking for recommendations.",
          dateTime: DateTime.now(),
          fromBot: true,
        ));
      }
    });
    _focusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  void _addRecommendations() {
    List<Product> recommendations = ManufacturerService.products.sublist(0, 1);
    for (var product in recommendations) {
      _messages.add(Chat(
        message: '',
        dateTime: DateTime.now(),
        fromBot: true,
        product: product,
      ));
    }
  }

  Widget _buildMessage(Chat chat) {
    if (chat.product != null) {
      return _buildProductRecommendation(chat);
    } else if (!chat.fromBot) {
      return _buildUserMessage(chat);
    } else {
      return _buildBotMessage(chat);
    }
  }

  Widget _buildUserMessage(Chat chat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 131, 97, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  chat.message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _dateFormat.format(chat.dateTime),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotMessage(Chat chat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  chat.message,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _dateFormat.format(chat.dateTime),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductRecommendation(Chat chat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(chat.product!.imageUrl,
                        height: 100, width: 100, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text(
                      chat.product!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      chat.product!.description,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _dateFormat.format(chat.dateTime),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Talk to your bot'),
        backgroundColor: Colors.white12,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Row(
        children: [
          Container(
            color: Colors.white12,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {},
                  iconSize: 32,
                  color: Colors.white,
                  icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                ),
                const SizedBox(
                  height: 5,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(OrdersPage.routeID);
                  },
                  color: Colors.white,
                  iconSize: 32,
                  icon: const Icon(CupertinoIcons.cube_box_fill),
                ),
                const SizedBox(
                  height: 5,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(OrdersPage.routeID);
                  },
                  color: Colors.white,
                  iconSize: 32,
                  icon: const Icon(CupertinoIcons.cart_fill),
                ),
                const SizedBox(
                  height: 5,
                ),
                IconButton(
                  onPressed: () {},
                  color: Colors.white,
                  iconSize: 32,
                  icon: const Icon(CupertinoIcons.question_circle_fill),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    reverse: false,
                    itemBuilder: (_, int index) =>
                        _buildMessage(_messages[index]),
                    itemCount: _messages.length,
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: AppTheme.accentColor),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                hintText: "Ask to get suggestions...",
                fillColor: Colors.white12,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 15,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            color: Colors.white12,
            child: IconButton(
              icon: const Icon(CupertinoIcons.paperplane_fill),
              iconSize: 32,
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: false,
  //       title: const Text('Talk to your bot'),
  //       elevation: 0,
  //       actions: [
  //         IconButton(
  //           onPressed: () {
  //             Navigator.of(context).pushNamed(OrdersPage.routeID);
  //           },
  //           icon: const Icon(CupertinoIcons.cube_box_fill),
  //         ),
  //       ],
  //     ),
  //     body: Row(
  //       children: [
  //         Container(
  //           color: Colors.red,
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 12,
  //             vertical: 16,
  //           ),
  //           child: Column(
  //             children: [
  //               IconButton(
  //                 onPressed: () {},
  //                 iconSize: 30,
  //                 icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
  //               ),
  //               IconButton(
  //                 onPressed: () {},
  //                 iconSize: 30,
  //                 icon: const Icon(CupertinoIcons.question_circle_fill),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: ListView.builder(
  //                   padding: const EdgeInsets.symmetric(vertical: 15),
  //                   itemCount: _messages.length,
  //                   itemBuilder: (context, index) {
  //                     return ChatBubble(chat: _messages[index]);
  //                   },
  //                 ),
  //               ),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextField(
  //                       controller: _messageController,
  //                       decoration: const InputDecoration(
  //                         contentPadding: EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 25,
  //                         ),
  //                         hintText: 'Type a message',
  //                         border: InputBorder.none,
  //                         enabledBorder: InputBorder.none,
  //                         focusedBorder: InputBorder.none,
  //                         fillColor: Colors.red,
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 66,
  //                     color: Colors.red,
  //                     child: IconButton(
  //                       icon: const Icon(Icons.send),
  //                       onPressed: _sendMessage,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
// }
