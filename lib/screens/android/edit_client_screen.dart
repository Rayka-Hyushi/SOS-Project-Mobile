import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/core/model/client.dart';
import 'package:sos_project_mobile/core/services/client_service.dart';
import 'package:sos_project_mobile/core/user_session.dart';

class EditClientScreen extends StatefulWidget {
  final bool isEditing;
  final Client? client;

  const EditClientScreen({super.key, this.isEditing = true, this.client});

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.isEditing ? widget.client?.name : '',
    );
    _emailController = TextEditingController(
      text: widget.isEditing ? widget.client?.email : '',
    );
    _phoneController = TextEditingController(
      text: widget.isEditing ? widget.client?.phone : '',
    );
    _addressController = TextEditingController(
      text: widget.isEditing ? widget.client?.address : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          super.widget.isEditing ? 'Editar Cliente' : 'Novo Cliente',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                super.widget.isEditing
                    ? 'Informações do Cliente'
                    : 'Cadastro de Cliente',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Campo Nome
              CustomTextField(
                label: 'Nome',
                hint: 'Ex: Brown Fox',
                controller: _nameController,
              ),
              const SizedBox(height: 15),

              // Campo E-mail
              CustomTextField(
                label: 'E-mail',
                hint: 'Ex: brownfox@gmail.com',
                controller: _emailController,
              ),
              const SizedBox(height: 15),

              // Campo Telefone
              CustomTextField(
                label: 'Telefone',
                hint: 'Ex: (00) 01234-5678',
                controller: _phoneController,
              ),
              const SizedBox(height: 15),

              // Campo Endereço
              CustomTextField(
                label: 'Endereço',
                hint: 'Ex: Rua Um, 00, Santa Maria - RS',
                controller: _addressController,
                maxLines: 3,
              ),

              const SizedBox(height: 40),

              // Botões de Ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final service = ClientService();
                        final userSession = context.read<UserSession>();
                        final userId = userSession.user?.id;

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro: Usuário não identificado.')),
                          );
                          return;
                        }

                        final client = Client(
                          id: widget.isEditing ? widget.client?.id : null,
                          uuid: widget.client?.uuid,
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          u_id: userId,
                        );

                        if (widget.isEditing) {
                          await service.updateClient(client, userId);
                        } else {
                          await service.register(client);
                        }

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        super.widget.isEditing ? 'Salvar' : 'Cadastrar',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
