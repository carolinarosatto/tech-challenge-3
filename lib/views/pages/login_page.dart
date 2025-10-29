import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/widgets/password_input.dart';

import '../../core/routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bytebank',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/undraw_auth.png',
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Entrar',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 20.0),
                PasswordInput(),
                SizedBox(height: 14.0),
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.home);
                  },
                  child: Text('Entrar'),
                ),
                SizedBox(height: 24.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Ainda não tem conta? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Cadastre-se',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Fazer a navegação para tela de cadastro
                            Navigator.pushNamed(context, Routes.createAccount);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
