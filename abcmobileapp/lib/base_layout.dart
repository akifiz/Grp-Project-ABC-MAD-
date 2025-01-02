import 'package:flutter/material.dart';
import 'app_colors.dart';

class BaseLayout extends StatelessWidget {
  final Widget child; // Unique content of each page
  final int currentIndex; // Active tab index
  final Function(int) onTabTapped; // Tab switch callback

  const BaseLayout({
    required this.child,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'APP NAME',
          style: TextStyle(color: AppColors.text),
        ),
        centerTitle: true,
        backgroundColor: AppColors.sub, // AppBar color
      ),
      body: Container(
        color: AppColors.background, // Page background color
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.subAlt, // Bottom nav background
        currentIndex: currentIndex,
        selectedItemColor: AppColors.main, // Active tab color
        unselectedItemColor: AppColors.text, // Inactive tab color
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
