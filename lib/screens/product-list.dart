import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/product-details.dart';

class ProductListState extends State<ProductList> {
  List<Product> _products = <Product>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _initMockProducts() {
    this._products = [
      new Product('Samsung', 'S24F356FHUX', 499.99, 'PLN', 10),
      new Product('LG', '24MP59G', 599.00, 'PLN', 21),
      new Product('Dell', 'P2417H', 699.99, 'PLN', 3),
      new Product('Acer', 'Nitro VG230YBMIIX', 569.99, 'PLN', 1),
      new Product('AOC', 'C24G1', 849.50, 'PLN', 0),
      new Product('Iiyama', 'G-Master G2530HSU', 639.00, 'PLN', 20),
      new Product('BenQ', 'GW2280E', 379.99, 'PLN', 3),
      new Product('Philips', '223V5LSB2/10', 329.00, 'PLN', 7)
    ];
  }

  void _productDetails(Product product) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => ProductDetails(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracked products'),
      ),
      body: _buildProducts(),
    );
  }

  Widget _buildProducts() {
    _initMockProducts();
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
