/// NOTES : Refer utils class and extension functions for common resource uses

class Logger {
  static var tag = '';
  static var cloud = '☁️';
  static var success = '✅';
  static var info = '💡️';
  static var warning = '🃏️  ';
  static var error = '💔️  ';

  static var logIcon = '✏️';

  static void printLog({var tag = 'PayrollEzy', var printLog = '', var logIcon = 'ℹ️'}) {
    if (true) {
      Logger.logIcon = logIcon;
      Logger.tag = tag;
      print('|---------->${Logger.logIcon} ${tag.contains('JSON METHOD') ? 'Request Data Start' : 'Response Data Start'} ${Logger.logIcon}<----------|');
      print(tag + '\t : ' + printLog.toString());
      print('|------------------------------>${Logger.logIcon} ${tag.contains('JSON METHOD') ? 'Request Data End' : 'Response Data End'} ${Logger.logIcon}<------------------------------|');
    }
  }
}
