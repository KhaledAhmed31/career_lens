import '../../domain/entities/chat_message.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> history,
    required String input,
  });
}

class MockChatRemoteDataSource implements ChatRemoteDataSource {
  const MockChatRemoteDataSource();

  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> history,
    required String input,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ChatMessageModel(
      role: MessageRole.assistant,
      text: _mockReply(input),
      createdAt: DateTime.now(),
    );
  }

  String _mockReply(String input) {
    return 'Suggested direction for "$input": focus on skills, '
        'projects, and measurable outcomes.';
  }
}
