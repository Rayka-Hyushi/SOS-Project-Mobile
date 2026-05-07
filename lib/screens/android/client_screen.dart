import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/core/model/client.dart';
import 'package:sos_project_mobile/core/user_session.dart';
import 'package:sos_project_mobile/screens/android/edit_client_screen.dart';

import '../../core/dao/client_dao.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final ClientDAO _clientDAO = ClientDAO();

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
                child: FutureBuilder<List<Client>>(
                  future: _clientDAO.findAllClients(user?.id ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Erro ao carregar: ${snapshot.error}"),
                      );
                    }

                    final listaClientes = snapshot.data ?? [];
                    if (listaClientes.isEmpty) {
                      return const Center(
                        child: Text("Nenhum cliente encontrado"),
                      );
                    }

                    return ListView.builder(
                      itemCount: listaClientes.length,
                      itemBuilder: (context, index) {
                        final client = listaClientes[index];
                        return ClientCard(client: client);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditClientScreen(isEditing: false),
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

class ClientCard extends StatelessWidget {
  final Client client;
  const ClientCard({super.key, required this.client});

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
          Text('Nome: ${client.name}', style: const TextStyle(fontSize: 16)),
          Text('Email: ${client.email}'),
          Text('Telefone: ${client.phone}'),
          Text('Endereço: ${client.address}'),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditClientScreen(isEditing: true, client: client),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Editar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
