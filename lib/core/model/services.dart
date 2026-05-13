class Services {
  final int? id;
  final String? uuid;
  final String service;
  final String description;
  final double value;
  final int? uId;

  Services({
    this.id,
    this.uuid,
    required this.service,
    required this.description,
    required this.value,
    this.uId,
  });

  Map<String, dynamic> toMap() {
    return {
      'sid': id,
      'uuid': uuid,
      'service': service,
      'description': description,
      'value': value,
      'u_id': uId,
    };
  }

  factory Services.fromMap(Map<String, dynamic> map) {
    return Services(
      id: map['sid'] ?? map['id'],
      uuid: map['uuid'],
      service: map['service'] ?? map['servico'] ?? '',
      description: map['description'] ?? map['desc'] ?? '',
      value: (map['value'] ?? map['valor'] ?? 0.0).toDouble(),
      uId: map['u_id'] ?? map['uId'],
    );
  }
}
