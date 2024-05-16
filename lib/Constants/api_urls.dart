class ApiUrls {
  static const String baseUrl = 'https://mindwaveinfoway.com/';
  static const String _apiPath = 'FTCStocks/AdminPanel/WebApi/index.php?p=';

  static const String loginApi = '${_apiPath}Login';
  static const String getStockApi = '${_apiPath}getModel';
  static const String addStockApi = '${_apiPath}setModel';
  static const String deleteStockApi = '${_apiPath}deleteModel';
  static const String getOrdersApi = '${_apiPath}getOrder';
  static const String createOrderApi = '${_apiPath}createOrder';
  static const String completeOrderApi = '${_apiPath}completeOrder';
  static const String cancelOrderApi = '${_apiPath}cancelOrder';
  static const String availableStockApi = '${_apiPath}availableStock';
  static const String inAppUpdateApi = '${_apiPath}inAppUpdate';
  static const String getPartiesApi = '${_apiPath}getParties';
  static const String requiredStockApi = '${_apiPath}requiredStock';
  static const String getCompletedOrderApi = '${_apiPath}getCompletedOrder';
}
