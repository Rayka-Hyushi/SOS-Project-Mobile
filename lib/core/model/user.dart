class User {
  final int? id;
  final String? uuid;
  final String name;
  final String email;
  final String? password;
  final String? photo;
  final String? photoType;

  User({
    this.id,
    this.uuid,
    required this.name,
    required this.email,
    this.password,
    this.photo,
    this.photoType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'uuid': uuid,
      'name': name,
      'email': email,
      'password': password,
      'photo': photo,
      'photoType': photoType,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['uid'] ?? map['id'],
      uuid: map['uuid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? map['pass'],
      photo: map['photo'],
      photoType: map['photoType'],
    );
  }
}
