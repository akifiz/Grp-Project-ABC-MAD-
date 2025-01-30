import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:core';

String global_userId = "";
String global_defaultName = "";

String generateUuid(){
  var uuid = Uuid();
  return uuid.v4();
}

class UserData {
  final String userId;
  final String defaultName;
  final List<String> eventId;

  UserData({
    required this.userId,
    required this.defaultName,
    required this.eventId,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      userId: data['userId'] ?? '',
      defaultName: data['defaultName'],
      eventId: List<String>.from(data['eventId']),
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
  List<String>? userName;
  List<String> balance;
  List<Expense>? expenses; 

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.time,
    required this.totalSpending,
    required this.userId,
    this.userName,
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
      userName: List<String>.from(data['userName']),
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

  Future<void> createUserData(String userId, String defaultName)async {
    try{
      await _firestore.collection('USERS').doc(userId).set({
      'userId': userId,
      'defaultName': defaultName,
      'eventId': [''],
    });
    }catch(e){
      print('Error creating user');
    }
  }

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
        userName: List<String>.from(eventData['userName']),
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


  Future<UserData> fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc =
        await _firestore.collection('USERS').doc(userId).get();
      return UserData.fromFirestore(doc);
    } catch (e) {
      print('Error fetching user data: $e');
    }
    throw new Exception("Error fetching user ${userId} data");
  }

  Future<void> createEvent(Event event) async {
  try{
    //fetch names of user in the event
    List<String> userName = [];
    for(var id in event.userId){
      DocumentSnapshot userData = await _firestore.collection('USERS').doc(id).get();
      userName.add(userData['defaultName']);
    }

    await _firestore.collection('EVENTS').doc(event.eventId).set({
      'eventId': event.eventId,
      'title': event.title,
      'date': event.date,
      'time': event.time,
      'userName': userName,
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

String moneyFormat(String currency, double amountMyr,
    [double exchangeRate = 1]) {
  amountMyr *= exchangeRate;
  return "${currency}${amountMyr.toStringAsFixed(2)}";
}

//helper methods
List<double> mapToDoubleList(String str) {
  return str
      .split(',') // Split by comma
      .where((s) => s.isNotEmpty) // Remove empty values
      .map((s) => double.parse(s)) // Convert to double
      .toList();
}

List<List<double>> mapToDoubleListList(List<String> stringList) {
  return stringList.map((str) {
    return mapToDoubleList(str);
  }).toList();
}

List<String> doubleListListToStringList(List<List<double>> doubleList) {
  return doubleList.map((innerList) {
    return innerList.map((d) => d.toString()).join(',');
  }).toList();
}

String doubleListToString(List<double> doubleList) {
  return doubleList.map((d) => d.toString()).join(',');
}

List<double> addDoubleLists(List<double> list1, List<double> list2) {
  int minLength = list1.length < list2.length ? list1.length : list2.length;
  return List.generate(minLength, (i) => list1[i] + list2[i]);
}
