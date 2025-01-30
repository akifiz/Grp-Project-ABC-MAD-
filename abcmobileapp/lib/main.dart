import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart';
import 'events_page.dart';
import 'base_layout.dart';
import 'app_colors.dart';
import 'model.dart';
import 'settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'sign_in_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isSignedUp = prefs.getBool('isSignedUp') ?? false;

  Widget homePage;
  if (isLoggedIn) {
    homePage = MainApp();
  } else {
    homePage = SignInPage();
  }
  runApp(MyApp(homePage: homePage));
}

class MyApp extends StatelessWidget {
  final Widget homePage;

  MyApp({
    required this.homePage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.text),
          bodyLarge: TextStyle(fontSize: 18, color: AppColors.text),
          bodyMedium: TextStyle(fontSize: 16, color: AppColors.text),
        ),
      ),
      home: homePage,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);
  List<Event> _events = [];
  User? _userData;
  
  void _fetchUpdatedEvents() {
    if (_userData == null) return; 
    FirebaseHandler().fetchEvents(_userData!.eventId).then((updatedEvents) {
      setState(() {
        _events = updatedEvents;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final handler = FirebaseHandler();
      User userData = await handler.fetchUserData(global_userId);
      List<Event> userEvents = await handler.fetchEvents(userData.eventId);
      global_userName = userData.defaultName;

      setState(() {
        _userData = userData;
        _events = userEvents;
      });
    } catch(e) {
      print('Error loading user data $e');
    }
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
        children: [
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: SettingsPage(),
          ),
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: DashboardPage(
              events: _events,
              onEventUpdated: _fetchUpdatedEvents, 
            ),
          ),
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: EventsPage(
              onEventUpdated: _loadUserData,
              events: _events,
            ),
          ),
        ],
      ),
    );
  }
  
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}