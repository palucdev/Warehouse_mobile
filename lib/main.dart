import 'dart:async';

import 'package:flutter/material.dart';
import 'package:warehouse_mobile/routes.dart';
import 'package:warehouse_mobile/utils/env_util.dart';

Future main() async {
	await EnvironmentUtil.loadEnvFile();
	print('Env file loaded');
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      routes: routes,
    );
  }
}