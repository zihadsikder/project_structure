import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Background handler for processing data-only messages

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  static String? fcmtoken;

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    try {
      log("Starting push notification initialization");

      // Request notification permissions
      await _requestPermissions();

      // Android Notification Channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Channel for high-priority notifications',
        importance: Importance.max,
      );

      final androidPlugin =
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
      >();
      await androidPlugin?.createNotificationChannel(channel);
      log("Android notification channel created: high_importance_channel");

      // Android and iOS Initialization Settings
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize local notifications
      await _flutterLocalNotificationsPlugin
          .initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log(
            "User tapped on notification with payload: ${response.payload}",
          );
          _navigateToScreenFromLocal(response.payload);
        },
      )
          .then((success) {
        log("Local notifications initialized successfully: $success");
      })
          .catchError((error) {
        log("Error initializing local notifications: $error");
      });

      // Get FCM Token
      String? fcmToken = await _firebaseMessaging.getToken();
      log("FCM Token: $fcmToken");
      fcmtoken = fcmToken;

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        log("FCM Token refreshed: $newToken");
        fcmtoken = newToken;
      });

      // Handle Foreground Notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Foreground message received: ${message.toMap()}");
        log(
          "Notification: ${message.notification?.toMap() ?? 'No notification payload'}",
        );
        log("Data: ${message.data}");
        _showLocalNotification(message);

        // if (Get.isRegistered<NotificationController>()) {
        //   log("Calling NotificaitonController.onNewNotificationReceived");
        //   Get.find<NotificationController>().onNewNotificationReceived();
        // }
      });

      // Handle Background Notifications
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log("Background message clicked: ${message.toMap()}");
        log(
          "Notification: ${message.notification?.toMap() ?? 'No notification payload'}",
        );
        log("Data: ${message.data}");
        _navigateToScreen(message);
      });

      // Handle Terminated State Notifications
      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        log("Terminated message received: ${initialMessage.toMap()}");
        log(
          "Notification: ${initialMessage.notification?.toMap() ?? 'No notification payload'}",
        );
        log("Data: ${initialMessage.data}");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToScreen(initialMessage);
        });
      } else {
        log("No initial message received on app launch");
      }

      // iOS Foreground Notification Settings
      await setupIOSNotifications();
      log("Push notification initialization completed");
    } catch (e, stackTrace) {
      log("Error initializing push notifications: $e", stackTrace: stackTrace);
    }
  }

  /// Request Notification Permissions
  Future<void> _requestPermissions() async {
    try {
      // iOS Permission Request
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(alert: true, badge: true, sound: true);
      log("iOS Authorization Status: ${settings.authorizationStatus}");

      // Android 13+ Notification Permission
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        log("Android Notification Permission: $status");
        if (status.isDenied) {
          log(
            "Android notification permission denied. Notifications may not work.",
          );
        }
      }
    } catch (e, stackTrace) {
      log("Error requesting permissions: $e", stackTrace: stackTrace);
    }
  }

  /// Set up iOS Foreground Notifications
  Future<void> setupIOSNotifications() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        log("iOS foreground notification settings configured");
      }
    } catch (e, stackTrace) {
      log("Error setting up iOS notifications: $e", stackTrace: stackTrace);
    }
  }

  /// Show Local Notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final String title =
          message.notification?.title ?? message.data['title'] ?? "No Title";
      final String body =
          message.notification?.body ?? message.data['body'] ?? "No Body";
      final String? payload = message.data['payload'];

      log(
        "Attempting to show local notification: Title=$title, Body=$body, Payload=$payload",
      );

      final AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        channelDescription: 'Channel for high-priority notifications',
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformDetails,
        payload: payload,
      );
      log(
        "Local notification shown successfully: ID=$notificationId, Title=$title",
      );
    } catch (e, stackTrace) {
      log("Error showing local notification: $e", stackTrace: stackTrace);
    }
  }

  /// Handle Navigation for Notification Clicks
  void _navigateToScreen(RemoteMessage message) {
    final String? route = message.data['route'];
    log("Attempting navigation with route: $route");
    if (route != null && navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(route);
      log("Navigated to route: $route");
    } else {
      log("No route provided or navigator not available");
    }
  }

  /// Handle Local Notification Clicks
  void _navigateToScreenFromLocal(String? payload) {
    log("Attempting navigation from local notification with payload: $payload");
    if (payload != null && navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(payload);
      log("Navigated to route from local notification: $payload");
    } else {
      log("No payload provided or navigator not available");
    }
  }

  /// Test Local Notification
  Future<void> testLocalNotification() async {
    try {
      log("Testing local notification");
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        channelDescription: 'Channel for high-priority notifications',
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        'Test Notification',
        'This is a test notification',
        platformDetails,
        payload: 'test_payload',
      );
      log("Test local notification shown successfully");
    } catch (e, stackTrace) {
      log("Error showing test local notification: $e", stackTrace: stackTrace);
    }
  }
}
