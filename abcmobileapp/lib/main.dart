import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'events_page.dart';
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
  int _currentIndex = 1; // Default to "Dashboard" tab
  final PageController _pageController = PageController(initialPage: 1); // Controller for full-screen swipe navigation

  @override
  void dispose() {
    _pageController.dispose(); // Clean up PageController when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Sync current index with swipe
          });
        },
        // BOTTOM NAVIGATION BAR
        children: [
          // Settings Page
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: Center(
              child: Text(
                "Settings Page",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),

          // Dashboard Page
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: DashboardPage(),
          ),

          // Event Page
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: EventsPage(),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    // Navigate to the selected page using bottom navigation bar
    setState(() {
      _currentIndex = index; // Update index
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300), // Smooth transition duration
        curve: Curves.easeInOut, // Smooth transition curve
      );
    });
  }
}
