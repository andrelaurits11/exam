import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static const String apiKey = "cur_live_tESdvdRoDOIdPAUBv1O51bdfCUp3sUXkxytOk467";
  static const String baseUrl = "https://api.currencyapi.com/v3/latest";

  static Future<double> getExchangeRate(String base, String target) async {
    final dio = Dio();
    final url = "$baseUrl?apikey=$apiKey&base_currency=$base&currencies=$target";

    try {
      final response = await dio.get(url);

      if (response.data == null || response.data["data"] == null) {
        return 0.0;
      }

      var rateData = response.data["data"][target];

      if (rateData == null || rateData["value"] == null) {
        return 0.0;
      }

      return rateData["value"];
    } on DioException {
      return 0.0;
    } on SocketException {
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}
