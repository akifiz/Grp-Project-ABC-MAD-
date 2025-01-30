import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model.dart';

class DashboardPage extends StatefulWidget {
  final List<Event> events;
  final VoidCallback onEventUpdated;

  const DashboardPage({
    Key? key,
    required this.events,
    required this.onEventUpdated,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _calculateTotalBalance() {
    double totalBalance = 0.0;
    for (var event in widget.events) {
      if (event.userId.isNotEmpty && event.balance.isNotEmpty) {
        List<double> firstUserBalance = mapToDoubleList(event.balance[0]);
        if (firstUserBalance.isNotEmpty) {
          totalBalance += firstUserBalance.reduce((a, b) => a + b);
        }
      }
    }
    return totalBalance;
  }

  List<Expense> _getAllExpenses() {
    List<Expense> allExpenses = [];
    for (var event in widget.events) {
      if (event.expenses != null) {
        allExpenses.addAll(event.expenses!.where((expense) {
          if (event.userId.isNotEmpty) {
            List<double> splits = mapToDoubleList(expense.split);
            return expense.paidBy == 0 || (splits.isNotEmpty && splits[0] > 0);
          }
          return false;
        }));
      }
    }
    allExpenses.sort((a, b) {
      int dateComparison = b.date.compareTo(a.date);
      if (dateComparison != 0) return dateComparison;
      return b.time.compareTo(a.time);
    });
    return allExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = _calculateTotalBalance();
    final allExpenses = _getAllExpenses();
    final screenWidth = MediaQuery.of(context).size.width;

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

        // Current Balance Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),

        // Wider Balance Table
        Container(
          width: double.infinity, // Make full-width like Recent Transactions
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            color: AppColors.subAlt,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Table Header
                  Table(
                    defaultColumnWidth: const FlexColumnWidth(),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.main.withOpacity(0.2))),
                        ),
                        children: [
                          _tableHeader('EVENT'),
                          _tableHeader('DATE'),
                          _tableHeader('AMOUNT'),
                        ],
                      ),

                      // Event Balance Rows
                      ...widget.events.map((event) {
                        double eventBalance = 0.0;
                        if (event.balance.isNotEmpty) {
                          List<double> firstUserBalance = mapToDoubleList(event.balance[0]);
                          if (firstUserBalance.isNotEmpty) {
                            eventBalance = firstUserBalance.reduce((a, b) => a + b);
                          }
                        }

                        return TableRow(
                          children: [
                            _tableCell(event.title),
                            _tableCell(event.date),
                            _tableCell(
                              'RM ${eventBalance.toStringAsFixed(2)}',
                              color: eventBalance >= 0 ? Colors.green : Colors.red,
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),

                  // Extra Spacing Before Total Balance (2 blank spaces)
                  const SizedBox(height: 32),

                  // Total Balance Row
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total Balance: RM ${totalBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white, // Changed to white
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Recent Transactions Section
        Expanded(
          child: Column(
            children: [
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
                  child: allExpenses.isEmpty
                      ? _noTransactionsCard()
                      : _transactionList(allExpenses),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Table Header Cell
  Widget _tableHeader(String title) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.main,
          ),
          textAlign: TextAlign.center, // Center the header text
        ),
      ),
    );
  }

  // Table Cell for Data
  Widget _tableCell(String text, {Color? color}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? AppColors.main,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  // Empty Transactions Message
  Widget _noTransactionsCard() {
    return Card(
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
            const SizedBox(height: 16),
            Text(
              'No transactions recorded yet',
              style: TextStyle(
                color: AppColors.main,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }

  // Transactions List
  Widget _transactionList(List<Expense> allExpenses) {
    return ListView.builder(
      itemCount: allExpenses.length,
      itemBuilder: (context, index) {
        final expense = allExpenses[index];
        return Card(
          color: AppColors.subAlt,
          child: ListTile(
            title: Text(expense.title, style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold)),
            subtitle: Text('${expense.date} | ${expense.time}', style: TextStyle(color: AppColors.main.withOpacity(0.7))),
            trailing: Text(
              'RM ${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
