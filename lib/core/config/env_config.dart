import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madhya/core/constants/app_constants.dart';
import '../utils/logger.dart';

class EnvConfig {
  static Future<void> load() async {
    final environment = AppConstants.environment;
    final envFile = 'env/.env.$environment';

    try {
      await dotenv.load(fileName: envFile);
      // AppLogger.info('Environment loaded', 'Using $envFile');
    } catch (e) {
      // AppLogger.error(
      //   'Failed to load environment',
      //   'Could not load $envFile: $e',
      // );

      if (environment != 'dev') {
        try {
          await dotenv.load(fileName: 'env/.env.dev');
          // AppLogger.warning(
          //   'Fallback to dev environment',
          //   'Using env/.env.dev',
          // );
        } catch (fallbackError) {
          // AppLogger.error(
          //   'Fallback failed',
          //   'Could not load env/.env.dev: $fallbackError',
          // );
        }
      }
    }
  }

  // ✅ Access values safely
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
