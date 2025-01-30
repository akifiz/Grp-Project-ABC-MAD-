import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

final String userId = "U1";
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
  double totalSpending;
  List<String> userId;
  List<String> balance;
  List<Expense>? expenses; 

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.totalSpending,
    required this.userId,
    required this.balance,
    this.expenses, 
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      eventId: data['eventId'],
      title: data['title'],
      date: data['date'],
      time: data['time'],
      totalSpending: data['totalSpending'],
      userId: List<String>.from(data['userId']),
      balance: List<String>.from(data['balance']),
      expenses: [], 
    );
  }
}


class Expense {
  final String id;
  final String title;
  final double amount;
  final int paidBy;
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
      paidBy: data['paidBy'] ?? 0,
      split: data['split'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
    );
  }
}

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all expenses from the "expenses" collection of event id
Future<List<Event>> fetchEvents(List<String> eventList) async {
  try {
    QuerySnapshot eventSnapshots = await FirebaseFirestore.instance
        .collection('EVENTS')
        .where("eventId", whereIn: eventList)
        .get();

    List<Event> events = [];

    for (var doc in eventSnapshots.docs) {
      Map<String, dynamic> eventData = doc.data() as Map<String, dynamic>;

      // Fetch expenses for this event
      List<Expense> eventExpenses = await fetchExpenses(eventData['eventId']);

      // Create event object including expenses
      events.add(Event(
        eventId: eventData['eventId'],
        title: eventData['title'],
        date: eventData['date'],
        time: eventData['time'],
        totalSpending: eventData['totalSpending'],
        userId: List<String>.from(eventData['userId']),
        balance: List<String>.from(eventData['balance']),
        expenses: eventExpenses, // ✅ Load expenses into event
      ));
    }
    return events;
  } catch (e) {
    print('Error fetching events: $e');
    return [];
  }
}

// ✅ Helper function to fetch expenses for an event
Future<List<Expense>> fetchExpenses(String eventId) async {
  try {
    QuerySnapshot expenseSnapshots = await FirebaseFirestore.instance
        .collection('EVENTS')
        .doc(eventId)
        .collection('EXPENSES')
        .get();

    return expenseSnapshots.docs.map((doc) {
      return Expense.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error fetching expenses for event $eventId: $e');
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
      'totalSpending': event.totalSpending,
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

  Future<void> updateBalance(List<String> newBalance, String eventId, double totalSpending) async{
   try{
    await _firestore.collection('EVENTS').doc(eventId).update({
      'balance': newBalance,
      'totalSpending': totalSpending,
    });
  } catch (e){
    print("Error updating balance to firestore: $e");
  }   

  }

  Future<void> deleteEvent(Event event) async{
   try{
    //delete Expenses
    QuerySnapshot expensesSnapshot = await _firestore.collection("EVENTS").doc(event.eventId).collection("EXPENSES").get();
    for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete(); // Delete each document inside the subcollection
    }

    //delete the event
    await _firestore.collection("EVENTS").doc(event.eventId).delete().then(
            (doc) => print("${event.eventId} deleted"),
            onError: (e) => print("Error updating EVENTS: $e"),
          );

    //update users eventId
    for(var i = 0; i < event.userId.length; i++){
      await _firestore.collection("USERS").doc(event.userId[i]).update({
          'eventId': FieldValue.arrayRemove([event.eventId])
      });
    }

  } catch (e){
    print("Error deleting event ${event.eventId} on firestore: $e");
  }   

  }
}

String createRepeatingPattern(String pattern, int times) {
  return List.generate(times, (index) => pattern).join('');
}

