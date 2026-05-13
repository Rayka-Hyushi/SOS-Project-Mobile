import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/model/order.dart';
import '../../core/model/client.dart';
import '../../core/model/services.dart';
import '../../core/services/order_service.dart';
import '../../core/services/client_service.dart';
import '../../core/services/services_service.dart';
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
  
  late TextEditingController _deviceController;
  late TextEditingController _descriptionController;
  late TextEditingController _extrasController;
  late TextEditingController _discountController;
  late TextEditingController _totalController;
  
  String _selectedStatus = 'ABERTA';
  Client? _selectedClient;
  List<Client> _clients = [];
  List<Services> _availableServices = [];
  List<Services> _selectedServices = [];
  bool _isLoadingData = true;

  final List<String> _statusOptions = [
    'ABERTA',
    'EM_ANDAMENTO',
    'CONCLUIDA',
    'FINALIZADA'
  ];

  @override
  void initState() {
    super.initState();
    _deviceController = TextEditingController(text: widget.isEditing ? widget.order?.device : '');
    _descriptionController = TextEditingController(text: widget.isEditing ? widget.order?.description : '');
    _extrasController = TextEditingController(text: widget.isEditing ? widget.order?.extras.toString() : '0.0');
    _discountController = TextEditingController(text: widget.isEditing ? widget.order?.discount.toString() : '0.0');
    _totalController = TextEditingController(text: widget.isEditing ? widget.order?.total.toString() : '0.0');
    
    if (widget.isEditing && widget.order != null) {
      _selectedStatus = widget.order!.status;
      _selectedServices = List.from(widget.order!.servicos);
    }

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = context.read<UserSession>().user?.id;
    if (userId != null) {
      final clients = await ClientService().findAllClients(userId);
      final services = await ServicesService().findAllServices(userId);
      setState(() {
        _clients = clients;
        _availableServices = services;
        _isLoadingData = false;
        
        if (widget.isEditing && widget.order != null) {
          try {
            _selectedClient = _clients.firstWhere((c) => c.uuid == widget.order!.cliente?.uuid);
          } catch (e) {
            _selectedClient = null;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _deviceController.dispose();
    _descriptionController.dispose();
    _extrasController.dispose();
    _discountController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double servicesTotal = _selectedServices.fold(0, (sum, item) => sum + item.value);
    double extras = double.tryParse(_extrasController.text.replaceAll(',', '.')) ?? 0.0;
    double discount = double.tryParse(_discountController.text.replaceAll(',', '.')) ?? 0.0;
    
    setState(() {
      _totalController.text = (servicesTotal + extras - discount).toStringAsFixed(2);
    });
  }

  Future<void> _saveOrder() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um cliente.')),
      );
      return;
    }

    final user = context.read<UserSession>().user;
    if (user == null || user.id == null) return;

    final double extras = double.tryParse(_extrasController.text.replaceAll(',', '.')) ?? 0.0;
    final double discount = double.tryParse(_discountController.text.replaceAll(',', '.')) ?? 0.0;
    final double total = double.tryParse(_totalController.text.replaceAll(',', '.')) ?? 0.0;
    
    final order = Order(
      osid: widget.isEditing ? widget.order?.osid : null,
      uuid: widget.order?.uuid,
      device: _deviceController.text,
      description: _descriptionController.text,
      status: _selectedStatus,
      opendate: widget.isEditing ? widget.order!.opendate : DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      closedate: _selectedStatus == 'FINALIZADA' ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()) : null,
      extras: extras,
      discount: discount,
      total: total,
      cliente: _selectedClient,
      usuario: user,
      servicos: _selectedServices,
    );

    final service = OrderService();
    bool success;
    if (widget.isEditing) {
      final rows = await service.updateOrder(order, user.id!);
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
        child: _isLoadingData 
          ? const Center(child: CircularProgressIndicator())
          : Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                  initialValue: _selectedClient,
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
                CustomTextField(label: 'Dispositivo', hint: 'Ex: Notebook Dell Inspiron', controller: _deviceController),
                const SizedBox(height: 15),
                CustomTextField(label: 'Descrição do Problema', hint: 'Descreva o problema...', controller: _descriptionController, maxLines: 3),
                const SizedBox(height: 20),
                const Text(
                  'Serviços',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _availableServices.isEmpty 
                  ? const Text('Nenhum serviço cadastrado.')
                  : Wrap(
                    spacing: 8.0,
                    children: _availableServices.map((service) {
                      final isSelected = _selectedServices.any((s) => s.id == service.id);
                      return FilterChip(
                        label: Text(service.service),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedServices.add(service);
                            } else {
                              _selectedServices.removeWhere((s) => s.id == service.id);
                            }
                            _calculateTotal();
                          });
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Status e Financeiro',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Extras', 
                        hint: '0.00', 
                        controller: _extrasController, 
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateTotal(),
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Desconto', 
                        hint: '0.00', 
                        controller: _discountController, 
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateTotal(),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(label: 'Total', hint: '0.00', controller: _totalController, keyboardType: TextInputType.number, enabled: false),
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
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
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
          enabled: enabled,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.all(12),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
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
