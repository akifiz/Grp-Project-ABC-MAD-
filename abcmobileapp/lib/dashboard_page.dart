import 'package:flutter/material.dart';
import 'app_colors.dart';

class DashboardPage extends StatelessWidget {
  // List of expenses (people we owe money to)
  final List<Map<String, String>> expenses = [
    {"Name": "Alice ALI KABAKARA", "Event": "Birthday Party", "Amount": "50"},
    {"Name": "Bob", "Event": "Wedding", "Amount": "100"},
    {"Name": "Charlie", "Event": "Conference", "Amount": "75"},
    {"Name": "Derek", "Event": "Dinner", "Amount": "30"},
    {"Name": "Eve", "Event": "Concert", "Amount": "120"},
  ];

  // List of debtors (people who owe us money)
  final List<Map<String, String>> debtors = [
    {"Name": "Frank", "Event": "Project", "Amount": "200"},
    {"Name": "Grace", "Event": "Lunch", "Amount": "50"},
    {"Name": "Hannah", "Event": "Conference", "Amount": "150"},
    {"Name": "Ian", "Event": "Workshop", "Amount": "100"},
    {"Name": "Jack", "Event": "Seminar", "Amount": "300"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page title
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Dashboard',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.pagen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),

        // Section title: Your Expenses
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

        // First table: Expenses (People We Owe)
        _buildScrollableTable(
          data: expenses,
          columnName: 'Amount',
        ),

        const SizedBox(height: 40), // Space between tables

        // Section title: Debtors
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

        // Second table: Debtors (People Who Owe Us)
        _buildScrollableTable(
          data: debtors,
          columnName: 'Amount',
        ),
      ],
    );
  }

  // Build a scrollable table with a fixed height
  Widget _buildScrollableTable({
    required List<Map<String, String>> data,
    required String columnName,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          // Scrollable table body
          Container(
            height: 240, // Fixed height for 4 rows + scrollbar space
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
                      'Amount\nOwed', // Break into two lines
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                      textAlign: TextAlign.center, // Center-align text
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

          // Total row (static, not scrollable)
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

  // Method to build individual cells with consistent styling
DataCell _buildCell(String content, {FontWeight? fontWeight}) {
  return DataCell(
    SizedBox(
      width: double.infinity, // Ensures the text occupies available space
      child: Text(
        content,
        style: TextStyle(
          color: AppColors.main,
          fontSize: 14,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
        softWrap: true, // Enables line wrapping
        overflow: TextOverflow.visible, // Ensures all text is visible
      ),
    ),
  );
}

  // Calculate the total amount for a table
  double _calculateTotal(List<Map<String, String>> data, String columnName) {
    double total = 0;
    for (var entry in data) {
      total += double.tryParse(entry[columnName] ?? '0') ?? 0;
    }
    return total;
  }
}
