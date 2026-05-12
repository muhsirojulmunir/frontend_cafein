import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    if (kIsWeb) return; // Basic Firebase setup usually happens in index.html for web

    // Request permissions for iOS and Android 13+
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
        // Show local notification or update UI if needed
      }
    });
  }

  static Future<String?> getToken() async {
    try {
      if (kIsWeb) return null;
      return await _fcm.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      return null;
    }
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `Firebase.initializeApp()` before using other Firebase services.
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}
