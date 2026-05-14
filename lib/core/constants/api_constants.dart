import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API-related constants
///
/// Configuration is loaded from .env files in the `env/` directory.
/// Values can be overridden using --dart-define.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API
  ///
  /// Loaded from .env file (BASE_URL) or --dart-define
  /// Priority: --dart-define > .env file > default value
  static String get baseUrl {
    // Check --dart-define first
    const dartDefine = String.fromEnvironment('BASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;
    // Then check .env file
    return dotenv.env['BASE_URL'] ?? '';
  }

  /// Connection timeout duration in milliseconds
  static Duration get connectionTimeout {
    final timeoutMs = dotenv.env['API_TIMEOUT'];
    if (timeoutMs != null) {
      return Duration(milliseconds: int.tryParse(timeoutMs) ?? 30000);
    }
    return const Duration(seconds: 30);
  }

  /// Receive timeout duration
  static Duration get receiveTimeout => connectionTimeout;

  /// API endpoints
  static const String base = 'https://beta.madhyasthi.com';
  static const String login = '/login';
  static const String verifyOTP = '/verify-otp';
  static const String getCommonData = '/get-common-data';
  static const String getLocationData = '/get-location-data';
  static const String getCasteByReligion = '/get-caste-by-religion';
  static const String getSubCasteByCaste = '/get-sub-caste-by-caste';
  static const String register = '/register';
  static const String home = '/home';
  static const String userProfile = '/get-user-profile';
  static const String updateUserProfile = '/update-profile';
  static const String getOtherProfile = '/profile-details';
  static const String getChatList = '/chat-list';
  static const String createChat = '/create-chat';
  static const String getChatDetails = '/chat-history';
  static const String sendMsg = '/send-message';
  static const String msgDelivered = '/message-delivered';
  static const String msgRead = '/message-read';
  static const String typing = '/typing';
  static const String getView = '/get-view-profile';
  static const String getShortlist = '/get-shortlist';
  static const String shortlistProfile = '/shortlist-profile';
  static const String getInterest = '/get-interest';
  static const String sendInterest = '/send-interest';
  static const String updateInterest = '/update-interest-status';
  static const String deleteInterest = '/delete-interest';
  static const String getMatches = '/get-matches';
  static const String getPartnerPreference = '/get-patner-preferance';
  static const String updatePartnerPreference = '/update-patner-preferance';
  static const String getPages = '/get-page-list';
  static const String getPageDetails = '/get-page-details';
  static const String blockUser = '/block-user';
  static const String reportProfile = '/report-profile';
  static const String blockUserList = '/block-user-list';
  static const String reportProfileList = '/report-profile-list';
  static const String globalSearch = '/search';
  static const String getPlans = '/get-plans';
  static const String getPlanDetails = '/plans-details';
  static const String checkout = '/checkout';
  static const String verifyPayment = '/verify-payment';
  static const String whatsappConnect = '/whatsapp-connnect';
  static const String viewContact = '/view-contact';
  static const String deleteAccount = '/delete-account';
  static const String updateFirebaseToken = '/update-firebase-token';

  /////////////////////Pending////////////////////////

  static const String getNotification = '/get-notification';
  static const String readNotification = '/read-notification';
}
