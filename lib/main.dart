import 'package:flutter/material.dart';
import 'package:santarita/pages/Principal.dart';
import 'pages/prProducts.dart';

void main() {
  runApp(
    HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SANTA RITA',
        debugShowCheckedModeBanner: false,
        home: Principal(),
      routes: <String, WidgetBuilder> {
        '/products' : (BuildContext context) => new prProducts(),
      },
    );
  }
}