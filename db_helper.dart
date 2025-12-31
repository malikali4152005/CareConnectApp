import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  /// Public getter for the database
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "careconnect.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Create all tables
  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        age INTEGER
      )
    ''');

    // Doctors Table
    await db.execute('''
      CREATE TABLE doctors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        specialization TEXT,
        experience INTEGER,
        availability TEXT
      )
    ''');

    // Appointments Table
    await db.execute('''
      CREATE TABLE appointments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        doctorId INTEGER,
        date TEXT,
        time TEXT,
        status TEXT
      )
    ''');

    // Prescriptions Table
    await db.execute('''
      CREATE TABLE prescriptions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        appointmentId INTEGER,
        doctorName TEXT,
        medicines TEXT,
        instructions TEXT
      )
    ''');

    // Messages Table
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fromUserId INTEGER,
        text TEXT,
        timestamp TEXT
      )
    ''');

    // Seed default doctors
    await _seedDoctors(db);
  }

  /// Seed default doctors
  Future<void> _seedDoctors(Database db) async {
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM doctors'),
        ) ??
        0;

    if (count == 0) {
      final doctors = [
        {
          'name': 'Dr. Ayesha Khan',
          'specialization': 'General Physician',
          'experience': 8,
          'availability': 'Mon–Fri 9:00–17:00',
        },
        {
          'name': 'Dr. Omar Ali',
          'specialization': 'Pediatrician',
          'experience': 6,
          'availability': 'Tue–Thu 10:00–16:00',
        },
        {
          'name': 'Dr. Sara Malik',
          'specialization': 'Cardiologist',
          'experience': 12,
          'availability': 'Mon/Wed/Fri 10:00–15:00',
        },
      ];

      for (var doctor in doctors) {
        await db.insert('doctors', doctor);
      }
    }
  }
}
