import 'package:flutter/material.dart';
import 'app_colors.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard Page',
        style: TextStyle(
          fontSize: 24,
          color: AppColors.text, // Text color from theme
        ),
      ),
    );
  }
}
