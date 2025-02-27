import 'package:flutter/material.dart';
import 'view/currency_converter_screen.dart';

void main() {
  runApp(CurrencyApp());
}



  class CurrencyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterScreen(),
    );
  }
}