import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/auth_provider.dart';
import 'package:tech_challenge_3/core/utils/validators.dart';
import 'package:tech_challenge_3/core/widgets/password_input.dart';

import '../../core/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    bool success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Erro ao entrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/undraw_auth.png',
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Entrar',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),

                    const SizedBox(height: 20.0),
                    PasswordInput(
                      controller: _passwordController,
                      validator: Validators.password,
                    ),

                    const SizedBox(height: 14.0),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return FilledButton(
                          onPressed: authProvider.isLoading ? null : _login,
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Entrar'),
                        );
                      },
                    ),

                    const SizedBox(height: 24.0),

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
                                Navigator.pushNamed(
                                  context,
                                  Routes.createAccount,
                                );
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
        ),
      ),
    ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
