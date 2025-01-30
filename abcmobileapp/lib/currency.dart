import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = '1ee98bce2ddfa793c007ac3a';

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    final url = Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurrency');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double exchangeRate = data['conversion_rates'][toCurrency];
        return exchangeRate;
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }
}