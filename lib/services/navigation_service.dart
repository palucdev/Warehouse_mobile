import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationRoutes {
	static const String LOGIN = '/login';
	static const String PRODUCTS = '/products';
}

class NavigationService {
	static NavigationService _instance = new NavigationService.internal();

	NavigationService.internal();

	factory NavigationService() => _instance;

	BuildContext currentContext;

	void navigateTo(String route, BuildContext ctx) {
		this.currentContext = ctx;

		Navigator.of(this.currentContext).pushReplacementNamed(route);
	}

	void materialNavigateTo(MaterialPageRoute meterialPageRoute, BuildContext ctx) {
		Navigator.of(ctx).push(meterialPageRoute);
	}

	// TODO: check for something that dont need ctx
	void popToLogin() {
		Navigator.of(this.currentContext).pushReplacementNamed(NavigationRoutes.LOGIN);
	}
}