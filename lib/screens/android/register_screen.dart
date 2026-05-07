import 'package:flutter/material.dart';
import 'package:sos_project_mobile/screens/android/login_screen.dart';

import '../../core/services/auth_service.dart';
import '../../core/model/user.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cadastrar'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
                  child: Center(
                    child: Text('Cadastre-se para utilizar o aplicativo',
                    style: TextStyle(fontSize: 20, color: Colors.blue),)
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return '* Campo obrigatório';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      label: Text('Name'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return '* Campo obrigatório';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      label: Text('E-mail'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return '* Campo obrigatório';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      label: Text('Senha'),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool valido =
                      _formKey.currentState!.validate();
                      if(valido) {
                        final User newUser = User(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                        final success = await AuthService().register(newUser);
                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadiusGeometry.circular(20),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
