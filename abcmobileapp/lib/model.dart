import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class User {
  final String userId;
  final String defaultName;
  final List<String> eventId;

  User({
    required this.userId,
    required this.defaultName,
    required this.eventId,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      userId: data['userId'] ?? '',
      defaultName: data['defaultName'],
      eventId: List<String>.from(data['eventId'] ?? []),
    );
  }
}

class Event {
  final String eventId;
  final String title;
  final String date;
  final String time;
   List<String> userId;
  List<String> balance;

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.userId,
    required this.balance,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      eventId: data['eventId'],
      title: data['title'],
      date: data['date'],
      time: data['time'],
      userId: List<String>.from(data['userId']),
      balance: List<String>.from(data['balance']),
    );
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final String split;
  final String date;
  final String time;

  Expense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.paidBy,
      required this.split,
      required this.date,
      required this.time});

  // Factory method to create a expense object from a Firestore document
  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      amount: data['amount'] ?? 0,
      paidBy: data['paidBy'] ?? '',
      split: data['split'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
    );
  }
}

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all expenses from the "expenses" collection of event id
  Future<List<Expense>> fetchExpenses(String eventId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('EVENTS')
          .doc(eventId)
          .collection('EXPENSES')
          .get();
      List<Expense> expenses = querySnapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Fetch all events from the "EVENTS" collection based on list of events
  Future<List<Event>> fetchEvents(List<String> eventList) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('EVENTS')
          .where("eventId", whereIn: eventList)
          .get();
      List<Event> events = querySnapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<User> fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc =
        await _firestore.collection('USERS').doc(userId).get();
      return User.fromFirestore(doc);
    } catch (e) {
      print('Error fetching user data: $e');
    }
    throw new Exception("Error fetching user ${userId} data");
  }

  Future<void> createEvent(Event event) async {
  try{
    await _firestore.collection('EVENTS').doc(event.eventId).set({
      'eventId': event.eventId,
      'title': event.title,
      'date': event.date,
      'time': event.time, 
      'userId': List<String>.from(event.userId),
    });

    for(var i = 0; i < event.userId.length; i++){
      await _firestore
          .collection('EVENTS')
          .doc(event.eventId)
          .update({
        'balance': List.filled(event.userId.length, createRepeatingPattern('0,', event.userId.length)),
      });

      await _firestore
          .collection('USERS')
          .doc(event.userId[i])
          .update({
            'eventId': FieldValue.arrayUnion([event.eventId]),
          });
    }
  } catch (e){
    print("Error creating an event");
  }
  }

  Future<void> createExpense(Expense expense, String eventId) async{
   try{
    await _firestore.collection('EVENTS').doc(eventId).collection('EXPENSES').doc(expense.id).set({
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'paidBy': expense.paidBy,
      'split': expense.split,
      'date': expense.date,
      'time': expense.time,
    });

  } catch (e){
    print("Error creating an expense");
  }   
  }

  Future<void> updateBalance(List<String> newBalance, String eventId) async{
   try{
    await _firestore.collection('EVENTS').doc(eventId).update({
      'balance': newBalance,
    });
  } catch (e){
    print("Error updating balance to firestore: $e");
  }   

  }

  String createRepeatingPattern(String pattern, int times) {
    return List.generate(times, (index) => pattern).join('');
  }

  // // Add a new expense to the "expenses" collection
  // Future<void> addExpense(String name, String email, int age) async {
  //   try {
  //     await _firestore.collection('Expenses').add({
  //       '': name,
  //       'email': email,
  //       'age': age,
  //     });
  //     print('expense added successfully!');
  //   } catch (e) {
  //     print('Error adding expense: $e');
  //   }
  // }

  // // Update an existing expense's data by document ID
  // Future<void> updateExpense(
  //     String docId, String name, String email, int age) async {
  //   try {
  //     await _firestore.collection('expenses').doc(docId).update({
  //       'name': name,
  //       'email': email,
  //       'age': age,
  //     });
  //     print('expense updated successfully!');
  //   } catch (e) {
  //     print('Error updating expense: $e');
  //   }
  // }
}
