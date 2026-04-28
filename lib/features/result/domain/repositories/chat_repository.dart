import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage({
    required List<ChatMessage> history,
    required String input,
  });
}
