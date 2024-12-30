import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CurrencyPage(),
    );
  }
}

class CurrencyPage extends StatefulWidget {
  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  double? conversionRate;

  @override
  void initState() {
    super.initState();
    fetchConversionRate();
  }

  Future<void> fetchConversionRate() async {
    final apiKey = '1ee98bce2ddfa793c007ac3a'; // Your API key
    final url = 'https://api.currencyconverterapi.com/api/v7/convert?q=MYR_USD&compact=ultra&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        conversionRate = data['MYR_USD'];
      });
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Center(
        child: conversionRate == null
            ? CircularProgressIndicator()
            : Text('1 MYR = \$${conversionRate!.toString()}'),
      ),
    );
  }
}
