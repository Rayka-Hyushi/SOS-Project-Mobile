class Client {
  final int? id;
  final String address;
  final String email;
  final String phone;
  final String name;
  final int u_id;

  Client({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.u_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'u_id': u_id,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      u_id: map['u_id'],
    );
  }
}
