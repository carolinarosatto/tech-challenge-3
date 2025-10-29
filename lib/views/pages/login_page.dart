import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bytebank',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.brand500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: AppColors.brand600),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crie sua conta com a gente!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'Experimente mais liberdade no controle da sua vida financeira.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Image.asset(
                'assets/images/lp_img.png',
                width: 250,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 28.0),
              FilledButton(onPressed: () {}, child: Text('Entrar')),
              SizedBox(height: 14.0),
              TextButton(onPressed: () {}, child: Text("Criar conta")),
            ],
          ),
        ),
      ),
    );
  }
}
