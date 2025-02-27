class CurrencyModel {
  final String baseCurrency;
  final String targetCurrency;
  final double exchangeRate;

  CurrencyModel({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.exchangeRate,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json, String base, String target) {
    var rateData = json["data"]?[target];
    double rate = rateData != null && rateData["value"] != null ? rateData["value"] : 0.0;
    return CurrencyModel(baseCurrency: base, targetCurrency: target, exchangeRate: rate);
  }
}
