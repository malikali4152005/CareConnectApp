import '../models/message.dart';
import 'db_helper.dart';

class ChatService {
  static Future<int> sendMessage(MessageModel m) async {
    final db = await DBHelper.instance.db;
    return await db.insert('messages', m.toMap());
  }

  static Future<List<MessageModel>> getAllMessages() async {
    final db = await DBHelper.instance.db;
    final res = await db.query('messages', orderBy: 'id ASC');
    return res.map((e) => MessageModel.fromMap(e)).toList();
  }

  static Future<void> clearMessages() async {
    final db = await DBHelper.instance.db;
    await db.delete('messages');
  }
}
