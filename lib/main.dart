import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/services/Auth_service.dart';
import 'core/services/notification_services.dart';

import 'core/utils/logging/loggerformain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first and ensure it completes
  try {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // For now we just use the default one as the user might not have generated options file
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Set up background message handler
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase Messaging background handler setup failed: $e");
  }

  // Initialize AuthService
  await AuthService.init();

  // Initialize PushNotificationService after Firebase is fully initialized
  try {
    final notificationService = PushNotificationService();
    await notificationService.initialize();
    await notificationService.setupIOSNotifications();
  } catch (e) {
    debugPrint("PushNotificationService initialization failed: $e");
  }

  // Set preferred device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize logger based on release mode
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

  // Run the app
  runApp(const MyApp());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background message handling
  try {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  } catch (e) {
    log("Firebase Background Init Failed: $e");
  }
}
