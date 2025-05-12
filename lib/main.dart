import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationManager.initializeNotifications();

  await NotificationManager.initializeBackgroundFetch();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notification Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotificationManager.showInstantNotification();
          },
          child: Text('Show Instant Notification'),
        ),
      ),
    );
  }
}

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> initializeBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
      ),
      (taskId) async {
        showBackgroundNotification();
        BackgroundFetch.finish(taskId);
      },
    );
  }

  static void showBackgroundNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'background_channel',
      'Background Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Background Task',
      'Background fetch task executed!',
      notificationDetails,
    );
  }

  static void showInstantNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Instant Notification',
      'Button-triggered notification',
      notificationDetails,
    );
  }
}
