import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Notification channel for background fetch',
      defaultColor: Colors.blue,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    ),
  ], debug: true);

  // Check and request notification permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await NotificationManager.initializeBackgroundFetch();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
            if (isAllowed) {
              NotificationManager.showInstantNotification();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification permission not granted. Please enable it in settings.'),
                ),
              );
            }
          },
          child: Text('Show Instant Notification'),
        ),
      ),
    );
  }
}

class NotificationManager {
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

  static void showBackgroundNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'Background Task',
        body: 'Background fetch task executed!',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static void showInstantNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'Instant Notification',
        body: 'Button-triggered notification',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
