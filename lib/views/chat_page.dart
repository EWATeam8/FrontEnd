import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:manufacturer/constants/constants.dart';
import 'package:manufacturer/models/chat.model.dart';
import 'package:manufacturer/theme/theme.dart';
import "package:http/http.dart" as http;
import 'package:manufacturer/widgets/recommendation_widgets.dart';

class ChatPage extends StatefulWidget {
  static const routeID = '/chatPage';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Chat> _messages = [];
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String chatStatus = 'ended';

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _startPollingMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() async {
    setState(() {
      _messages.add(Chat(
        message: "Hello! How can I help you today? Please choose an option:",
        dateTime: DateTime.now(),
        fromBot: true,
        options: [
          "Suggest some products",
          "Show me the product catelog",
          "Tell me about your return policy"
        ],
      ));
    });
    String apiEndpoint;
    Map<String, dynamic> requestBody;

    apiEndpoint = 'http://localhost:5008/api/start_chat';
    requestBody = {
      ...initialChatRequest,
      'message': "hello",
    };

    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send request');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  void _startPollingMessages() {
    const duration = Duration(seconds: 1);
    Future.doWhile(() async {
      await Future.delayed(duration);
      await _fetchMessages().then((_) {
        Future.delayed(const Duration(milliseconds: 10), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        });
      });

      return true; // Continue polling
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5008/api/get_message'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['message'] != null) {
          if (data['message']['user'] != 'User_Proxy') {
            setState(() {
              _messages.add(Chat(
                message: data['message']['message'],
                dateTime: DateTime.now(),
                fromBot: data['message']['user'] != 'User_Proxy',
              ));
            });
          }
        }
        setState(() {
          chatStatus = data['chat_status'];
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> _handleSubmitted(String text) async {
    _messageController.clear();
    setState(() {
      _messages
          .add(Chat(message: text, dateTime: DateTime.now(), fromBot: false));
    });

    String apiEndpoint;
    Map<String, dynamic> requestBody;

    if (chatStatus == 'Chat ongoing' || chatStatus == 'inputting') {
      apiEndpoint = 'http://localhost:5008/api/send_message';
      requestBody = {'message': text};
    } else {
      apiEndpoint = 'http://localhost:5008/api/start_chat';
      requestBody = {
        ...initialChatRequest,
        'message': text,
      };
    }

    try {
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send request');
      }
    } catch (e) {
      print('Error sending request: $e');
    }

    _focusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(Chat chat) {
    if (chat.products != null) {
      return buildProductRecommendations(chat);
    } else if (!chat.fromBot) {
      return buildUserMessage(chat);
    } else {
      return buildBotMessage(chat, _handleSubmitted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AutoParts Bot'),
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
                // IconButton(
                //   onPressed: () {},
                //   color: Colors.white,
                //   iconSize: 32,
                //   icon: const Icon(CupertinoIcons.cube_box_fill),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 8),
                    reverse: false,
                    itemBuilder: (_, int index) =>
                        _buildMessage(_messages[index]),
                    itemCount: _messages.length,
                  ),
                ),
                !_messages.last.fromBot
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 131, 97, 255),
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset("assets/animations/loading.json"),
                      )
                    : const SizedBox(),
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
