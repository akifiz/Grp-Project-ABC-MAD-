// dashboard_page.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'event_model.dart'; // Add this new import

class DashboardPage extends StatelessWidget {
  final List<Event> events; // Add this

  const DashboardPage({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert events to expense lists
    final List<Map<String, String>> expenses = [];
    final List<Map<String, String>> debtors = [];
    
    // Populate expenses and debtors from events
    for (var event in events) {
      for (var expense in event.expenses) {
        expenses.add({
          "Name": expense.paidBy,
          "Event": event.name,
          "Amount": expense.amount.toString(),
        });
        
        // Calculate individual shares
        double share = expense.amount / expense.sharedWith.length;
        for (var person in expense.sharedWith) {
          if (person != expense.paidBy) {
            debtors.add({
              "Name": person,
              "Event": event.name,
              "Amount": share.toString(),
            });
          }
        }
      }
    }

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

        if (expenses.isEmpty && debtors.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                'No expenses yet.\nCreate an event to start tracking!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.main,
                  fontSize: 18,
                ),
              ),
            ),
          )
        else ...[
          // Your Expenses Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Your Expenses',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          _buildScrollableTable(
            data: expenses,
            columnName: 'Amount',
          ),

          const SizedBox(height: 40),

          // Debtors Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Debtors',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          _buildScrollableTable(
            data: debtors,
            columnName: 'Amount',
          ),
        ],
      ],
    );
  }

  // 
  Widget _buildScrollableTable({
    required List<Map<String, String>> data,
    required String columnName,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Container(
            height: 240,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => AppColors.sub.withOpacity(0.8),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Amount\nOwed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: data.map((entry) {
                  return DataRow(
                    cells: [
                      _buildCell(entry['Name'] ?? ''),
                      _buildCell(entry['Event'] ?? ''),
                      _buildCell('RM${entry[columnName] ?? ''}'),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
              Text(
                'RM${_calculateTotal(data, columnName).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataCell _buildCell(String content, {FontWeight? fontWeight}) {
    return DataCell(
      SizedBox(
        width: double.infinity,
        child: Text(
          content,
          style: TextStyle(
            color: AppColors.main,
            fontSize: 14,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  double _calculateTotal(List<Map<String, String>> data, String columnName) {
    double total = 0;
    for (var entry in data) {
      total += double.tryParse(entry[columnName] ?? '0') ?? 0;
    }
    return total;
  }
}