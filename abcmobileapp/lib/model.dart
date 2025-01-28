import 'package:cloud_firestore/cloud_firestore.dart';
class Event {
  final String eventId;
  final String title;
  final String date;
  final String time;
  final String finalBalance;
  final List<String> userId;

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.finalBalance,
    required this.userId,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      eventId: data['eventId'],
      title: data['title'],
      date: data['date'],
      time: data['time'],
      finalBalance: data['finalBalance'],
      userId: List<String>.from(data['userId']),
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

  Expense({required this.id, required this.title, required this.amount, required this.paidBy, required this.split, required this.date, required this.time});

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


  // Fetch all events from the "EVENTS" collection based on user id events
  Future<List<Event>> fetchEvents(String userId) async {
    try {
      //TODO: fetch events of specific user not all events
      QuerySnapshot querySnapshot = await _firestore
          .collection('EVENTS')
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
