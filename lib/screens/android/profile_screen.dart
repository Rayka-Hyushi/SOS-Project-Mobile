import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/screens/android/login_screen.dart';

import '../../core/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(Icons.person_outline, size: 80),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: const Icon(Icons.edit, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Técnico',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text(
                'tecnico@mail.com',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.black, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black, thickness: 1)),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Resumo Mensal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                children: const [
                  Expanded(
                    child: SummaryCard(
                      title: 'Ordens\nFinalizadas',
                      value: '100',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SummaryCard(
                      title: 'Lucro\nBruto',
                      value: r'R$ 4.000',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SummaryCard(
                      title: 'Gastos\nMensais',
                      value: r'R$ 1.250',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.crop_square,
                      label: 'Editar dados pessoais',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    SettingsTile(
                      icon: Icons.crop_square,
                      label: 'Alterar senha',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    SettingsTile(
                      icon: Icons.crop_square,
                      label: 'Tema escuro',
                      trailing: Switch(
                        value: false,
                        onChanged: (v) {},
                        activeThumbColor: Colors.green,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    SettingsTile(
                      icon: Icons.crop_square,
                      label: 'Notificações push',
                      trailing: Switch(
                        value: true,
                        onChanged: (v) {},
                        activeThumbColor: Colors.green,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    SettingsTile(
                      icon: Icons.crop_square,
                      label: 'Sobre o SOS Project',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              OutlinedButton(
                onPressed: () {
                  context.read<UserSession>().clearSession();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  minimumSize: const Size(180, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sair (Logout)',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.crop_square, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
