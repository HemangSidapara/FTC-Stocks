class ApiUrls {
  static String baseUrl = 'https://mindwaveinfoway.com/';
  static String apiPath = 'FTCStocks/AdminPanel/WebApi/index.php?p=';

  static String imageBaseUrl = 'https://mindwaveinfoway.com/FTCStocks/AdminPanel/WebApi/';

  static String mapUrl = 'https://maps.app.goo.gl/N55K2p2Q8TtgRqdE7';

  /// Auth Apis
  static String get loginApi => '${apiPath}Login';

  static String get inAppUpdateApi => '${apiPath}inAppUpdate';

  /// Stock Apis
  static String get getStockApi => '${apiPath}getModel';

  static String get addStockApi => '${apiPath}setModel';

  static String get deleteStockApi => '${apiPath}deleteModel';

  static String get availableStockApi => '${apiPath}availableStock';

  static String get requiredStockApi => '${apiPath}requiredStock';

  /// Party Apis
  static String get getPartiesApi => '${apiPath}getParties';

  /// Order Apis
  static String get getOrdersApi => '${apiPath}getOrder';

  static String get createOrderApi => '${apiPath}createOrder';

  static String get completeOrderApi => '${apiPath}completeOrder';

  static String get cancelOrderApi => '${apiPath}cancelOrder';

  static String get getCompletedOrderApi => '${apiPath}getCompletedOrder';
}
