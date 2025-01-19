import 'package:flutter/material.dart';

class Event {
  final String name;
  final DateTime date;
  final int numberOfPeople;
  final List<Expense> expenses;

  Event({
    required this.name,
    required this.date,
    required this.numberOfPeople,
    this.expenses = const [],
  });
}

class Expense {
  final String name;
  final String event;
  final double amount;
  final String paidBy;
  final List<String> sharedWith;

  Expense({
    required this.name,
    required this.event,
    required this.amount,
    required this.paidBy,
    required this.sharedWith,
  });
}