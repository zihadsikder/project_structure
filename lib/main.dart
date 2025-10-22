

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/services/Auth_service.dart';

import 'core/utils/logging/loggerformain.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first and ensure it completes
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize AuthService
  await AuthService.init();

  // Initialize PushNotificationService after Firebase is fully initialized
  // final notificationService = PushNotificationService();
  // await notificationService.initialize();
  // await notificationService.setupIOSNotifications();

  // Set preferred device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize logger based on release mode
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

  // Run the app
  runApp(const MyApp());
}

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase for background message handling
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   log("Handling a background message: ${message.messageId}");
// }
