import 'package:lishe_app/features/chatbot/data/datasource/chat_datasource.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../services/ai_chat_service.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final AIChatService aiService;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.aiService,
    required this.localDataSource,
  });

  @override
  Future<String> sendMessage(
      String message, String userId, String cohort) async {
    return await aiService.sendMessage(message, userId, cohort);
  }

  @override
  Future<List<ChatMessage>> getChatHistory(String userId) async {
    final models = await localDataSource.getMessages(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    // Note: userId should be passed from context
    // This is a simplified version; in production, get userId from auth
    final model = ChatMessageModel.fromEntity(message, 'user_id_placeholder');
    await localDataSource.saveMessage(model);
  }

  @override
  Future<void> clearHistory(String userId) async {
    await localDataSource.clearMessages(userId);
  }
}
