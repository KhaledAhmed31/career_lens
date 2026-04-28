import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.role,
    required super.text,
    required super.createdAt,
  });

  factory ChatMessageModel.fromDomain(ChatMessage message) {
    return ChatMessageModel(
      role: message.role,
      text: message.text,
      createdAt: message.createdAt,
    );
  }

  ChatMessage toDomain() {
    return ChatMessage(role: role, text: text, createdAt: createdAt);
  }
}
