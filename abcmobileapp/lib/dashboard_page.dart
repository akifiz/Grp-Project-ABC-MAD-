import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model.dart';

class DashboardPage extends StatelessWidget {
  final List<Event> events;

  const DashboardPage({
    Key? key,
    required this.events,
  }) : super(key: key);

  // List<Map<String, dynamic>> _processExpenses() {
  //   final List<Map<String, dynamic>> expenses = [];
  //   double totalAmount = 0;

  //   for (var event in events) {
  //     for (var expense in event.expenses) {
  //       // Calculate individual shares
  //       double share = expense.amount / expense.sharedWith.length;
        
  //       // Add expense for the person who paid
  //       expenses.add({
  //         'type': 'paid',
  //         'name': expense.paidBy,
  //         'event': event.name,
  //         'amount': expense.amount,
  //         'date': expense.date,
  //       });
  //       totalAmount += expense.amount;

  //       // Add entries for people who owe money
  //       for (var person in expense.sharedWith) {
  //         if (person != expense.paidBy) {
  //           expenses.add({
  //             'type': 'owed',
  //             'name': person,
  //             'event': event.name,
  //             'amount': share,
  //             'date': expense.date,
  //           });
  //         }
  //       }
  //     }
  //   }

  //   // Sort expenses by date
  //   expenses.sort((a, b) => b['date'].compareTo(a['date']));
  //   return expenses;
  // }

  Map<String, double> _calculateBalances() {
    final Map<String, double> balances = {};

    // for (var event in events) {
    //   for (var expense in event.expenses) {
    //     // Add to payer's balance
    //     balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;

    //     // Subtract shares from participants
    //     double share = expense.amount / expense.sharedWith.length;
    //     for (var person in expense.sharedWith) {
    //       balances[person] = (balances[person] ?? 0) - share;
    //     }
    //   }
    // }

    return balances;
  }

  // In dashboard_page.dart
@override
Widget build(BuildContext context) {
  //final expenses = _processExpenses();
  final balances = _calculateBalances();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          'DASHBOARD',
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.pagen,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20),

      // Balances Section
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Current Balances',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 10),
      if (balances.isEmpty)
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Card(
            color: AppColors.subAlt,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.main.withOpacity(0.7),
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No ongoing debts or credits',
                    style: TextStyle(
                      color: AppColors.main,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      else
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: balances.length,
            itemBuilder: (context, index) {
              String person = balances.keys.elementAt(index);
              double balance = balances[person]!;
              return Card(
                color: AppColors.subAlt,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        person,
                        style: TextStyle(
                          color: AppColors.main,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RM ${balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: balance >= 0 ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

      const SizedBox(height: 20),

      // Recent Transactions Section
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Recent Transactions',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: //expenses.isEmpty
                 Card(
                  color: AppColors.subAlt,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.main.withOpacity(0.7),
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No transactions recorded yet',
                          style: TextStyle(
                            color: AppColors.main,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add expenses in your events to track transactions',
                          style: TextStyle(
                            color: AppColors.main.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              // : ListView.builder(
              //     itemCount: expenses.length,
              //     itemBuilder: (context, index) {
              //       final expense = expenses[index];
              //       return Card(
              //         color: AppColors.subAlt,
              //         child: ListTile(
              //           title: Text(
              //             expense['event'],
              //             style: TextStyle(
              //               color: AppColors.main,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           subtitle: Text(
              //             '${expense['name']} ${expense['type'] == 'paid' ? 'paid' : 'owes'} RM${expense['amount'].toStringAsFixed(2)}',
              //             style: TextStyle(
              //               color: AppColors.main.withOpacity(0.7),
              //             ),
              //           ),
              //           trailing: Text(
              //             expense['date'].toString().split(' ')[0],
              //             style: TextStyle(
              //               color: AppColors.main,
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
        ),
      ),
    ],
  );
}}