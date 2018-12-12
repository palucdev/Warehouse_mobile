import 'package:warehouse_mobile/model/intent.dart';

class Product {
  String id;
  String manufacturerName;
  String modelName;
  num price;
  String currency;
  int quantity;
  int localQuantity = 0;
  Intent intent = Intent.UPDATE;

  static const String ID_KEY = '_id';
  static const String MANUFACTURER_NAME_KEY = 'manufacturerName';
  static const String MODEL_NAME_KEY = 'productModelName';
  static const String PRICE_KEY = 'price';
  static const String CURRENCY_KEY = 'currency';
  static const String QUANTITY_KEY = 'quantity';
  static const String LOCAL_QUANTITY_KEY = 'localQuantity';
  static const String INTENT_KEY = 'intent';

  Product(
      {this.id,
      this.manufacturerName,
      this.modelName,
      this.price,
      this.currency,
      this.quantity,
      this.localQuantity,
      this.intent});

  static List<String> getParamKeys() {
    return [
      ID_KEY,
      MANUFACTURER_NAME_KEY,
      MODEL_NAME_KEY,
      PRICE_KEY,
      CURRENCY_KEY,
      QUANTITY_KEY,
      LOCAL_QUANTITY_KEY,
      INTENT_KEY
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
        ' $INTENT_KEY INTEGER)';
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
      INTENT_KEY: intent.index
    };

    return map.cast<String, dynamic>();
  }

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey(ID_KEY) &&
        parsedJson.containsKey(MANUFACTURER_NAME_KEY) &&
        parsedJson.containsKey(MODEL_NAME_KEY) &&
        parsedJson.containsKey(PRICE_KEY) &&
        parsedJson.containsKey(CURRENCY_KEY) &&
        parsedJson.containsKey(QUANTITY_KEY)) {
      int localQuantity = parsedJson.containsKey(LOCAL_QUANTITY_KEY)
          ? parsedJson[LOCAL_QUANTITY_KEY]
          : 0;

      Intent intent = parsedJson.containsKey(INTENT_KEY)
          ? Intent.values[parsedJson[INTENT_KEY]]
          : Intent.UPDATE;

      return Product(
          id: parsedJson[ID_KEY],
          manufacturerName: parsedJson[MANUFACTURER_NAME_KEY],
          modelName: parsedJson[MODEL_NAME_KEY],
          price: parsedJson[PRICE_KEY],
          currency: parsedJson[CURRENCY_KEY],
          quantity: parsedJson[QUANTITY_KEY],
          localQuantity: localQuantity,
          intent: intent);
    } else {
      throw new Exception('Malformed product json');
    }
  }
}
