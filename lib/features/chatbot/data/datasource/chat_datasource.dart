import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> saveMessage(ChatMessageModel message);
  Future<List<ChatMessageModel>> getMessages(String userId);
  Future<void> clearMessages(String userId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper dbHelper;

  ChatLocalDataSourceImpl(this.dbHelper);

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    final db = await dbHelper.database;
    await db.insert(
      'chat_messages',
      {
        'id': message.id,
        'user_id': message.userId,
        'content': message.content,
        'is_user': message.isUser ? 1 : 0,
        'timestamp': message.timestamp.toIso8601String(),
        'status': message.status.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chat_messages',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => ChatMessageModel.fromMap(map)).toList();
  }

  @override
  Future<void> clearMessages(String userId) async {
    final db = await dbHelper.database;
    await db.delete(
      'chat_messages',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}

extension on String {
  get name => null;
}
