class Doctor {
final int? id;
final String name;
final String specialization;
final int experience; // years
final String availability; // e.g., "Mon-Fri 9:00-17:00"


Doctor({this.id, required this.name, required this.specialization, required this.experience, required this.availability});


Map<String, dynamic> toMap() => {
'id': id,
'name': name,
'specialization': specialization,
'experience': experience,
'availability': availability,
};


factory Doctor.fromMap(Map<String, dynamic> m) => Doctor(
id: m['id'] as int?,
name: m['name'],
specialization: m['specialization'],
experience: m['experience'],
availability: m['availability'],
);
}