import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/login.dart';
import 'package:warehouse_mobile/screens/product-list.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new ProductList(),
  '/': (BuildContext context) => new LoginScreen()
};