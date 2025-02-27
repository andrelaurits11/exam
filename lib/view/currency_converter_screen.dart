import 'package:flutter/material.dart';
import '../controllers/currency_converter_controller.dart';
import '../models/currency_model.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final CurrencyConverterController controller = CurrencyConverterController();
  String baseCurrency = "USD";
  String targetCurrency = "EUR";
  CurrencyModel? exchangeRate;
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
      exchangeRate = await controller.fetchExchangeRate(baseCurrency, targetCurrency);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch exchange rate. Try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1E1E1E),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Currency Converter"),
          backgroundColor: Colors.black,
          actions: [IconButton(icon: Icon(Icons.refresh), onPressed: fetchExchangeRate)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Color(0xFF1E1E1E),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
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
                          Text("→", style: TextStyle(fontSize: 24, color: Colors.white70)),
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
                        "Exchange Rate: ${exchangeRate?.exchangeRate.toStringAsFixed(4) ?? 'N/A'}",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                onPressed: fetchExchangeRate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Update Rate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currencyDropdown(String selectedCurrency, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      dropdownColor: Color(0xFF2C2C2C),
      value: selectedCurrency,
      style: TextStyle(color: Colors.white, fontSize: 16),
      iconEnabledColor: Colors.white70,
      items: currencies.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Row(
            children: [
              Image.network(
                getFlagUrl(getCountryCode(currency)),
                width: 24,
                height: 16,
                errorBuilder: (_, __, ___) => Icon(Icons.flag, size: 24, color: Colors.white70),
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
    return "https://flagcdn.com/w40/${countryCode.toLowerCase()}.png";
  }

  String getCountryCode(String currency) {
    switch (currency) {
      case "USD": return "us";
      case "EUR": return "eu";
      case "GBP": return "gb";
      case "JPY": return "jp";
      case "AUD": return "au";
      case "CAD": return "ca";
      case "CHF": return "ch";
      case "CNY": return "cn";
      default: return "us";
    }
  }
}
