import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/services/auth_service.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';

import '../../core/routes.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/password_input.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await _authService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppColors.stateSuccess,
          showCloseIcon: true,
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppColors.stateError,
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/undraw_signup.png',
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.0),
              Text(
                'Cadastrar',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                validator: Validators.name,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 20.0),
              PasswordInput(
                controller: _passwordController,
                validator: Validators.password,
              ),
              SizedBox(height: 36.0),
              FilledButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
