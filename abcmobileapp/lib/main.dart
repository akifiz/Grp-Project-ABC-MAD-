import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'base_layout.dart';
import 'app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 1; // Default to "Dashboard"

  @override
  Widget build(BuildContext context) {
    // Return the appropriate page based on the selected index
    return BaseLayout(
      currentIndex: _currentIndex,
      onTabTapped: (index) {
        setState(() {
          _currentIndex = index; // Update the selected index
        });
      },
      child: _getPage(_currentIndex), // Pass the unique content for the current tab
    );
  }

  // Helper function to get the content for each page
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Center(
          child: Text(
            "Settings Page",
            style: TextStyle(color: AppColors.text, fontSize: 24),
          ),
        );
      case 1:
        return DashboardPage(); // Use the DashboardPage
      case 2:
        return Center(
          child: Text(
            "Event Page",
            style: TextStyle(color: AppColors.text, fontSize: 24),
          ),
        );
      default:
        return Center(
          child: Text(
            "Page Not Found",
            style: TextStyle(color: AppColors.text, fontSize: 24),
          ),
        );
    }
  }
}
