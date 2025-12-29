import '../models/appointment.dart';
import 'db_helper.dart';

class AppointmentService {
  static Future<int> createAppointment(Appointment a) async {
    final db = await DBHelper.instance.db;
    return await db.insert('appointments', a.toMap());
  }

  static Future<List<Appointment>> getAppointmentsForUser(int userId) async {
    final db = await DBHelper.instance.db;

    final res = await db.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return res.map((e) => Appointment.fromMap(e)).toList();
  }

  static Future<void> cancelAppointment(int id) async {
    final db = await DBHelper.instance.db;

    await db.update(
      'appointments',
      {'status': 'cancelled'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
