import 'client.dart';
import 'user.dart';
import 'services.dart';

class Order {
  final int? osid;
  final String? uuid;
  final Client? cliente;
  final String device;
  final String opendate;
  final String? closedate;
  final String status;
  final String description;
  final double extras;
  final double discount;
  final double total;
  final List<Services> servicos;
  final User? usuario;

  // Auxiliary field for DB relationship
  String? get clienteUuid => cliente?.uuid;
  int? get uId => usuario?.id;

  Order({
    this.osid,
    this.uuid,
    this.cliente,
    required this.device,
    required this.opendate,
    this.closedate,
    required this.status,
    required this.description,
    this.extras = 0.0,
    this.discount = 0.0,
    required this.total,
    this.servicos = const [],
    this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'osid': osid,
      'uuid': uuid,
      'device': device,
      'description': description,
      'status': status,
      'opendate': opendate,
      'closedate': closedate,
      'extras': extras,
      'discount': discount,
      'total': total,
      'cliente_uuid': clienteUuid,
      'u_id': uId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      osid: map['osid'],
      uuid: map['uuid'],
      cliente: map['cliente'] != null 
          ? Client.fromMap(map['cliente']) 
          : (map['cliente_uuid'] != null ? Client(name: '', email: '', phone: '', address: '', uuid: map['cliente_uuid']) : null),
      device: map['device'] ?? '',
      opendate: map['opendate'] ?? '',
      closedate: map['closedate'],
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      extras: (map['extras'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      servicos: map['servicos'] != null
          ? (map['servicos'] as List).map((x) => Services.fromMap(x)).toList()
          : [],
      usuario: map['usuario'] != null ? User.fromMap(map['usuario']) : null,
    );
  }
}
