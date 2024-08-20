import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:united_natives/newModel/repo/reminder_response_model.dart';
import 'package:united_natives/pages/reminder2/sqflite_database_helper.dart';

class RemindersController extends GetxController {
  final dbHelper = DatabaseHelper();
  List<RemindersResponseModel> reminders = [];
  bool getData = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  getAllReminders() async {
    getData = true;
    update();
    final fetchDetailsData = await dbHelper.getDataFromTable();
    if (fetchDetailsData.isNotEmpty) {
      reminders = List<RemindersResponseModel>.from(
          fetchDetailsData.map((x) => RemindersResponseModel.fromJson(x)));
    } else {
      reminders = [];
    }
    getData = false;
    update();
  }

  deleteReminder(int id, BuildContext context) async {
    await dbHelper.deleteMedicineReminder(id).then(
      (value) {
        removeReminder(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Reminder deleted',
              style: TextStyle(fontSize: 18),
            ),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Medicine Reminder',
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  initializeNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initializationSettings);
    update();
  }

  void showNotification(
      int id, String title, String body, int hour, int minute) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    DateTime temp = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute, 0);

    final utc = temp.toUtc();

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, utc.hour, utc.minute);

    await flutterLocalNotificationsPlugin?.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      getPlatformChannelSpecfics(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void showOnceNotification(
      int id, String title, String body, int hour, int minute) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    DateTime temp = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute, 0);

    final utc = temp.toUtc();

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, utc.hour, utc.minute);

    await flutterLocalNotificationsPlugin?.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      getPlatformChannelSpecfics(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin?.cancel(notificationId);
  }
}
