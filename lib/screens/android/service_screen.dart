import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/core/dao/service_dao.dart';
import 'package:sos_project_mobile/core/model/services.dart';
import 'package:sos_project_mobile/core/user_session.dart';
import 'package:sos_project_mobile/screens/android/edit_service_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceDao _serviceDAO = ServiceDao();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserSession>(context).user;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: FutureBuilder<List<Services>>(
                    future: _serviceDAO.findAllServices(user?.id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Erro ao carregar: ${snapshot.error}"),
                        );
                      }

                      final listaServicos = snapshot.data ?? [];
                      if (listaServicos.isEmpty) {
                        return const Center(
                          child: Text("Nenhum serviço encontrado."),
                        );
                      }

                      return ListView.builder(
                          itemCount: listaServicos.length,
                          itemBuilder: (context, index) {
                            final service = listaServicos[index];
                            return ServiceCard(service: service);
                          },
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditServiceScreen(isEditing: false),
            ),
          );

          setState(() {});
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: Colors.black12)),
        child: const Icon(Icons.add, color: Colors.black, size: 35),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Services service;
  const ServiceCard({super.key, required this.service});

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
          Text('Serviço: ${service.servico}', style: const TextStyle(fontSize: 16)),
          Text(
            'Descrição: ${service.desc}',
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor: R\$ ${service.valor}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Flexible(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditServiceScreen(isEditing: true, service: service),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    minimumSize: const Size(120, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Editar',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
