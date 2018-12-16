import 'dart:async';

import 'package:warehouse_mobile/data/db_client.dart';
import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/intent.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mobile/model/sync_err_msg.dart';
import 'package:warehouse_mobile/services/navigation_service.dart';

class ProductDetailsState extends State<ProductDetails> {
  Product _product;

  final textEditingController = TextEditingController();

  RestDatasource api = new RestDatasource();
  DatabaseClient dbClient = new DatabaseClient();

  BuildContext _ctx;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductDetails oldWidget) {
    print('didUpdateWidget');
    if (oldWidget.product != widget.product) {
      _product = widget.product;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    this._product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product details'),
        ),
        body: Builder(builder: (BuildContext context) {
          this._ctx = context;
          return ListView(
              children: [
            _buildProductDetails(),
            _buildButtonSelectionBar(),
            _buildRemoveButton(),
            _buildSyncProblemBar()
          ].where((Object o) => o != null).toList());
        }));
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
                      this._product.modelName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    this._product.manufacturerName,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    this._product.price.toString() + this._product.currency,
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
            Text((this._product.quantity + this._product.localQuantity)
                .toString()),
          ],
        ));
  }

  Widget _buildButtonSelectionBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            child: buildButtonColumn(Icons.add_circle, 'Add products'),
            onPressed: _addProductsToWarehouse,
          ),
          MaterialButton(
            child: buildButtonColumn(Icons.remove_circle, 'Remove products'),
            onPressed: _removeProductsToWarehouse,
          ),
          MaterialButton(
            child: buildButtonColumn(Icons.refresh, 'Sync'),
            onPressed: _syncProduct,
          )
        ],
      ),
    );
  }

  Column buildButtonColumn(IconData icon, String label, [buttonFn]) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    var db = new DatabaseClient();
    if (db.user.role == 0) {
      return RaisedButton(
        child: new Text(
          'Remove product',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: _removeProduct,
        color: Colors.primaries[0],
      );
    }

    return null;
  }

  Widget _buildSyncProblemBar() {
    if (this._product.syncProblem.hasProblem) {
      return Container(
        child: Column(
          children: [
            RaisedButton(
              child: new Text(
                'Insert product to db',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: _markProductToInsert,
              color: Colors.green,
            ),
            Text('Sync conflict: ' + this._product.syncProblem.errorDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22.0, color: Colors.red))
          ],
        ),
      );
    } else {
      return Text('Product is ready to sync!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22.0, color: Colors.green));
    }
  }

  void _markProductToInsert() async {
    try {
      setState(() {
        this._product.intent = Intent.INSERT;
        this._product.syncProblem = SyncErrorMessage.empty();
      });
			await this.dbClient.updateProduct(this._product);

		} catch (e) {
      print(e.toString());
    }
  }

  void _syncProduct() async {
    try {
      print('Sync product with intent: ' + this._product.intent.toString());
      if (this._product.intent == Intent.INSERT) {
        this.api.addProduct(this._product).then((Product serverProduct) {
          this.dbClient.removeProduct(this._product).then((Product removed) {
            setState(() {
              serverProduct.localQuantity = this._product.localQuantity;

              this._product = serverProduct;
              this.dbClient.insertProduct(serverProduct);

              Scaffold.of(_ctx)
                  .showSnackBar(new SnackBar(content: Text('Product added!')));
            });
          });
        }).catchError((dynamic error) {
          Scaffold.of(_ctx).showSnackBar(new SnackBar(
              content: Text('Product not added...' + error.toString())));
        });
      } else {
        int serverQuantity = await this.api.changeProductItems(this._product);

        setState(() {
          this._product.quantity = serverQuantity - this._product.localQuantity;
          this._product.intent = Intent.UPDATE;
          this.dbClient.updateProduct(this._product);
        });

        Scaffold.of(_ctx).showSnackBar(
            new SnackBar(content: Text('Successfully synced product!')));
      }
    } catch (e) {
      var snackbarMessage = 'Sync error: ';
      if (e is SyncErrorMessage) {
        snackbarMessage += e.errorDesc;
        snackbarMessage += " Please resolve problems";

        setState(() {
          this._product.syncProblem = e;
          this.dbClient.updateProduct(this._product);
        });
      } else {
        snackbarMessage += e.toString();
      }

      Scaffold.of(_ctx)
          .showSnackBar(new SnackBar(content: Text(snackbarMessage)));
    }
  }

  void _removeProduct() async {
    this._product.intent = Intent.REMOVE;
    this._product.modifiedAt = DateTime.now().toIso8601String();

    await this.dbClient.updateProduct(this._product);

    new NavigationService().navigateTo(NavigationRoutes.PRODUCTS, this._ctx);
  }

  void _addProductsToWarehouse() async {
    int quantity = await _showInputDialog();

    if (quantity != null) {
      _changeProductsQuantity(quantity);
    }
  }

  void _removeProductsToWarehouse() async {
    int quantity = await _showInputDialog();

    if (quantity != null) {
      _changeProductsQuantity(-quantity);
    }
  }

  void _changeProductsQuantity(int quantity) async {
    if (quantity != null) {
      this._product.localQuantity += quantity;
      this._product.modifiedAt = DateTime.now().toIso8601String();

      try {
        await this.dbClient.updateProduct(this._product);
        Scaffold.of(_ctx).showSnackBar(
            new SnackBar(content: Text('Successfully added products!')));
      } catch (e) {
        Scaffold.of(_ctx).showSnackBar(new SnackBar(
            content: Text('Products not added, error: ' + e.toString())));
      }
    }
  }

  Future<int> _showInputDialog() async {
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              contentPadding: const EdgeInsets.all(20.0),
              content: new Row(children: <Widget>[
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Quantity', hintText: '2137'),
                  keyboardType: TextInputType.number,
                  controller: textEditingController,
                ))
              ]),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: const Text('Cancel')),
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(
                          context, int.parse(textEditingController.text));
                    },
                    child: const Text('Send'))
              ]);
        });
  }
}

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  ProductDetailsState createState() => new ProductDetailsState();
}
