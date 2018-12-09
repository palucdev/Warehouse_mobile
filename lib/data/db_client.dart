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
		var rawProducts = await _db.query('Product',
		columns: Product.getParamKeys());

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

		return products;
	}

	Future<Product> insertProduct(Product product) async {
		await _db.insert("Product", product.toMap());

		return product;
	}

	Future<Product> updateProduct(Product product) async {
		var productIdColumn = Product.ID_KEY;
		await _db.update("Product", product.toMap(), where: '$productIdColumn = ?', whereArgs: [product.id]);

		return product;
	}

	Future<Product> removeProduct(Product product) async {
		var productIdColumn = Product.ID_KEY;
		await _db.delete("Product", where: '$productIdColumn = ?', whereArgs: [product.id]);

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