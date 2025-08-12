// import 'dart:developer';

// import 'package:family_management_app/service/secure_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> initFCM() async {
//     await requestPermission();
//     await initLocalNotification();

//     String? fcmtoken = await _messaging.getToken();
//     await SecureStorage.save(key: "fcmToken", data: fcmtoken!);
//     log("FCMToken : $fcmtoken");

//     // Listen for foreground message
//     FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
//       log("Message recieved: ${msg.notification?.title}");
//       showNotification(msg);
//     });

//     // background message
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
//       log('App opened by notfication ${msg.notification?.title}');
//       // Navigation
//     });
//   }

//   static Future<void> requestPermission() async {
//     NotificationSettings notificationSettings = await _messaging
//         .requestPermission(
//           alert: true,
//           announcement: true,
//           badge: true,
//           carPlay: true,
//           criticalAlert: true,
//           provisional: true,
//           sound: true,
//         );
//     if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.authorized) {
//       log("User granted Permision");
//     } else if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.denied) {
//       await openAppSettings();
//       log("user Permission denied");
//     }
//   }

//   static Future<void> initLocalNotification() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("@mipmap/launcher_icon");

//     const DarwinInitializationSettings darwinInitializationSettings =
//         DarwinInitializationSettings();

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: androidInitializationSettings,
//           iOS: darwinInitializationSettings,
//         );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification(RemoteMessage msg) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//           "high_importance_channel",
//           "High Importance Notifications",
//           importance: Importance.high,
//           priority: Priority.high,
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       msg.hashCode,
//       msg.notification?.title,
//       msg.notification?.body,
//       notificationDetails,
//     );
//   }
// }

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
//   await Firebase.initializeApp();
//   log("background message recieved ;${msg.notification?.title}");
// }

import 'dart:developer';
import 'package:family_management_app/service/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Call this in main() after Firebase.initializeApp()
  static Future<void> initFCM() async {
    await requestPermission();
    await initLocalNotification();

    // ✅ iOS foreground notification display
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ Get FCM Token
    String? fcmtoken = await _messaging.getToken();
    if (fcmtoken != null) {
      await SecureStorage.save(key: "fcmToken", data: fcmtoken);
      log("FCM Token: $fcmtoken");
    }

    // ✅ Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      log("Foreground message: ${msg.notification?.title}");
      showNotification(msg);
    });

    // ✅ Notification tap listener (background or terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      log('Notification opened: ${msg.notification?.title}');
      // TODO: Handle navigation if needed
    });
  }

  /// Request push notification permission
  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // Set true if you want iOS provisional
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await openAppSettings();
      log("🚫 Notification permission denied");
    } else {
      log("✅ Notification permission granted");
    }
  }

  /// Local notification initialization
  static Future<void> initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  /// Show notification from FCM message
  static Future<void> showNotification(RemoteMessage msg) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      msg.hashCode,
      msg.notification?.title,
      msg.notification?.body,
      details,
    );
  }

  /// Show local notification instantly (e.g., after board creation)
  static Future<void> showLocalBoardCreatedNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      "Board Created",
      "Your board has been successfully created!",
      details,
    );
  }

  static Future<void> showLocalBoardJoiningNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      "Request Sent",
      "Your request to join the board has been sent!",
      details,
    );
  }
}

/// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  log("📩 Background message: ${msg.notification?.title}");
}
