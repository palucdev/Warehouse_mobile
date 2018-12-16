import 'package:warehouse_mobile/model/intent.dart';
import 'package:warehouse_mobile/model/sync_err_msg.dart';

class Product {
  String id;
  String manufacturerName;
  String modelName;
  num price;
  String currency;
  int quantity;
  int localQuantity = 0;
  Intent intent = Intent.UPDATE;
  String modifiedAt = DateTime.now().toIso8601String();
  SyncErrorMessage syncProblem = SyncErrorMessage.empty();

  static const String ID_KEY = '_id';
  static const String MANUFACTURER_NAME_KEY = 'manufacturerName';
  static const String MODEL_NAME_KEY = 'productModelName';
  static const String PRICE_KEY = 'price';
  static const String CURRENCY_KEY = 'currency';
  static const String QUANTITY_KEY = 'quantity';
  static const String LOCAL_QUANTITY_KEY = 'localQuantity';
  static const String INTENT_KEY = 'intent';
  static const String MODIFICATION_DATE_KEY = 'modifiedAt';
  static const String SYNC_PROBLEM_KEY = 'syncProblem';

  Product(
      {this.id,
      this.manufacturerName,
      this.modelName,
      this.price,
      this.currency,
      this.quantity,
      this.localQuantity,
      this.intent,
      this.modifiedAt,
      this.syncProblem});

  static List<String> getParamKeys() {
    return [
      ID_KEY,
      MANUFACTURER_NAME_KEY,
      MODEL_NAME_KEY,
      PRICE_KEY,
      CURRENCY_KEY,
      QUANTITY_KEY,
      LOCAL_QUANTITY_KEY,
      INTENT_KEY,
      MODIFICATION_DATE_KEY,
      SYNC_PROBLEM_KEY
    ];
  }

  static String getTableCreateQuery() {
    return 'CREATE TABLE Product ($ID_KEY TEXT PRIMARY KEY,'
        ' $MANUFACTURER_NAME_KEY TEXT,'
        ' $MODEL_NAME_KEY TEXT,'
        ' $PRICE_KEY REAL,'
        ' $CURRENCY_KEY TEXT,'
        ' $QUANTITY_KEY INTEGER,'
        ' $LOCAL_QUANTITY_KEY INTEGER,'
        ' $INTENT_KEY INTEGER,'
        ' $MODIFICATION_DATE_KEY TEXT,'
        ' $SYNC_PROBLEM_KEY TEXT)';
  }

  Map<String, dynamic> toMap() {
    Map map = {
      ID_KEY: id,
      MANUFACTURER_NAME_KEY: manufacturerName,
      MODEL_NAME_KEY: modelName,
      PRICE_KEY: price,
      CURRENCY_KEY: currency,
      QUANTITY_KEY: quantity,
      LOCAL_QUANTITY_KEY: localQuantity,
      INTENT_KEY: intent.index,
      MODIFICATION_DATE_KEY: modifiedAt,
      SYNC_PROBLEM_KEY: syncProblem.errorDesc
    };

    return map.cast<String, dynamic>();
  }

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey(ID_KEY) &&
        parsedJson.containsKey(MANUFACTURER_NAME_KEY) &&
        parsedJson.containsKey(MODEL_NAME_KEY) &&
        parsedJson.containsKey(PRICE_KEY) &&
        parsedJson.containsKey(CURRENCY_KEY) &&
        parsedJson.containsKey(QUANTITY_KEY) &&
        parsedJson.containsKey(MODIFICATION_DATE_KEY)) {
      int localQuantity = parsedJson.containsKey(LOCAL_QUANTITY_KEY)
          ? parsedJson[LOCAL_QUANTITY_KEY]
          : 0;

      Intent intent = parsedJson.containsKey(INTENT_KEY)
          ? Intent.values[parsedJson[INTENT_KEY]]
          : Intent.UPDATE;

      String id = parsedJson[ID_KEY];

      SyncErrorMessage syncError = parsedJson.containsKey(SYNC_PROBLEM_KEY) &&
              parsedJson[SYNC_PROBLEM_KEY] != ''
          ? SyncErrorMessage(true, parsedJson[SYNC_PROBLEM_KEY], id)
          : SyncErrorMessage.empty();

      return Product(
          id: id,
          manufacturerName: parsedJson[MANUFACTURER_NAME_KEY],
          modelName: parsedJson[MODEL_NAME_KEY],
          price: parsedJson[PRICE_KEY],
          currency: parsedJson[CURRENCY_KEY],
          quantity: parsedJson[QUANTITY_KEY],
          localQuantity: localQuantity,
          intent: intent,
          modifiedAt: parsedJson[MODIFICATION_DATE_KEY],
          syncProblem: syncError);
    } else {
      throw new Exception('Malformed product json');
    }
  }
}
