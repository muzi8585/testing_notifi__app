// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeService();
//   await AwesomeNotifications().initialize(
//     null,
//     [
//       NotificationChannel(
//         channelKey: 'bg_channel',
//         channelName: 'Background Notifications',
//         channelDescription: 'Notification from background service',
//         importance: NotificationImportance.High,
//         defaultColor: Colors.blue,
//         ledColor: Colors.white,
//       ),
//     ],
//     debug: true,
//   );

//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     requestNotificationPermission();
//   }

//   void requestNotificationPermission() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }

//   void _showNotification() {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'bg_channel',
//         title: 'Reminder',
//         body: 'This is your 1-minute notification!',
//         notificationLayout: NotificationLayout.Default,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("1 Minute Notification")),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: _showNotification,
//             child: Text('Test Notification'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'Background Service',
//       initialNotificationContent: 'Running...',
//     ),
//     iosConfiguration: IosConfiguration(),
//   );

//   service.startService();
// }

// void onStart(ServiceInstance service) {
//   DartPluginRegistrant.ensureInitialized();

//   Timer.periodic(Duration(minutes: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//           channelKey: 'bg_channel',
//           title: 'Background Notification',
//           body: 'Triggered every 1 minute!',
//         ),
//       );
//     }
//   });
// }
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'bg_channel',
        channelName: 'Background Notifications',
        channelDescription: 'Used for background fetch notifications',
        importance: NotificationImportance.High,
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
    debug: true,
  );

  runApp(MyApp());

  initBackgroundFetch();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  void requestNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void _showNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'bg_channel',
        title: 'Test Notification',
        body: 'This was manually triggered.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Background Fetch + Notification")),
        body: Center(
          child: ElevatedButton(
            onPressed: _showNotification,
            child: Text('Send Test Notification'),
          ),
        ),
      ),
    );
  }
}

// Setup Background Fetch
void initBackgroundFetch() async {
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15, // Android min is ~15 min
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE,
    ),
    onBackgroundFetch,
    onBackgroundFetchTimeout,
  );
}

void onBackgroundFetch(String taskId) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      channelKey: 'bg_channel',
      title: 'Background Task',
      body: 'Background fetch triggered successfully!',
    ),
  );
  BackgroundFetch.finish(taskId);
}

void onBackgroundFetchTimeout(String taskId) {
  BackgroundFetch.finish(taskId);
}
