import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/model/order.dart';
import '../../core/model/client.dart';
import '../../core/services/order_service.dart';
import '../../core/services/client_service.dart';
import '../../core/user_session.dart';

class EditOrderScreen extends StatefulWidget {
  final bool isEditing;
  final Order? order;

  const EditOrderScreen({super.key, this.isEditing = true, this.order});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _equipmentController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _snController;
  late TextEditingController _problemController;
  late TextEditingController _valueController;
  
  String _selectedStatus = 'Pendente';
  Client? _selectedClient;
  List<Client> _clients = [];
  bool _isLoadingClients = true;

  final List<String> _statusOptions = [
    'Pendente',
    'Em Análise',
    'Aguardando Peça',
    'Pronto',
    'Finalizado',
    'Cancelado'
  ];

  @override
  void initState() {
    super.initState();
    _equipmentController = TextEditingController(text: widget.isEditing ? widget.order?.equipment : '');
    _brandController = TextEditingController(text: widget.isEditing ? widget.order?.brand : '');
    _modelController = TextEditingController(text: widget.isEditing ? widget.order?.model : '');
    _snController = TextEditingController(text: widget.isEditing ? widget.order?.sn : '');
    _problemController = TextEditingController(text: widget.isEditing ? widget.order?.problem : '');
    _valueController = TextEditingController(text: widget.isEditing ? widget.order?.value.toString() : '0.0');
    
    if (widget.isEditing && widget.order != null) {
      _selectedStatus = widget.order!.status;
    }

    _loadClients();
  }

  Future<void> _loadClients() async {
    final userId = context.read<UserSession>().user?.id;
    if (userId != null) {
      final clients = await ClientService().findAllClients(userId);
      setState(() {
        _clients = clients;
        _isLoadingClients = false;
        
        if (widget.isEditing && widget.order != null) {
          try {
            _selectedClient = _clients.firstWhere((c) => c.id == widget.order!.clientId);
          } catch (e) {
            _selectedClient = null;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _equipmentController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _snController.dispose();
    _problemController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _saveOrder() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um cliente.')),
      );
      return;
    }

    final userId = context.read<UserSession>().user?.id;
    if (userId == null) return;

    final double value = double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.0;
    
    final order = Order(
      id: widget.isEditing ? widget.order?.id : null,
      equipment: _equipmentController.text,
      brand: _brandController.text,
      model: _modelController.text,
      sn: _snController.text,
      problem: _problemController.text,
      status: _selectedStatus,
      openDate: widget.isEditing ? widget.order!.openDate : DateFormat('dd/MM/yyyy').format(DateTime.now()),
      closeDate: _selectedStatus == 'Finalizado' ? DateFormat('dd/MM/yyyy').format(DateTime.now()) : null,
      value: value,
      uId: userId,
      clientId: _selectedClient!.id!,
    );

    final service = OrderService();
    bool success;
    if (widget.isEditing) {
      final rows = await service.updateOrder(order, userId);
      success = rows > 0;
    } else {
      success = await service.register(order);
    }

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar a ordem.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Ordem' : 'Nova Ordem',
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
        child: _isLoadingClients 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dados do Cliente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Client>(
                  value: _selectedClient,
                  decoration: InputDecoration(
                    labelText: 'Selecionar Cliente',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  ),
                  items: _clients.map((client) {
                    return DropdownMenuItem(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedClient = value),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dados do Equipamento',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                CustomTextField(label: 'Equipamento', hint: 'Ex: Celular, Notebook', controller: _equipmentController),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: CustomTextField(label: 'Marca', hint: 'Ex: Samsung', controller: _brandController)),
                    const SizedBox(width: 10),
                    Expanded(child: CustomTextField(label: 'Modelo', hint: 'Ex: Galaxy A14', controller: _modelController)),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(label: 'Serial Number (SN)', hint: 'Ex: 123456789', controller: _snController),
                const SizedBox(height: 15),
                CustomTextField(label: 'Problema Relatado', hint: 'Descreva o problema...', controller: _problemController, maxLines: 3),
                const SizedBox(height: 20),
                const Text(
                  'Status e Valor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  ),
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedStatus = value!),
                ),
                const SizedBox(height: 15),
                CustomTextField(label: 'Valor do Serviço', hint: '0.00', controller: _valueController, keyboardType: TextInputType.number),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          widget.isEditing ? 'Salvar' : 'Cadastrar',
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
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
