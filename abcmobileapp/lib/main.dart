import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'events_page.dart';
import 'base_layout.dart';
import 'app_colors.dart';
import 'model.dart';
import 'settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //TODO: fetch userId based on account login
  final String _userId = "U1";
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);
  List<Event> _events = [];
  late User _userData;
  
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
      User userData = await handler.fetchUserData(_userId);
      setState((){
        _userData = userData;
      });

      List<Event> userEvents = await handler.fetchEvents(_userData.eventId);
      setState(() {
        _events = userEvents;
      });
    }catch(e){
      print('Error loading user data $e');
    }
  }



  // void _updateEvent(Event event) {
  //   // final index = events.indexWhere((e) => e.id == event.id);
  //   // if (index != -1) {
  //   //   setState(() {
  //   //     events[index] = event;
  //   //   });
  //   //   _saveEvents();
  //   // }
  // }

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
            child: SettingsPage(
              userData: _userData,
            ),
          ),
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: DashboardPage(
              userData: _userData,
              events: _events
            ),
          ),
          BaseLayout(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            child: EventsPage(
              userData: _userData,
              events: _events,
              onEventUpdated: _loadUserData,
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