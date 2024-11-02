import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
          "Show me the product catelog",
          "I want to know my order status",
          "I want to report fraud activity"
        ],
      ));
    });
    String apiEndpoint;
    Map<String, dynamic> requestBody;

    apiEndpoint = 'http://localhost:8080/api/start_chat';
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
          await http.get(Uri.parse('http://localhost:8080/api/get_message'));
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
      apiEndpoint = 'http://localhost:8080/api/send_message';
      requestBody = {'message': text};
    } else {
      apiEndpoint = 'http://localhost:8080/api/start_chat';
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

  Future<void> _handleImageUpload() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Add image message to chat
        setState(() {
          _messages.add(Chat(
            message: _messageController.text.trim(),
            dateTime: DateTime.now(),
            fromBot: false,
            imageFile: image,
          ));
        });

        // For web, we need to handle the image differently
        String? base64Image;
        if (kIsWeb) {
          // Read as bytes and convert to base64
          final bytes = await image.readAsBytes();
          base64Image = base64Encode(bytes);
        } else {
          // For mobile, read file and convert to base64
          final bytes = await File(image.path).readAsBytes();
          base64Image = base64Encode(bytes);
        }

        // Send to backend
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/send_message'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'message': _messageController.text.trim(),
            'image': base64Image
          }),
        );

        _messageController.clear();

        if (response.statusCode != 200) {
          throw Exception('Failed to upload image');
        }
      }
    } catch (e) {
      setState(() {
        _messages.add(Chat(
          message: "Failed to upload image: $e",
          dateTime: DateTime.now(),
          fromBot: false,
        ));
      });
    }
  }

  Widget _buildMessage(Chat chat) {
    if (chat.imageFile != null) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: kIsWeb
                    ? Image.network(
                        // Use Image.network for web
                        chat.imageFile!.path,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        // Use Image.file for mobile
                        File(chat.imageFile!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              if (chat.message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    chat.message,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else if (chat.products != null) {
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            color: Colors.white12,
            child: IconButton(
              icon: const Icon(CupertinoIcons.upload_circle),
              iconSize: 32,
              onPressed: () => _handleImageUpload(),
            ),
          ),
        ],
      ),
    );
  }
}
