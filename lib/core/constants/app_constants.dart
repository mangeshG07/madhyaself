import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants
///
/// Configuration is loaded from .env files and --dart-define parameters.
class AppConstants {
  AppConstants._();

  /// App name
  static const String appName = 'Madhyasthi';

  /// Environment (dev, staging, prod)
  ///
  /// Loaded from --dart-define=ENVIRONMENT= <env>
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  /// Is production environment
  static bool get isProduction => environment == 'prod';

  /// Is staging environment
  static bool get isStaging => environment == 'staging';

  /// Is development environment
  static bool get isDevelopment => environment == 'dev';

  // ========== Feature Flags ==========

  /// Enable logging
  static bool get enableLogging {
    return _getBoolEnv('ENABLE_LOGGING', defaultValue: isDevelopment);
  }

  /// Enable analytics
  static bool get enableAnalytics {
    return _getBoolEnv('ENABLE_ANALYTICS', defaultValue: isProduction);
  }

  /// Enable crash reporting
  static bool get enableCrashReporting {
    return _getBoolEnv('ENABLE_CRASH_REPORTING', defaultValue: isProduction);
  }

  /// Debug mode
  static bool get debugMode {
    return _getBoolEnv('DEBUG_MODE', defaultValue: isDevelopment);
  }

  /// Verbose logging
  static bool get verboseLogging {
    return _getBoolEnv('VERBOSE_LOGGING', defaultValue: isDevelopment);
  }

  // ========== App Configuration ==========

  /// App version from .env
  static String get appVersion {
    return dotenv.env['APP_VERSION'] ?? '1.0.0';
  }

  /// Minimum app version
  static String get minAppVersion {
    return dotenv.env['MIN_APP_VERSION'] ?? '1.0.0';
  }

  /// Database name
  static String get databaseName {
    return dotenv.env['DATABASE_NAME'] ?? 'app_database';
  }

  // ========== API Keys ==========

  /// Google API Key (from .env)
  static String get googleApiKey {
    return dotenv.env['GOOGLE_API_KEY'] ?? '';
  }

  /// Firebase API Key (from .env)
  static String get firebaseApiKey {
    return dotenv.env['FIREBASE_API_KEY'] ?? '';
  }

  static String get chatApiKey {
    return dotenv.env['CHAT_API_KEY'] ?? '';
  }

  // ========== Cache Keys ==========

  /// Theme mode cache key
  static const String themeModeKey = 'theme_mode';

  /// Language cache key
  static const String languageKey = 'language';

  /// User token cache key
  static const String userTokenKey = 'user_token';

  /// User data cache key
  static const String userDataKey = 'user_data';

  // ========== Private Helpers ==========

  /// Parse boolean from environment variable
  static bool _getBoolEnv(String key, {required bool defaultValue}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }
}
