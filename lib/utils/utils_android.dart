import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Background message handler (must be a top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  debugPrint("🔔 Background message received: ${message.notification?.title}");
}

Future<void> enableFirebaseMessagingAutoInit() async {
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
}

void registerBackgroundMessageHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}
