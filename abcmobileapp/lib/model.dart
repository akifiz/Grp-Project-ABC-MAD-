import 'package:cloud_firestore/cloud_firestore.dart';
class Event {
  final String id;
  final String name;
  final String dateTime;
  final List<String> userId;
  final List<String> expenseId;

  Event({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.userId,
    required this.expenseId,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      id: data['id'],
      name: data['name'],
      dateTime: data['dateTime'],
      userId: List<String>.from(data['userId']),
      expenseId: List<String>.from(data['expenseId']),
    );
  }
}


class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final String split;
  final String dateTime;

  Expense({required this.id, required this.title, required this.amount, required this.paidBy, required this.split, required this.dateTime});

  // Factory method to create a expense object from a Firestore document
  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      id: data['id'] ?? '',
      title: data['name'] ?? '',
      amount: data['amount'] ?? 0,
      paidBy: data['paidBy'] ?? '',
      split: data['split'] ?? '',
      dateTime: data['dateTime'] ?? '',
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
