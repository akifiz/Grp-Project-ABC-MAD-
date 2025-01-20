class Event {
  final String id;
  final String name;
  final DateTime date;
  final int numberOfPeople;
  final List<Expense> expenses;

  Event({
    String? id,
    required this.name,
    required this.date,
    required this.numberOfPeople,
    this.expenses = const [],
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'expenses': expenses.map((e) => e.toJson()).toList(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      numberOfPeople: json['numberOfPeople'],
      expenses: (json['expenses'] as List)
          .map((e) => Expense.fromJson(e))
          .toList(),
    );
  }
}

class Expense {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> sharedWith;
  final DateTime date;

  Expense({
    String? id,
    required this.name,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.sharedWith,
    DateTime? date,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       this.date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'sharedWith': sharedWith,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      paidBy: json['paidBy'],
      sharedWith: List<String>.from(json['sharedWith']),
      date: DateTime.parse(json['date']),
    );
  }
}