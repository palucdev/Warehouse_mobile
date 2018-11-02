import 'package:flutter/material.dart';
import 'package:warehouse_mobile/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      routes: routes,
    );
  }
}