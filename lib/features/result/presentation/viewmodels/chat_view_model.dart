import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_use_case.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel(this._sendMessageUseCase);

  final SendMessageUseCase _sendMessageUseCase;

  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => List<ChatMessage>.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String input) async {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty || _isLoading) return;

    _error = null;
    _messages.add(
      ChatMessage(
        role: MessageRole.user,
        text: trimmedInput,
        createdAt: DateTime.now(),
      ),
    );
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _sendMessageUseCase(
        history: _messages,
        input: trimmedInput,
      );
      _messages.add(response);
    } catch (_) {
      _error = 'Failed to get assistant response.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
