import 'package:flutter/material.dart';
import '../controllers/currency_converter_controller.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final CurrencyConverterController controller = CurrencyConverterController();
  String baseCurrency = "USD";
  String targetCurrency = "EUR";
  double exchangeRate = 0.0;
  bool isLoading = false;

  final List<String> currencies = ["USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "CNY"];

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  Future<void> fetchExchangeRate() async {
    setState(() => isLoading = true);
    try {
      double newRate = await controller.fetchExchangeRate(baseCurrency, targetCurrency);
      setState(() {
        exchangeRate = newRate;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch exchange rate. Try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchExchangeRate,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                currencyDropdown(baseCurrency, (value) {
                  setState(() {
                    baseCurrency = value!;
                    fetchExchangeRate();
                  });
                }),
                Text("→"),
                currencyDropdown(targetCurrency, (value) {
                  setState(() {
                    targetCurrency = value!;
                    fetchExchangeRate();
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Exchange Rate: ${exchangeRate.toStringAsFixed(4)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: fetchExchangeRate,
              child: Text("Update Rate"),
            ),
          ],
        ),
      ),
    );
  }

  Widget currencyDropdown(String selectedCurrency, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencies.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Row(
            children: [
              Image.network(
                getFlagUrl(getCountryCode(currency)),
                width: 24,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.flag, size: 24);
                },
              ),
              SizedBox(width: 8),
              Text(currency),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  String getFlagUrl(String countryCode) {
    return 'https://flagcdn.com/w40/${countryCode.toLowerCase()}.png';
  }

  String getCountryCode(String currency) {
    switch (currency) {
      case "USD":
        return "us";
      case "EUR":
        return "eu";
      case "GBP":
        return "gb";
      case "JPY":
        return "jp";
      case "AUD":
        return "au";
      case "CAD":
        return "ca";
      case "CHF":
        return "ch";
      case "CNY":
        return "cn";
      default:
        return "us";
    }
  }
}
