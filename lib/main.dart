import 'package:flutter/material.dart';
import 'package:payment_through_paytm/Customs/abstract.dart';
import 'package:payment_through_paytm/Presentation/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paytm Gateway',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

