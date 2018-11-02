// Now just a decoy for a real db helper
// storing things in memory, in project phase II move it to mobile db
import 'package:warehouse_mobile/model/user.dart';

class DatabaseHelper {
	static final DatabaseHelper _instance = new DatabaseHelper.internal();
	factory DatabaseHelper() => _instance;

	DatabaseHelper.internal();

	User user = null;

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