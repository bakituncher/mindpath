import 'package:flutter/material.dart';
import 'package:mindpath/core/constants/app_colors.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _messages.add(ChatMessage(
      text: 'Merhaba! Ben senin kişisel farkındalık asistanınım. Bugün sana nasıl yardımcı olabilirim?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    // Simulate AI response
    _simulateAIResponse(userMessage.text);

    _messageController.clear();
    _scrollToBottom();
  }

  void _simulateAIResponse(String userMessage) {
    // Simple keyword-based responses
    String response = '';

    if (userMessage.toLowerCase().contains('kaygı') ||
        userMessage.toLowerCase().contains('stres')) {
      response = 'Kaygı hissetmek normaldir. Hadi birlikte kısa bir nefes alalım. '
          '4-7-8 nefes tekniğini denemek ister misin?';
    } else if (userMessage.toLowerCase().contains('uyku')) {
      response = 'Uyku sorunu yaşıyorsun. Sana uyku öncesi gevşeme meditasyonu önerebilirim. '
          'Ayrıca uyku hikayelerimize göz atabilirsin.';
    } else if (userMessage.toLowerCase().contains('odaklan')) {
      response = 'Odaklanma konusunda yardımcı olabilirim. 2 dakikalık odak meditasyonu '
          'veya Box Breathing tekniği sana iyi gelebilir.';
    } else {
      response = 'Anlıyorum. Her duygu geçerlidir ve kabul edilmeye değerdir. '
          'Bu duyguyla bir süre kalmaya ne dersin?';
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Mind Coach'),
            Text(
              'Kişisel farkındalık asistanın',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),

          // Quick Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction('😌 Kaygılıyım'),
                  const SizedBox(width: 8),
                  _buildQuickAction('🎯 Odaklanamıyorum'),
                  const SizedBox(width: 8),
                  _buildQuickAction('😴 Uyuyamıyorum'),
                  const SizedBox(width: 8),
                  _buildQuickAction('💭 Zihin dolu'),
                ],
              ),
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Mesajını yaz...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGray.withOpacity(0.3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.pastelGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.white),
                      onPressed: _sendMessage,
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

  Widget _buildQuickAction(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.pastelGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.pastelGreen.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AppColors.darkGray),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pastelGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 20,
                color: AppColors.pastelGreen,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.pastelGreen
                    : AppColors.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      Radius.circular(message.isUser ? 20 : 4),
                  bottomRight:
                      Radius.circular(message.isUser ? 4 : 20),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? AppColors.white : AppColors.darkGray,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

