import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentUtil {
  static const ENV_FILE_NAME = 'packages/warehouse_mobile/.env';

  static String getEnvValueForKey(String key) {
    String value = DotEnv().env[key];
    print('Env value: ' + value.toString());

    return value;
  }

  static Future<void> loadEnvFile() async {
    return await DotEnv().load(ENV_FILE_NAME);
  }
}
