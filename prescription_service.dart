import '../models/prescription.dart';
import 'db_helper.dart';

class PrescriptionService {
  static Future<int> addPrescription(Prescription p) async {
    final db = await DBHelper.instance.db;
    return await db.insert('prescriptions', p.toMap());
  }

  static Future<List<Prescription>> getByAppointment(int appointmentId) async {
    final db = await DBHelper.instance.db;
    final res = await db.query(
      'prescriptions',
      where: 'appointmentId = ?',
      whereArgs: [appointmentId],
    );
    return res.map((e) => Prescription.fromMap(e)).toList();
  }
}
