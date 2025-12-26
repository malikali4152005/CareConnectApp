class Prescription {
final int? id;
final int appointmentId;
final String doctorName;
final String medicines; // comma-separated for demo
final String instructions;


Prescription({this.id, required this.appointmentId, required this.doctorName, required this.medicines, required this.instructions});


Map<String, dynamic> toMap() => {
'id': id,
'appointmentId': appointmentId,
'doctorName': doctorName,
'medicines': medicines,
'instructions': instructions,
};


factory Prescription.fromMap(Map<String, dynamic> m) => Prescription(
id: m['id'] as int?,
appointmentId: m['appointmentId'],
doctorName: m['doctorName'],
medicines: m['medicines'],
instructions: m['instructions'],
);
}