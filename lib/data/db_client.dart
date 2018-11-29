import 'dart:async';

import 'package:path/path.dart';
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
	String productTableCreateQuery =
		'CREATE TABLE Product (id INTEGER PRIMARY KEY,'
		' manufacturerName TEXT,'
		' modelName TEXT,'
		' price REAL,'
		' currency TEXT,'
		' quantity INTEGER)';
	String productsGetQuery = 'SELECT * FROM Product';

	Future<bool> initDb() async {
		String databasesPath = await getDatabasesPath();
		String dbPath = join(databasesPath, dbName);

		_db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);

		return _db.isOpen;
	}

	void _onCreate(Database db, int newVersion) async {
		await db.execute(productTableCreateQuery);
	}

	//TODO: Add error handling to db operations
	Future<List<Product>> getProducts() async {
		var rawProducts = await _db.rawQuery(productsGetQuery);

		List<Product> products = [];
		rawProducts.forEach((product) {
			products.add(Product.fromJson(product));
		});

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
	}

	Future<Product> insertProduct(Product product) async {
		await _db.insert("Product", product.toMap());

		return product;
	}

	Future<Product> updateProduct(Product product) async {
		await _db.update("Product", product.toMap(), where: 'id = ?', whereArgs: [product.id]);

		return product;
	}

	Future<Product> removeProduct(Product product) async {
		await _db.delete("Product", where: 'id = ?', whereArgs: [product.id]);

		return product;
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