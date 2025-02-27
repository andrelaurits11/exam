import 'package:dio/dio.dart';
import 'package:exam/models/currency_model.dart';

class CurrencyConverterController {
  static const String apiKey = "cur_live_tESdvdRoDOIdPAUBv1O51bdfCUp3sUXkxytOk467";
  static const String baseUrl = "https://api.currencyapi.com/v3/latest";

  Future<CurrencyModel> fetchExchangeRate(String base, String target) async {
    final dio = Dio();
    final url = "$baseUrl?apikey=$apiKey&base_currency=$base&currencies=$target";

    try {
      final response = await dio.get(url);
      var rateData = response.data?["data"]?[target];

      if (rateData == null || rateData["value"] == null) {
        return CurrencyModel(baseCurrency: base, targetCurrency: target, exchangeRate: 0.0);
      }

      double rate = rateData["value"];
      return CurrencyModel(baseCurrency: base, targetCurrency: target, exchangeRate: rate);
    } catch (e) {
      return CurrencyModel(baseCurrency: base, targetCurrency: target, exchangeRate: 0.0);
    }
  }
}
