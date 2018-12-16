import 'dart:async';

import 'package:path/path.dart';
import 'package:warehouse_mobile/model/intent.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  static final DatabaseClient _instance = new DatabaseClient.internal();

  factory DatabaseClient() => _instance;

  DatabaseClient.internal();

  User user;

  Database _db;

  String dbName = 'warehouse.db';

  Future<bool> initDb() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, dbName);

    _db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);

    return _db.isOpen;
  }

  void _onCreate(Database db, int newVersion) async {
    print('Creating table Product...');
    await db.execute(Product.getTableCreateQuery());
  }

  //TODO: Add error handling to db operations
  Future<List<Product>> getProducts() async {
    var rawProducts;
    List<Product> products = [];

    try {
      rawProducts = await _db.query('Product', columns: Product.getParamKeys());
      rawProducts.forEach((product) {
        products.add(Product.fromJson(product));
      });
    } catch (e) {
      print('getProducts error: ' + e.toString());
    }

    return products;
  }

  Future<List<Product>> insertProducts(List<Product> products) async {
    await _db.transaction((transaction) {
      Batch batch = transaction.batch();

      products.forEach((product) {
        batch.insert("Product", product.toMap());
      });

      batch.commit();
    });

    return products;
  }

  Future<List<Product>> updateProducts(List<Product> products) async {
    var productIdColumn = Product.ID_KEY;
    List<Product> currentProducts = await getProducts();
    print('Current products: ' + currentProducts.toString());

    await removeMarkedProducts();

    await _db.transaction((transaction) {
      Batch batch = transaction.batch();

      products.forEach((Product product) {
        print('updating product: ' + product.modelName.toString());
        var existing = currentProducts.firstWhere((found) =>
          found.modelName == product.modelName
          && found.manufacturerName == product.manufacturerName
          && found.price == product.price
          && found.currency == product.currency
        , orElse:() {});
        if (existing != null){
          product.localQuantity = existing.localQuantity;
          batch.update("Product", product.toMap(),
            where: '$productIdColumn = ?', whereArgs: [product.id]);
        } else {
          batch.insert("Product", product.toMap());
        }
      });

      batch.commit();
    });

    return products;
  }

  Future<Product> insertProduct(Product product) async {
    await _db.insert("Product", product.toMap());

    return product;
  }

  Future<Product> updateProduct(Product product) async {
    var productIdColumn = Product.ID_KEY;
    await _db.update("Product", product.toMap(),
        where: '$productIdColumn = ?', whereArgs: [product.id]);

    return product;
  }

  Future<Product> removeProduct(Product product) async {
    var productIdColumn = Product.ID_KEY;
    await _db.delete("Product",
        where: '$productIdColumn = ?', whereArgs: [product.id]);

    return product;
  }

  Future<void> removeMarkedProducts() async {
    var intentColumn = Product.INTENT_KEY;
    await _db.delete("Product",
        where: '$intentColumn = ?', whereArgs: [Intent.REMOVE.index]);
  }

  void saveUser(User user) {
    this.user = user;
  }

  void deleteUsers() {
    this.user = null;
  }

  bool isLoggedIn() {
    return this.user != null;
  }
}
