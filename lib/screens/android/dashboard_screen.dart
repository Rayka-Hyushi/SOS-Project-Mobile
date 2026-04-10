import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Olá, Técnico!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Resumo da Sua Bancada',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      Text(
                        'Segunda-Feira, 23 de Março',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 70,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                children: const [
                  Expanded(
                    child: StatusCard(
                      title: 'Pendentes',
                      count: '10',
                      subtitle: 'Aguardando\nDiagnóstico',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatusCard(
                      title: 'Em Análise',
                      count: '10',
                      subtitle: 'Trabalho\nEm Progresso',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatusCard(
                      title: 'Prontas',
                      count: '10',
                      subtitle: 'Para\nEntregar',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                'Últimas Atualizações',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              const UpdateItemTile(),
              const UpdateItemTile(),
              const UpdateItemTile(),
              const UpdateItemTile(),
              const UpdateItemTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final String subtitle;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class UpdateItemTile extends StatelessWidget {
  const UpdateItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('ID: OS001', style: TextStyle(color: Colors.blueGrey)),
                Text(
                  'Galaxy A14 5G',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Status: Aberta'),
              ],
            ),
          ),
          Column(
            children: const [
              Icon(Icons.phone_in_talk_outlined, size: 28),
              SizedBox(height: 4),
              Text(
                'Contatar Cliente',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
