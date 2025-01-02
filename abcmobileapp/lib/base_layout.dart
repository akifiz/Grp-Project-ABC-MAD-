import 'package:flutter/material.dart';
import 'app_colors.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabTapped;

  const BaseLayout({
    required this.child,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Apply SafeArea globally
        child: Container(
          color: AppColors.background,
          child: child,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.subAlt,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.text,
        unselectedItemColor: AppColors.main,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
