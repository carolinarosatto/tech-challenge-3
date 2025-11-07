import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/views/pages/dashboard_page.dart';
import 'package:tech_challenge_3/views/pages/transactions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [DashboardPage(), TransactionsPage()];
  final List<String> _titles = ["Dashboard", "Transações"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border200,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(color: AppColors.text100),
        ),
        centerTitle: true,
        backgroundColor: AppColors.brand500,
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Transações',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/create_transaction');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
