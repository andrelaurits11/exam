import 'package:dio/dio.dart';
import '../models/currency_model.dart';

class CurrencyConverterController {
  static const String apiKey = "cur_live_tESdvdRoDOIdPAUBv1O51bdfCUp3sUXkxytOk467";
  static const String baseUrl = "https://api.currencyapi.com/v3/latest";

  final List<String> currencies = ["USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "CNY"];

  final Map<String, String> currencyToFlagMap = {
    "USD": "https://flagcdn.com/w40/us.png",
    "EUR": "https://flagcdn.com/w40/eu.png",
    "GBP": "https://flagcdn.com/w40/gb.png",
    "JPY": "https://flagcdn.com/w40/jp.png",
    "AUD": "https://flagcdn.com/w40/au.png",
    "CAD": "https://flagcdn.com/w40/ca.png",
    "CHF": "https://flagcdn.com/w40/ch.png",
    "CNY": "https://flagcdn.com/w40/cn.png",
  };

  Future<CurrencyModel?> fetchExchangeRate(String base, String target) async {
    final dio = Dio();
    final url = "$baseUrl?apikey=$apiKey&base_currency=$base&currencies=$target";

    try {
      final response = await dio.get(url);
      var rateData = response.data?["data"]?[target];

      if (rateData == null || rateData["value"] == null) {
        return null;
      }

      double rate = rateData["value"];
      return CurrencyModel(baseCurrency: base, targetCurrency: target, exchangeRate: rate);
    } catch (e) {
      return null;
    }
  }
}
