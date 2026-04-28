import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._remoteDataSource);

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Future<ChatMessage> sendMessage({
    required List<ChatMessage> history,
    required String input,
  }) async {
    final remoteResponse = await _remoteDataSource.sendMessage(
      history: history.map(ChatMessageModel.fromDomain).toList(),
      input: input,
    );
    return remoteResponse.toDomain();
  }
}
