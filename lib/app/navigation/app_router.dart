import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/routes.dart';
import 'package:tech_challenge_3/features/auth/presentation/pages/create_account_page.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/dashboard_page.dart';
import 'package:tech_challenge_3/app/presentation/pages/home_page.dart';
import 'package:tech_challenge_3/features/auth/presentation/pages/login_page.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/transactions_page.dart';

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
