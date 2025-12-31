import '../models/doctor.dart';
import 'db_helper.dart';

class DoctorService {
  static Future<List<Doctor>> getAllDoctors() async {
    final db = await DBHelper.instance.db;
    final res = await db.query('doctors');
    return res.map((e) => Doctor.fromMap(e)).toList();
  }

  static Future<Doctor?> getDoctorById(int id) async {
    final db = await DBHelper.instance.db;
    final res = await db.query('doctors', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) return Doctor.fromMap(res.first);
    return null;
  }
}
