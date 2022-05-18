import '../models/models.dart';
import 'application.dart';
import 'connection.dart';

class Constants {
  static ApplicationConstants applicationConstants = ApplicationConstants();
  static ConnectionConstants connectionConstants = ConnectionConstants();
  static const bool devBuild = true;
  static const bool debugBanner = false;
  static const bool bypassBackend = false;
  static const String devAccessToken = '';
  static const String OTP_GIF_IMAGE = "lib/assets/logo/otp.gif";
  static const apiKey = 'pn6FETz0C38epEEifmWBz7kFgaxdaToZ1P12OHgX';
  static const String escrowadd =
      'DOM264YWYWQ5HO7PZPCDRTOPIK3AV4JZKTAHNNJBWQFOG4X67ICIFGGD7A';
  final charCreatorSeed = [
    'alpha',
    'flip',
    'deny',
    'phone',
    'joke',
    'comic',
    'world',
    'shine',
    'fun',
    'exhibit',
    'genre',
    'mention',
    'check',
    'motion',
    'apology',
    'nurse',
    'vital',
    'drift',
    'stable',
    'devote',
    'sad',
    'wedding',
    'neglect',
    'abandon',
    'scheme'
  ];
  final serviceCompletorSeed = [
    'undo',
    'panel',
    'design',
    'trigger',
    'hurdle',
    'vehicle',
    'service',
    'pioneer',
    'bracket',
    'enemy',
    'blossom',
    'hat',
    'never',
    'work',
    'cattle',
    'gift',
    'moral',
    'evidence',
    'pledge',
    'same',
    'scatter',
    'glow',
    'slow',
    'absent',
    'essence'
  ];
  final LoginAPIBody devUser = LoginAPIBody(
    username: 'user@launchpad.com',
    password: 'password',
  );
}
