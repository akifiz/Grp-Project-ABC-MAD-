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
      theme: ThemeData(
        fontFamily: 'Nunito', // Apply Nunito font globally
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.text), // Header font
          bodyLarge: TextStyle(fontSize: 18, color: AppColors.text), // Large size font
          bodyMedium: TextStyle(fontSize: 16, color: AppColors.text), // Medium size font
      ),
      ),
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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Center(
          child: Text(
            "Settings Page",
            style: Theme.of(context).textTheme.bodyLarge, 
          ),
        );
      case 1:
        return DashboardPage(); // Navigate to Dashboard Page
      case 2:
        return Center(
          child: Text(
            "Event Page",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      default:
        return Center(
          child: Text(
            "Page Not Found",
            style: Theme.of(context).textTheme.bodyLarge, 
          ),
        );
    }
  }
}
