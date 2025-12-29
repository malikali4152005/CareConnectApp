import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';
import '../models/user.dart';

class AuthService {
  static Future<int> registerUser(UserModel user) async {
    final db = await DBHelper.instance.db;
    return await db.insert('users', user.toMap());
  }

  static Future<UserModel?> login(String email, String password) async {
    final db = await DBHelper.instance.db;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) {
      final user = UserModel.fromMap(res.first);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', user.id!);
      await prefs.setString('userName', user.name);
      await prefs.setInt('userAge', user.age); // ✅ ADDED LINE

      return user;
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
