import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    required String userId,
    required String content,
    required bool isUser,
    required DateTime timestamp,
    @Default('sent') String status,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      isUser: (map['is_user'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
      status: map['status'] as String? ?? 'sent',
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity, String userId) {
    return ChatMessageModel(
      id: entity.id,
      userId: userId,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      status: entity.status.name,
    );
  }
}

extension ChatMessageModelX on ChatMessageModel {
  ChatMessage toEntity() => ChatMessage(
        id: id,
        content: content,
        isUser: isUser,
        timestamp: timestamp,
        status: MessageStatus.values.firstWhere(
          (e) => e.name == status,
          orElse: () => MessageStatus.sent,
        ),
      );
}
