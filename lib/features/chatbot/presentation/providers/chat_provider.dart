import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/ai_remote_datasource.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../domain/entities/chat_message.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

// ─── State ────────────────────────────────────────────────────────────────────

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
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;

  ChatNotifier(this._ref) : super(const ChatState()) {
    _loadWelcomeMessage();
  }

  void _loadWelcomeMessage() {
    state = state.copyWith(messages: [
      ChatMessage(
        id: const Uuid().v4(),
        content:
            'Habari! Mimi ni msaidizi wako wa lishe. Unaweza kuniuliza swali lolote kuhusu vyakula, lishe, au afya. Ninawezaje kukusaidia leo?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ]);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final authState = _ref.read(authNotifierProvider);
    if (authState.user == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return;
    }

    // Optimistic: show user message immediately with "sending" status
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
    final typingMsg = ChatMessage(
      id: 'typing',
      content: '...',
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, typingMsg],
      isLoading: true,
      errorMessage: null,
    );

    try {
      final remote = _ref.read(aiRemoteDataSourceProvider);
      final response = await remote.sendChat(content);

      final sentUserMsg = ChatMessage(
        id: userMsg.id,
        content: content,
        isUser: true,
        timestamp: userMsg.timestamp,
        status: MessageStatus.sent,
      );
      final botMsg = ChatMessage(
        id: const Uuid().v4(),
        content: response.aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      // Replace optimistic messages with confirmed ones
      final updated = state.messages
          .where((m) => m.id != userMsg.id && m.id != 'typing')
          .toList()
        ..addAll([sentUserMsg, botMsg]);

      state = state.copyWith(messages: updated, isLoading: false);

      // Surface advisory if AI flagged a referral
      if (response.referralFlagged && response.advisoryMessage != null) {
        final advisoryMsg = ChatMessage(
          id: const Uuid().v4(),
          content: '⚕️ ${response.advisoryMessage}',
          isUser: false,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
        );
        state = state.copyWith(
            messages: [...state.messages, advisoryMsg]);
      }
    } catch (e) {
      // Mark user message as error, remove typing indicator
      final errorUserMsg = ChatMessage(
        id: userMsg.id,
        content: content,
        isUser: true,
        timestamp: userMsg.timestamp,
        status: MessageStatus.error,
      );
      final withoutTyping = state.messages
          .where((m) => m.id != userMsg.id && m.id != 'typing')
          .toList()
        ..add(errorUserMsg);

      state = state.copyWith(
        messages: withoutTyping,
        isLoading: false,
        errorMessage: 'Imeshindwa kupata jibu. Tafadhali angalia mtandao wako.',
      );
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);

  void reset() {
    state = const ChatState();
    _loadWelcomeMessage();
  }
}

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) => ChatNotifier(ref));
