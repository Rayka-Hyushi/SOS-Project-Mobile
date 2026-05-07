class Services {
  final int? id;
  final String servico;
  final String desc;
  final double valor;
  final int u_id;

  Services({
    this.id,
    required this.servico,
    required this.desc,
    required this.valor,
    required this.u_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'servico': servico,
      'desc': desc,
      'valor': valor,
      'u_id': u_id,
    };
  }

  factory Services.fromMap(Map<String, dynamic> map) {
    return Services(
      id: map['id'],
      servico: map['servico'],
      desc: map['desc'],
      valor: map['valor'],
      u_id: map['u_id'],
    );
  }
}
