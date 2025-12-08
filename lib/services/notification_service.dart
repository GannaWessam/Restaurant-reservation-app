import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// -------------------------------
  /// 1) Initialize local notifications
  /// -------------------------------
  static Future<void> initializeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    const initSettings =
    InitializationSettings(android: androidInit, iOS: iOSInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// -------------------------------------------
  /// 2) Show Notification when App is foreground
  /// -------------------------------------------
  static void showFlutterNotification(RemoteMessage message) {
    final notification = message.notification;

    if (notification == null) return;

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// -------------------------------------------
  /// 3) Send Notification using HTTP POST (Dio)
  /// -------------------------------------------
  Future<void> sendNotificationToDevice({
    required String serverKey,   // FCM server key
    required String token,       // target device token
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const url = "https://fcm.googleapis.com/fcm/send";

    final payload = {
      "to": token,
      "notification": {
        "title": title,
        "body": body,
        "sound": "default",
      },
      "data": data ?? {}, // custom data for navigation, etc.
    };

    try {
      await Dio().post(
        url,
        data: payload,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "key=$serverKey",
          },
        ),
      );
      print("Notification sent successfully");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
