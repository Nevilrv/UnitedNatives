import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationManager() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initNotifications() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          onDidReceiveLocalNotification,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        onSelectNotification(details.payload!);
      },
    );
  }

  void showNotification(
      int id, String title, String body, int hour, int minute) async {
    final timeZone = tz.local;
    final scheduledDate = tz.TZDateTime(
      timeZone,
      tz.TZDateTime.now(timeZone).year,
      tz.TZDateTime.now(timeZone).month,
      tz.TZDateTime.now(timeZone).day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(tz.TZDateTime.now(timeZone))) {
      scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin?.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      getPlatformChannelSpecfics(),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  void showOnceNotification(
      int id, String title, String body, int hour, int minute) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await flutterLocalNotificationsPlugin?.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await getPlatformChannelSpecfics(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'Medicine Reminder');
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin?.cancel(notificationId);
  }
}
