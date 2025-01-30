import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model.dart';

class DashboardPage extends StatefulWidget {
  final List<Event> events;
  final VoidCallback onEventUpdated; // ✅ ADD THIS

  const DashboardPage({
    Key? key,
    required this.events,
    required this.onEventUpdated, // ✅ ADD THIS

  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState(); // createState()
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, double> _calculateBalances() {
    final Map<String, double> balances = {};

    for (var event in widget.events) { // ✅ Use widget.events inside StatefulWidget
      if (event.userId.contains(global_userId) && event.expenses != null) {
        for (var expense in event.expenses!) {
          if (expense.paidBy == global_userId) {
            balances[global_userId] = (balances[global_userId] ?? 0) + expense.amount;
          } else {
            balances[global_userId] = (balances[global_userId] ?? 0) - (expense.amount / event.userId.length);
          }
        }
      }
    }
    return balances;
  }

  @override
  Widget build(BuildContext context) {
    final balances = _calculateBalances();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'DASHBOARD',
            style: TextStyle(
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
            'Current Balance (User 1)',
            style: TextStyle(
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
            child: Card(
              color: AppColors.subAlt,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Balance',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'RM ${balances["U1"]?.toStringAsFixed(2) ?? "0.00"}',
                      style: TextStyle(
                        color: balances["U1"] != null && balances["U1"]! >= 0 ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 20),

        // Recent Transactions Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Recent Transactions',
            style: TextStyle(
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
            child: widget.events.isEmpty
                ? Card(
                    color: AppColors.subAlt,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, color: AppColors.main.withOpacity(0.7), size: 48),
                          SizedBox(height: 16),
                          Text('No transactions recorded yet',
                              style: TextStyle(color: AppColors.main, fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8),
                          Text('Add expenses in your events to track transactions',
                              style: TextStyle(color: AppColors.main.withOpacity(0.7), fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.events.expand((event) => event.expenses ?? []).length,
                    itemBuilder: (context, index) {
                      var allExpenses = widget.events.expand((event) => event.expenses ?? []).toList();
                      final expense = allExpenses[index];

                      return Card(
                        color: AppColors.subAlt,
                        child: ListTile(
                          title: Text(
                            expense.title, // Expense name
                            style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${expense.date} | ${expense.time} | ${expense.amount}',
                            style: TextStyle(color: AppColors.main.withOpacity(0.7)),
                          ),
                          trailing: Text(
                            'RM ${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
