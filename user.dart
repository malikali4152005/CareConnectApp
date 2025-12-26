class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // for demo only: store hashed in real apps
  final int age; // NEW FIELD

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age, // NEW
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        name: m['name'],
        email: m['email'],
        password: m['password'],
        age: m['age'], // NEW
      );
}
