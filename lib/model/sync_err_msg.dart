class SyncErrorMessage {
  final bool hasProblem;
  final String errorDesc;
  final String productId;

  static const String PRODUCT_ID_KEY = 'productId';
  static const String ERROR_DESC_KEY = 'message';

  SyncErrorMessage(this.hasProblem, this.errorDesc, this.productId);

  SyncErrorMessage.empty()
      : this.hasProblem = false,
        this.errorDesc = '',
        this.productId = '';

  factory SyncErrorMessage.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey(PRODUCT_ID_KEY) &&
        parsedJson.containsKey(ERROR_DESC_KEY)) {
      return new SyncErrorMessage(
          true, parsedJson[ERROR_DESC_KEY], parsedJson[PRODUCT_ID_KEY]);
    } else {
      throw parsedJson;
    }
  }
}
