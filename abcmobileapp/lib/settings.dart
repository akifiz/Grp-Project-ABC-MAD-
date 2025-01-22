import 'package:flutter/material.dart';
import 'app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'SETTINGS',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.pagen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: Text(
              'Settings Page Content',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.main,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
