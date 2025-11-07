import 'package:flutter/material.dart';
import 'package:tech_challenge_3/views/pages/create_account_page.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/views/pages/dashboard_page.dart';
import 'package:tech_challenge_3/views/pages/home_page.dart';
import 'package:tech_challenge_3/views/pages/login_page.dart';
import 'package:tech_challenge_3/views/pages/transactions_page.dart';

class Routes {
  static const String login = '/login';
  static const String createAccount = '/create_account';
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String dashboard = '/dashboard';
  static const String createTransaction = '/create_transaction';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      createAccount: (context) => const CreateAccountPage(),
      home: (context) => const HomePage(),
      transactions: (context) => const TransactionsPage(),
      dashboard: (context) => const DashboardPage(),
      createTransaction: (context) => const CreateTransactionPage(),
    };
  }
}
