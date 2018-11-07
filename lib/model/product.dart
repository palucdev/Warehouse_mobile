class Product {
  String id;
  String manufacturerName;
  String modelName;
  num price;
  String currency;
  int quantity;

  Product(
      {this.id,
      this.manufacturerName,
      this.modelName,
      this.price,
      this.currency,
      this.quantity});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey('_id') &&
        parsedJson.containsKey('manufacturerName') &&
        parsedJson.containsKey('productModelName') &&
        parsedJson.containsKey('price') &&
        parsedJson.containsKey('currency') &&
        parsedJson.containsKey('quantity')) {
      return Product(
          id: parsedJson['_id'],
          manufacturerName: parsedJson['manufacturerName'],
          modelName: parsedJson['productModelName'],
          price: parsedJson['price'],
          currency: parsedJson['currency'],
          quantity: parsedJson['quantity']);
    } else {
      throw new Exception('Malformed product json');
    }
  }
}
