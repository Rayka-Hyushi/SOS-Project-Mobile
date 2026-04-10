import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Lista de Ordens
              Expanded(
                child: ListView(
                  children: const [
                    OrderCard(),
                    OrderCard(),
                    OrderCard(),
                    OrderCard(),
                    OrderCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: Colors.black12)),
        child: const Icon(Icons.add, color: Colors.black, size: 35),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OS001',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('SN: SN123456'),
          const SizedBox(height: 4),
          Row(
            children: const [
              Expanded(child: Text('Marca: Samsung')),
              Expanded(child: Text('Modelo: Galaxy A14 5G')),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Data de Abertura: 12/12/2025'),
          const Text('Data de Fechamento: 01/01/2026'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status: Finalizado',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  minimumSize: const Size(120, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Abrir',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
