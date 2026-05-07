class Order {
  final int? id;
  final String equipment;
  final String brand;
  final String model;
  final String sn;
  final String problem;
  final String status;
  final String openDate;
  final String? closeDate;
  final double value;
  final int uId;
  final int clientId;

  Order({
    this.id,
    required this.equipment,
    required this.brand,
    required this.model,
    required this.sn,
    required this.problem,
    required this.status,
    required this.openDate,
    this.closeDate,
    required this.value,
    required this.uId,
    required this.clientId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipment': equipment,
      'brand': brand,
      'model': model,
      'sn': sn,
      'problem': problem,
      'status': status,
      'open_date': openDate,
      'close_date': closeDate,
      'value': value,
      'u_id': uId,
      'client_id': clientId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      equipment: map['equipment'],
      brand: map['brand'],
      model: map['model'],
      sn: map['sn'],
      problem: map['problem'],
      status: map['status'],
      openDate: map['open_date'],
      closeDate: map['close_date'],
      value: map['value'],
      uId: map['u_id'],
      clientId: map['client_id'],
    );
  }
}
