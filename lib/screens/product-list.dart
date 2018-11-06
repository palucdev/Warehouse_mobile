import 'dart:async';

import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/product-details.dart';
import 'package:warehouse_mobile/services/navigation_service.dart';

class ProductListState extends State<ProductList> {
  List<Product> _products = <Product>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  RestDatasource api = new RestDatasource();

  Future<List<Product>> _getProducts() async {
    return this._products = await api.getProducts();
  }

  Future<void> _refreshProducts() async {
    await _getProducts();
  }

  void _productDetails(Product product) {
    new NavigationService().materialNavigateTo(
        new MaterialPageRoute(
            builder: (context) => ProductDetails(product: product)),
        context);
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getProducts(),
      initialData: "Loading data...",
      builder: (BuildContext context, AsyncSnapshot<dynamic> products) {
        if (products.hasData) {
          return _buildProducts();
        } else {
          return new CircularProgressIndicator();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
          title: Text('Tracked products'),
          leading: IconButton(
              icon: const Icon(Icons.refresh), onPressed: _refreshProducts)),
      body: futureBuilder,
    );
  }

  Widget _buildProducts() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2; // i by 2 with int result

          if (index >= _products.length) {
            return null;
          }

          return _buildRow(_products[index]);
        });
  }

  Widget _buildRow(Product product) {
    return ListTile(
        title: Text(
          product.modelName,
          style: _biggerFont,
        ),
        subtitle: Text(product.manufacturerName),
        trailing: new Icon(Icons.arrow_forward),
        onTap: () {
          _productDetails(product);
        });
  }
}

class ProductList extends StatefulWidget {
  @override
  ProductListState createState() => new ProductListState();
}
