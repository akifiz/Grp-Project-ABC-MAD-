import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'model.dart';

class SettingsPage extends StatefulWidget {
  final User userData;
  const SettingsPage({
    Key? key,
    required this.userData,
    }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> currencies = ['USD', 'MYR', 'SGD', 'EUR'];
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadCurrencyPreference();
  }

  // Load saved currency preference from shared preferences
  _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs.getString('selected_currency') ?? 'USD';
    });
  }

  // Save the selected currency to shared preferences
  _saveCurrencyPreference(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_currency', currency);
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Center(
            child: Text(
              'About',
              style: TextStyle(color: AppColors.text),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Expense Tracker App',
                style: TextStyle(color: AppColors.main, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Version 1.0.0',
                style: TextStyle(color: AppColors.main, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Developed by Group ABC',
                style: TextStyle(color: AppColors.main, fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('OK', style: TextStyle(color: AppColors.text)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _dummyLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully (dummy function)'),
        backgroundColor: Colors.red,
      ),
    );
  }

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

        // Currency Selection Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Select Currency',
            style: TextStyle(fontSize: 20, color: AppColors.text, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.subAlt,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedCurrency,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.main),
              dropdownColor: AppColors.background,
              style: TextStyle(color: AppColors.main, fontSize: 18),
              underline: Container(),
              items: currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
                _saveCurrencyPreference(value!);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // About Section
        ListTile(
          leading: Icon(Icons.info_outline, color: AppColors.text),
          title: Text('About', style: TextStyle(color: AppColors.main)),
          onTap: () => _showAboutDialog(context),
        ),
        Divider(color: AppColors.subAlt),

        // Dummy Logout Button
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
          title: Text('Logout', style: TextStyle(color: AppColors.main)),
          onTap: () => _dummyLogout(context),
        ),
        Divider(color: AppColors.subAlt),
      ],
    );
  }
}
