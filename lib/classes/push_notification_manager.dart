import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<String> getToken() async {
    return await firebaseMessaging.getToken();
  }

}
