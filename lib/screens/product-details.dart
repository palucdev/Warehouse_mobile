import 'package:werehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';

class ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product details'),
      ),
      body: ListView(
        children: [
          _buildProductDetails()
        ]
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.product.modelName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.product.manufacturerName,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    widget.product.price.toString() + widget.product.currency,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.shopping_cart,
              color: Colors.red[500],
            ),
            Text(widget.product.quantity.toString()),
          ],
        ));
  }
}

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  ProductDetailsState createState() => new ProductDetailsState();
}
