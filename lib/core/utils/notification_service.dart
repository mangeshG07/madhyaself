import 'package:madhya/core/exporters/app_export.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _androidChannelId = 'high_importance_channel';
  static const String _androidChannelName = 'High Importance Notifications';
  static const String _androidChannelDescription =
      'This channel is used for important notifications';

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDescription,
        importance: Importance.max,
      );

  /// ===========================================
  /// Init
  /// ===========================================
  Future<void> init() async {
    await _requestNotificationPermissions();
    await _initPushNotifications();
    await _initLocalNotifications();
  }

  /// ===========================================
  /// Permission
  /// ===========================================

  Future<void> _requestNotificationPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await _firebaseMessaging.getToken();
  }

  /// ===========================================
  /// Firebase Listeners
  /// ===========================================
  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// App killed state
    final RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      handleNotificationNavigation(initialMessage.data, 'terminate');
    }

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    // Listen for messages when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  /// ===========================================
  /// Local Notification Init
  /// ===========================================
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@drawable/logo');

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  /// ===========================================
  /// Foreground Message
  /// ===========================================
  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'Notification',
        body: message.notification!.body ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    handleNotificationNavigation(message.data, 'background');
  }

  /// ===========================================
  /// Notification Tap
  /// ===========================================
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    final Map<String, dynamic> data = jsonDecode(response.payload!);
    handleNotificationNavigation(data, 'local');
  }

  /// ===========================================
  /// Show Notification
  /// ===========================================
  Future<void> _showLocalNotification({
    required String? title,
    required String? body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title ?? 'Notification',
      body: body ?? 'New notification',
      notificationDetails: platformDetails,
      payload: payload,
    );
  }

  /// ===========================================
  /// Navigation Logic
  /// ===========================================
  void handleNotificationNavigation(Map<String, dynamic> data, String from) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final action = data['action']?.toString();

      switch (action) {
        case 'external_url':
          final url = data['url']?.toString();

          if (url != null && url.isNotEmpty) {
            launchInBrowser(Uri.parse(url));
          }
          break;

        case 'open_chat':
          final id = data['conversation_id']?.toString();

          if (id != null && id.isNotEmpty) {
            Get.toNamed(Routes.chatDetails, arguments: {'id': id});
          }
          break;

        case 'document_verification':
          Get.toNamed(Routes.managePhotos);
          break;

        case 'interest_received':
        case 'interest_accepted':
          Get.toNamed(Routes.interest);
          break;

        default:
          // debugPrint('Unknown action => $action');
      }
    });
  }
}
