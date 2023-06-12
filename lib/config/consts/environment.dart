import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String androidApiKey = dotenv.env['ANDROID_API_KEY']!;
  static String iosApiKey = dotenv.env['IOS_API_KEY']!;
}
