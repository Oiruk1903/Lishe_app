import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Chat State
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;

  ChatNotifier(this._ref) : super(const ChatState()) {
    _loadWelcomeMessage();
  }

  void _loadWelcomeMessage() {
    state = state.copyWith(
      messages: [
        ChatMessage(
          id: const Uuid().v4(),
          content:
              'Habari! Mimi ni msaidizi wako wa lishe. Unaweza kuniuliza swali lolote kuhusu vyakula, lishe, au afya. Ninawezaje kukusaidia leo?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final authState = _ref.read(authNotifierProvider);
    final user = authState.user;
    if (user == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return;
    }

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      errorMessage: null,
    );

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 1));

    final botMessage = ChatMessage(
      id: const Uuid().v4(),
      content: _getMockResponse(content),
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, botMessage],
      isLoading: false,
    );
  }

  String _getMockResponse(String userMessage) {
    // Simple mock responses based on keywords
    if (userMessage.toLowerCase().contains('ugali')) {
      return 'Ugali ni chakula cha kiasili cha Tanzania kinachotengenezwa na unga wa mahindi. Ni chanzo cha wanga na kina kalori 150 kwa kila 100g.';
    } else if (userMessage.toLowerCase().contains('lishe')) {
      return 'Lishe ni muhimu kwa afya yako. Unapaswa kula chakula chenye lishe baki, pamoja na matunda na mboga.';
    } else if (userMessage.toLowerCase().contains('maji')) {
      return 'Ni muhimu kunywa maji mengi kila siku, angalau glasi 8. Maji husaidia kumwili mwili na kutoa sumu.';
    } else {
      return 'Asante kwa swali lako. Kwa ushauri wa kina zaidi kuhusu lishe, wasiliana na daktari wa lishe.';
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});
