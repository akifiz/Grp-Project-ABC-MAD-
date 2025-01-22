import 'package:cloud_firestore/cloud_firestore.dart';

// table EXPENSES
// int:PK expenseId
// int:FK eventId
// int:FK userId [...]
// int:who paid (index of userId)
// float:total
// map:split [int:id, float:amount...]
// string:expense title
// :dateTime
// bool:isSettled
// string:subDescription

class Expense {
  final String title;
  final double amount;
  final int paidBy;
  final String split;
  final String dateTime;
  final bool isSettled;

  Expense({required this.title, required this.amount, required this.paidBy, required this.split, required this.dateTime, required this.isSettled});

  // Factory method to create a expense object from a Firestore document
  factory Expense.fromFirestore(Map<String, dynamic> data) {
    return Expense(
      title: data['name'] ?? '',
      amount: data['email'] ?? '',
      paidBy: data['paidBy'] ?? 0,
      split: data['split'] ?? '',
      dateTime: data['dateTime'] ?? '',
      isSettled: data['isSettled'] ?? false,
    );
  }
}

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all expenses from the "expenses" collection
  Future<List<Expense>> fetchExpenses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('expenses').get();
      List<Expense> expenses = querySnapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // Add a new expense to the "expenses" collection
  Future<void> addExpense(String name, String email, int age) async {
    try {
      await _firestore.collection('Expenses').add({
        '': name,
        'email': email,
        'age': age,
      });
      print('expense added successfully!');
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  // Update an existing expense's data by document ID
  Future<void> updateExpense(
      String docId, String name, String email, int age) async {
    try {
      await _firestore.collection('expenses').doc(docId).update({
        'name': name,
        'email': email,
        'age': age,
      });
      print('expense updated successfully!');
    } catch (e) {
      print('Error updating expense: $e');
    }
  }
}
