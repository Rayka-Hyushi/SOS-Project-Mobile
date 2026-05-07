import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/core/model/services.dart';
import 'package:sos_project_mobile/core/services/services_service.dart';
import 'package:sos_project_mobile/core/user_session.dart';

class EditServiceScreen extends StatefulWidget {
  final bool isEditing;
  final Services? service;

  const EditServiceScreen({super.key, this.isEditing = true, this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  late TextEditingController _servicoController;
  late TextEditingController _descController;
  late TextEditingController _valorController;

  @override
  void initState() {
    super.initState();
    _servicoController = TextEditingController(
      text: widget.isEditing ? widget.service?.servico : '',
    );
    _descController = TextEditingController(
      text: widget.isEditing ? widget.service?.desc : '',
    );
    _valorController = TextEditingController(
      text: widget.isEditing ? widget.service?.valor.toString() : '',
    );
  }

  @override
  void dispose() {
    _servicoController.dispose();
    _descController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          super.widget.isEditing ? 'Editar Serviço' : 'Novo Serviço',
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
                    ? 'Informações do Serviço'
                    : 'Cadastro de Serviço',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Campo Nome do Serviço
              CustomTextField(
                label: 'Serviço',
                hint: 'Ex: Troca de Tela',
                controller: _servicoController,
              ),
              const SizedBox(height: 15),

              // Campo Descrição
              CustomTextField(
                label: 'Descrição',
                hint: 'Ex: Remoção de tela antiga e aplicação de uma nova.',
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Campo Valor
              CustomTextField(
                label: 'Valor',
                hint: 'Ex: 80,00',
                controller: _valorController,
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
                        final service = ServicesService();
                        final userSession = context.read<UserSession>();
                        final userId = userSession.user?.id;

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro: Usuário não identificado.'),
                            ),
                          );
                          return;
                        }

                        // Tratamento simples para o valor numérico
                        double valorParsed =
                            double.tryParse(
                              _valorController.text.replaceAll(',', '.'),
                            ) ??
                            0.0;

                        final serviceObj = Services(
                          id: widget.isEditing ? widget.service?.id : null,
                          servico: _servicoController.text,
                          desc: _descController.text,
                          valor: valorParsed,
                          u_id: userId,
                        );

                        if (widget.isEditing) {
                          await service.updateService(serviceObj, userId);
                        } else {
                          await service.register(serviceObj);
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
