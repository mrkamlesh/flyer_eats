import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
        //onBackgroundMessage: onBackgroundMessage,
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
      );

      _initialized = true;
    }
  }

  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
