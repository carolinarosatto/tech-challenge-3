import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/views/pages/dashboard_page.dart';
import 'package:tech_challenge_3/views/pages/transactions_page.dart';
import 'package:tech_challenge_3/views/widgets/filters_indicator.dart';
import 'package:tech_challenge_3/views/widgets/transactions_filters_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [DashboardPage(), TransactionsPage()];
  final List<String> _titles = const ["Dashboard", "Transações"];

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
        actions: [
          if (_currentIndex == 1)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_transaction');
              },
              icon: const Icon(Icons.add, color: AppColors.text100),
              tooltip: 'Nova transação',
            ),
        ],
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
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: _currentIndex == 1
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (_currentIndex == 0) {
      return FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/create_transaction');
        },
        child: const Icon(Icons.add),
      );
    }

    if (_currentIndex == 1) {
      return Consumer<TransactionsProvider>(
        builder: (context, provider, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () => TransactionsFiltersSheet.show(context),
                child: const Icon(Icons.filter_list),
              ),
              FiltersIndicator(visible: provider.hasActiveFilters),
            ],
          );
        },
      );
    }

    return null;
  }
}
