import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Center(child: Text('Página Inicial')),
    Center(child: Text('Página Clientes')),
    Center(child: Text('Página Serviços')),
    Center(child: Text('Página Ordens')),
    Center(child: Text('Página Perfil'))
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
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Clientes'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Serviços'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Ordens'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Profile'
          ),
        ],
      ),
      body: Container(
          color: Colors.green,
      ),
    );
  }
}

