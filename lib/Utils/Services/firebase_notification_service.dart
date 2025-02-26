import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// A manager class to handle Firebase notifications in the application.
class FirebaseNotificationManager {
  static final _notification = FlutterLocalNotificationsPlugin();

  /// Initializes the notification manager, sets up Firebase messaging,
  /// and configures foreground and background notification handling.
  ///
  /// Returns a future that resolves with the current [FirebaseNotificationManager] instance.
  Future<FirebaseNotificationManager> init() async {
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_icon'),
      iOS: DarwinInitializationSettings(),
    ));

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings status = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      if (Platform.isAndroid) {
        var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
            "1", 'jrtransportation',
            importance: Importance.max, priority: Priority.high);
        var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics,
        );
        await _notification.show(
          1001,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
        );

        // Debugging output
        print(message.notification?.title);
        print(message.notification?.body);
        print(jsonEncode(message.data));
        print(int.parse(DateFormat('MMddHHmm').format(DateTime.now())));
      }
    });

    return this;
  }

  /// Retrieves the Firebase token for the device.
  ///
  /// Returns a future that resolves with the Firebase token as a string.
  Future<String> getToken() async {
    return await FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      return Future.value(value ?? '');
    }).catchError((error) {
      return Future.value('');
    });
  }
}

/// Background message handler for Firebase notifications.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  final _notification = FlutterLocalNotificationsPlugin();

  // Initialize Firebase based on platform
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDcQ3eaiQSMIt4sJ6tfga79IW9MpG2wgcc",
            appId: "1:924465089055:ios:7d5ba4a2912443bec9e32a",
            messagingSenderId: "924465089055",
            projectId: "flow-activo-78084"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAk3wXwcQ-zCcEaAt3Cq0b3khuRUIQCppE",
            appId: "1:924465089055:android:9a5b9275168e2016c9e32a",
            messagingSenderId: "924465089055",
            projectId: "flow-activo-78084"));
  }

  // Notification details
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '1', 'jrtransportation',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // Show the notification
  await _notification.show(
    1001,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );

  // Debugging output
  print("back ${message.notification?.title}");
  print("back ${message.notification?.body}");
  print(jsonEncode(message.data));
  print(int.parse(DateFormat('MMddHHmm').format(DateTime.now())));
}
