class ClientModel {
  final String id;
  final String name;
  final String password;
  final String email;

  ClientModel({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'password': password, 'email': email};
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // útil pra pegar o doc diretamente do Firestore
  factory ClientModel.fromFirestore(String docId, Map<String, dynamic> map) {
    return ClientModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
