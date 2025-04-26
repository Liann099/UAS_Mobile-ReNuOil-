import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatboth/consts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Ganti dengan model Gemini
  late final GenerativeModel _model;
  
  final ChatUser _currentUser = 
      ChatUser(id: '1', firstName: 'Josh', lastName: 'Hartono');

  final ChatUser _gptChatUser = 
      ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    // Inisialisasi model Gemini
    _model = GenerativeModel(
      model: 'gemini-1.5-pro-latest', // atau model lain yang sesuai
      apiKey: GEMINI_API_KEY, // Pastikan ada di consts.dart
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(
          0,
          166,
          126,
          1,
        ),
        title: const Text(
          'Gemini Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    try {
      // Format history chat untuk Gemini
      final chat = _model.startChat(
        history: _messages.reversed.map((m) {
          if (m.user == _currentUser) {
            return Content.text(m.text);
          } else {
            return Content.model([TextPart(m.text)]);
          }
        }).toList(),
      );

      // Kirim pesan terbaru
      final response = await chat.sendMessage(
        Content.text(m.text),
      );

      // Tambahkan respons ke chat
      if (response.text != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: response.text!,
            ),
          );
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: 'Error: ${e.toString()}',
          ),
        );
      });
    } finally {
      setState(() {
        _typingUsers.remove(_gptChatUser);
      });
    }
  }
}