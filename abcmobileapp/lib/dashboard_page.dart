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

        // Balances Table Section
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

        // Updated table container with improved scrolling and centering
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center, // Center the content horizontally
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 800 ? 800 : screenWidth - 32, // Limit max width while staying responsive
            ),
            child: Card(
              color: AppColors.subAlt,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // Maximum height (40% of screen height)
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Header
                              Table(
                                defaultColumnWidth: const IntrinsicColumnWidth(),
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: AppColors.main.withOpacity(0.2))),
                                    ),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            'EVENT',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.main,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            'DATE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.main,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            'AMOUNT',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.main,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Table Rows for each event
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
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                            child: Text(
                                              event.title,
                                              style: TextStyle(color: AppColors.main),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                            child: Text(
                                              event.date,
                                              style: TextStyle(color: AppColors.main),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                            child: Text(
                                              'RM ${eventBalance.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: eventBalance >= 0 ? Colors.green : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                              // Total Balance Row
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total Balance: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.main,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'RM ${totalBalance.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: totalBalance >= 0 ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      ? Card(
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
                      : ListView.builder(
                          itemCount: allExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = allExpenses[index];
                            List<double> splits = mapToDoubleList(expense.split);
                            double relevantAmount = expense.paidBy == 0
                                ? expense.amount
                                : (splits.isNotEmpty ? -splits[0] : 0.0);

                            return Card(
                              color: AppColors.subAlt,
                              child: ListTile(
                                title: Text(
                                  expense.title,
                                  style: TextStyle(
                                    color: AppColors.main,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${expense.date} | ${expense.time}',
                                  style: TextStyle(
                                    color: AppColors.main.withOpacity(0.7),
                                  ),
                                ),
                                trailing: Text(
                                  'RM ${relevantAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: relevantAmount >= 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}