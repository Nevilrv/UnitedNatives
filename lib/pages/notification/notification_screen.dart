import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class MyNotiScreen extends StatefulWidget {
  const MyNotiScreen({super.key});

  @override
  State<MyNotiScreen> createState() => _MyNotiScreenState();
}

class _MyNotiScreenState extends State<MyNotiScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text('Plugin example app',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
              textAlign: TextAlign.center),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              MaterialButton(
                onPressed: _showSchedulaeedNotification,
                child: const Text('Show Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Notification', 'Flutter is awesome', platformChannelSpecifics,
        payload: 'This is notification detail Text...');
  }

  Future<void> _showSchedulaeedNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 14, 38);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'New Notification',
      'Flutter is awesome',
      scheduledDate,
      platformChannelSpecifics,
      payload: 'This is notification detail Text...',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // To trigger daily
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Your Notification Detail"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}
