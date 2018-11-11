import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/login.dart';
import 'package:warehouse_mobile/screens/product-list.dart';
import 'package:warehouse_mobile/screens/product-new.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/products': (BuildContext context) => new ProductList(),
  '/new_product': (BuildContext context) => new NewProduct(),
  '/': (BuildContext context) => new LoginScreen()
};