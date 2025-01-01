import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abcmobileapp/app_colors.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF2D394D), // Background color
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4A768D), // Main color for AppBar
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFAF8), // Text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFFFFAF8), // Icons in AppBar
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF263041), // Sub Alt color
          selectedItemColor: Color(0xFFFF7A90), // Selected Color
          unselectedItemColor: Color(0xFFFFFAF8), // Unselected Color
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1; // Default to the "Dashboard" tab

  // Pages for navigation
  final List<Widget> _pages = [
    Center(
        child: Text(
      "Settings Page",
      style: TextStyle(color: Color(0xFFFFFAF8), fontSize: 24),
    )),
    Center(
        child: Text(
      "Dashboard Page",
      style: TextStyle(color: Color(0xFFFFFAF8), fontSize: 24),
    )),
    Center(
        child: Text(
      "Event Page",
      style: TextStyle(color: Color(0xFFFFFAF8), fontSize: 24),
    )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APP NAME'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update selected index
          });
        },
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
