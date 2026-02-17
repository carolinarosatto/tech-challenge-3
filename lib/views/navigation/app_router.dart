import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/routes.dart';
import 'package:tech_challenge_3/views/pages/create_account_page.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/views/pages/dashboard_page.dart';
import 'package:tech_challenge_3/views/pages/home_page.dart';
import 'package:tech_challenge_3/views/pages/login_page.dart';
import 'package:tech_challenge_3/views/pages/transactions_page.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.login: (context) => const LoginPage(),
      Routes.createAccount: (context) => const CreateAccountPage(),
      Routes.home: (context) => const HomePage(),
      Routes.transactions: (context) => const TransactionsPage(),
      Routes.dashboard: (context) => const DashboardPage(),
      Routes.createTransaction: (context) => const CreateTransactionPage(),
    };
  }
}
