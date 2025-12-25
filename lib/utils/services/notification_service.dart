import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../constants/app_constants.dart';
import '../../constants/assets.dart';
import '../../constants/firebase_collections.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/user_repo.dart';
import '../../router/app_router.dart';

class NotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission (works for iOS + Web)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      // announcement: true,
      badge: true,
      // carPlay: false,
      // criticalAlert: false,
      // provisional: false,
      sound: true,
    );
    debugPrint("Permission: ${settings.authorizationStatus}");

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   await _updateFcmToken(userId);
    // }

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInit = DarwinInitializationSettings();
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iOSInit);

    await _localNotifications.initialize(initSettings);

    // Foreground messages (mobile)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification opened: ${message.notification?.title}");
      // if (message.data[AppConstants.isBirthdayNotification] == "true") {
      //   showBirthdayDialog(
      //     navigatorKey.currentContext!,
      //     message.notification?.body ??
      //         "🎉 Renew your membership today and enjoy exclusive benefits! Contact admin for more info.",
      //   );
      // }
    });
  }

  Future<void> _sendTokenToFirebase(String token, {String? uid}) async {
    final authRepo = AuthRepository();
    final userRepo = UserRepository();
    final firestore = FirebaseFirestore.instance;

    final userId = uid ?? authRepo.currentUser?.uid;

    final user = userId != null ? await userRepo.getUser(userId) : null;
    if (user != null) {
      if (user.role == AppConstants.candidate) {
        firestore.collection(FirebaseCollections.candidate).doc(userId).update({
          AppConstants.fcmToken: token,
        });
      } else if (user.role == AppConstants.admin) {
        firestore.collection(FirebaseCollections.admin).doc(userId).update({
          AppConstants.fcmToken: token,
        });
      }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (kIsWeb) return; // Skip for web (browser handles notifications)

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  Future<void> updateTokenForUser(String userId) async {
    String? token = await _messaging.getToken();
    if (token != null) {
      await _sendTokenToFirebase(token,
          uid: userId); // save in Firestore/backend
    }
  }
}
