import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<String> sendMessage(String message, String userId, String cohort);
  Future<List<ChatMessage>> getChatHistory(String userId);
  Future<void> saveMessage(ChatMessage message);
  Future<void> clearHistory(String userId);
}
