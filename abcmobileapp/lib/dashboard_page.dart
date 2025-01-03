import 'package:flutter/material.dart';
import 'app_colors.dart';

class DashboardPage extends StatelessWidget {
  final List<Map<String, String>> expenses = [
    {"Name": "Alice", "Event": "Birthday Party", "Amount": "50"},
    {"Name": "Bob", "Event": "Wedding", "Amount": "100"},
    {"Name": "Charlie", "Event": "Conference", "Amount": "75"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Your Expenses',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center, // Center the title
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0), // Adjust padding for width control
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center( // Center the table content
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600), // Constrain table width
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.sub.withOpacity(0.8)),
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
                          'Amount Owed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ],
                    rows: expenses
                        .map(
                          (expense) => DataRow(
                            cells: [
                              DataCell(Text(
                                expense["Name"] ?? '',
                                style: const TextStyle(
                                  color: AppColors.main,
                                  fontSize: 14,
                                ),
                              )),
                              DataCell(Text(
                                expense["Event"] ?? '',
                                style: const TextStyle(
                                  color: AppColors.main,
                                  fontSize: 14,
                                ),
                              )),
                              DataCell(Text(
                                '\RM${expense["Amount"] ?? ''}',
                                style: const TextStyle(
                                  color: AppColors.main,
                                  fontSize: 14,
                                ),
                              )),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
