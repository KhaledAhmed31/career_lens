enum MessageRole { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    required this.createdAt,
  });

  final MessageRole role;
  final String text;
  final DateTime createdAt;
}
