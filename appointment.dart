class Appointment {
  int? id;
  int userId;
  int doctorId;
  String date;
  String time;
  String status;

  Appointment({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.time,
    this.status = 'booked',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'status': status,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      doctorId: map['doctorId'] as int,
      date: map['date'] as String,
      time: map['time'] as String,
      status: map['status'] ?? 'booked',
    );
  }
}
