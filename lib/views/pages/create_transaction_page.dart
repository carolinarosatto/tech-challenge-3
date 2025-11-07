import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

class CreateTransactionPage extends StatelessWidget {
  const CreateTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brand500,
        title: Text(
          "Nova transação",
          style: TextStyle(color: AppColors.text100),
        ),
      ),
      body: Center(child: Text('Create Transaction Page')),
    );
  }
}
