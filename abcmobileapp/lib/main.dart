import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'events_page.dart';
import 'base_layout.dart';
import 'app_colors.dart';
import 'event_page.dart';
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
            _currentIndex = index;
          });
        },
        // Bottom Navigation Bar with each respective button
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
      
    
  
  // Navigation by using buttons on bottom navigation bar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update index depending on which page
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300), // Smooth transition duration
        curve: Curves.easeInOut, // Smooth transition curve
      );
    });
  }
}
