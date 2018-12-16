import 'dart:async';

import 'package:warehouse_mobile/data/db_client.dart';
import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/intent.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/product-details.dart';
import 'package:warehouse_mobile/screens/product-new.dart';
import 'package:warehouse_mobile/services/navigation_service.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class ProductListState extends State<ProductList> {
  List<Product> _products = <Product>[];

  final _biggerFontNormal = const TextStyle(fontSize: 18.0, color: Colors.black);
  final _biggerFontProblem = const TextStyle(fontSize: 18.0, color: Colors.red);

  RestDatasource api = new RestDatasource();
  DatabaseClient dbClient = new DatabaseClient();

  BuildContext _ctx;

  Future<List<Product>> _getProducts() async {
    return SharedPreferencesUtil.getInitFlag().then((bool initialized) async {
      if (initialized) {
        // App initialized previously, get data from DB
        print('app initialized previously');
        this._products = await dbClient.getProducts();
        print('products downloaded from mobile db');
      } else {
        // First app init, get data from backend and store in db
        print('first app init');
        this._products = await api.getProducts();
        print('products downloaded from backend');
        await dbClient.insertProducts(this._products);
        print('products inserted into mobile db');

        await SharedPreferencesUtil.setInitFlag();
      }

      return this._products;
    });
  }

  Future<void> _synchronize() async {
		this.api.updateProducts(this._products)
			.then(_refreshProducts)
			.catchError((error) {
				print(error);
		});
		try {

    } catch (error) {
      print('Sync failed: ' + error.toString());
    }
  }

  Future<void> _refreshProducts(List<Product> freshProducts) async {
  	try {
			await dbClient.updateProducts(freshProducts);

			setState(() {
				this._products = freshProducts;
			});
		} catch (error) {
  		print('Products refresh failed' + error.toString());
		}
	}

  void _productDetails(Product product) {
    new NavigationService().materialNavigateTo(
        new MaterialPageRoute(
            builder: (context) => ProductDetails(product: product)),
        context);
  }

  @override
  Widget build(BuildContext context) {
    this._ctx = context;

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
            icon: const Icon(Icons.refresh), onPressed: _synchronize),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.power_settings_new), onPressed: _logout)
        ],
      ),
      body: futureBuilder,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildProducts() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i ~/ 2; // i by 2 with int result

          if (index >= _products.length) {
            return null;
          }

          if (_products[index].intent != Intent.REMOVE) {
            if (i.isOdd) return Divider();

            return _buildRow(_products[index]);
          } else {
          	return null;
					}
        });
  }

  Widget _buildRow(Product product) {
    return ListTile(
        title: Text(
          product.modelName,
          style: product.syncProblem.hasProblem ? _biggerFontProblem : _biggerFontNormal,
        ),
        subtitle: Text(product.manufacturerName),
        trailing: new Icon(Icons.arrow_forward),
        onTap: () {
          _productDetails(product);
        });
  }

  Widget _buildFAB() {
    return new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFF4CAF50),
        onPressed: _newProduct);
  }

  void _newProduct() {
    new NavigationService().materialNavigateTo(
        new MaterialPageRoute(builder: (context) => NewProduct()), context);
  }

  void _logout() {
    var dbClient = new DatabaseClient();
    dbClient.deleteUsers();

    new NavigationService().popToLogin(this._ctx);
  }
}

class ProductList extends StatefulWidget {
  @override
  ProductListState createState() => new ProductListState();
}
