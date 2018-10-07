import 'package:flutter/material.dart';
import 'package:werehouse_mobile/screens/product-list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: ProductList()
    );
  }
}