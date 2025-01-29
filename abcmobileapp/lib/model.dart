import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'currency.dart';
class CurrencyManager {
  static const String _currencyPrefKey = 'selected_currency';
  static String _currentCurrency = 'USD';
  static final CurrencyManager _instance = CurrencyManager._internal();
  
  factory CurrencyManager() {
    return _instance;
  }
  
  CurrencyManager._internal();
  
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCurrency = prefs.getString(_currencyPrefKey) ?? 'USD';
  }
  
  String get currentCurrency => _currentCurrency;
  
  Future<void> setCurrentCurrency(String currency) async {
    _currentCurrency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyPrefKey, currency);
  }
}

class User {
  final String userId;
  final String defaultName;
  final List<String> eventId;
  String preferredCurrency;

  User({
    required this.userId,
    required this.defaultName,
    required this.eventId,
    this.preferredCurrency = 'USD',
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      userId: data['userId'] ?? '',
      defaultName: data['defaultName'] ?? '',
      eventId: List<String>.from(data['eventId'] ?? []),
      preferredCurrency: data['preferredCurrency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'defaultName': defaultName,
      'eventId': eventId,
      'preferredCurrency': preferredCurrency,
    };
  }
}

class Event {
  final String eventId;
  final String title;
  final String date;
  final String time;
  final String baseCurrency; // Currency in which expenses are stored
  final String finalBalance;
  final List<String> userId;

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.finalBalance,
    required this.userId,
    this.baseCurrency = 'USD',
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      eventId: data['eventId'] ?? '',
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      finalBalance: data['finalBalance'] ?? '',
      userId: List<String>.from(data['userId'] ?? []),
      baseCurrency: data['baseCurrency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'title': title,
      'date': date,
      'time': time,
      'finalBalance': finalBalance,
      'userId': userId,
      'baseCurrency': baseCurrency,
    };
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String originalCurrency;
  final String paidBy;
  final String split;
  final String date;
  final String time;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.split,
    required this.date,
    required this.time,
    this.originalCurrency = 'USD',
  });

  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paidBy: data['paidBy'] ?? '',
      split: data['split'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      originalCurrency: data['originalCurrency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'split': split,
      'date': date,
      'time': time,
      'originalCurrency': originalCurrency,
    };
  }

  Future<double> getConvertedAmount(String targetCurrency) async {
    if (originalCurrency == targetCurrency) return amount;
    
    final currencyService = CurrencyService();
    final rate = await currencyService.getExchangeRate(originalCurrency, targetCurrency);
    return amount * rate;
  }
}

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Expense>> fetchExpenses(String eventId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('EVENTS')
          .doc(eventId)
          .collection('EXPENSES')
          .get();
      return querySnapshot.docs
          .map((doc) => Expense.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  Future<List<Event>> fetchEvents(List<String> eventList) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('EVENTS')
          .where("eventId", whereIn: eventList)
          .get();
      return querySnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<User> fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('USERS').doc(userId).get();
      return User.fromFirestore(doc);
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception("Error fetching user ${userId} data");
    }
  }

  Future<void> updateUserCurrency(String userId, String currency) async {
    try {
      await _firestore.collection('USERS').doc(userId).update({
        'preferredCurrency': currency,
      });
    } catch (e) {
      print('Error updating user currency: $e');
      throw Exception("Error updating user currency");
    }
  }
}