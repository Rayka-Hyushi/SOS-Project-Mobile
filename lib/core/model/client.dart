class Client {
  final int? id;
  final String? uuid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int? u_id;

  Client({
    this.id,
    this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.u_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'cid': id,
      'uuid': uuid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'u_id': u_id,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['cid'] ?? map['id'],
      uuid: map['uuid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      u_id: map['u_id'],
    );
  }
}
