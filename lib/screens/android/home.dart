import 'package:flutter/material.dart';
import 'package:sos_project_mobile/screens/android/client_screen.dart';
import 'package:sos_project_mobile/screens/android/dashboard_screen.dart';
import 'package:sos_project_mobile/screens/android/orders_screen.dart';
import 'package:sos_project_mobile/screens/android/profile_screen.dart';
import 'package:sos_project_mobile/screens/android/service_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    DashboardScreen(),
    ClientScreen(),
    ServiceScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Clientes'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Serviços'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ordens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
