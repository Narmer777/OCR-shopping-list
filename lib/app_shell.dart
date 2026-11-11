import 'package:flutter/material.dart';

import 'features/shopping_lists/data/demo_shopping_lists.dart';
import 'features/shopping_lists/presentation/shopping_lists_page.dart';
import 'widgets/app_bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            ShoppingListsPage(
              key: ValueKey('lists-page'),
              initialListTitles: demoShoppingListTitles,
            ),
            SizedBox.expand(key: ValueKey('scan-page')),
            SizedBox.expand(key: ValueKey('statistics-page')),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
