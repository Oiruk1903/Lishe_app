import 'package:equatable/equatable.dart';

enum MessageStatus { sending, sent, error }

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  @override
  List<Object?> get props => [id, content, isUser, timestamp, status];
}
