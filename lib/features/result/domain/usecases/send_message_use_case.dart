import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<ChatMessage> call({
    required List<ChatMessage> history,
    required String input,
  }) {
    return _repository.sendMessage(history: history, input: input);
  }
}
