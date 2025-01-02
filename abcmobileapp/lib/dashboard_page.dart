import 'package:flutter/material.dart';
import 'app_colors.dart';

class DashboardPage extends StatelessWidget {
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40), // Adjust gap between header and content
        Expanded(
          child: Center(
            child: Text(
              'Dashboard Page',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
