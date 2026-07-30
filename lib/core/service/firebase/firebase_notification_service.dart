import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Request notification permission
  Future<NotificationSettings> requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get FCM Token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic() async {
    await _messaging.subscribeToTopic('android_haditv');

    if (kDebugMode) {
      print('Subscribed to topic: android_haditv');
    }
  }

  /// Listen foreground messages
  void onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print('Notification received: ${message.notification?.title}');
      }
    });
  }

  /// Background notification handler
  void setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

/// Must be top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background notification: ${message.messageId}');
  }
}
