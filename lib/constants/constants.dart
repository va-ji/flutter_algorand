import '../models/models.dart';
import 'application.dart';
import 'connection.dart';

class Constants {
  static ApplicationConstants applicationConstants = ApplicationConstants();
  static ConnectionConstants connectionConstants = ConnectionConstants();
  static const bool devBuild = true;
  static const bool debugBanner = false;
  static const bool bypassBackend = true;
  static const String devAccessToken = '';
  static const apiKey = 'pn6FETz0C38epEEifmWBz7kFgaxdaToZ1P12OHgX';
  static final LoginAPIBody devUser = LoginAPIBody(
    username: 'user@launchpad.com',
    password: 'password',
  );
}
