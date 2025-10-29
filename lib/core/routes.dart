import 'package:flutter/material.dart';
import 'package:tech_challenge_3/views/pages/create_account_page.dart';
import 'package:tech_challenge_3/views/pages/login_page.dart';

class Routes {
  static const String login = '/login';
  static const String createAccount = '/create_account';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      createAccount: (context) => const CreateAccountPage(),
    };
  }
}
