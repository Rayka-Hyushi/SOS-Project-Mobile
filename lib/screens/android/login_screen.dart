import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_project_mobile/core/services/auth_service.dart';
import 'package:sos_project_mobile/core/user_session.dart';
import 'package:sos_project_mobile/screens/android/home.dart';
import 'package:sos_project_mobile/screens/android/register_screen.dart';

import '../../core/model/user.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Login page"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
                child: Center(
                  child: SizedBox(
                    height: 150,
                    width: 200,
                    child: FlutterLogo(),
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
                    label: Text('Email'),
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
              TextButton(
                onPressed: () => {},
                child: Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User? user = await AuthService().login(
                        emailController.text,
                        passwordController.text,
                      );

                      if (user != null) {
                        if (context.mounted) {
                          Provider.of<UserSession>(
                            context,
                            listen: false,
                          ).setUser(user);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("E-mail ou senha inválida."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(height: 90),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  'Crie sua conta',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
