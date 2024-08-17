import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:united_natives/pages/reminder2/animations/fade_animation.dart';
import 'package:united_natives/pages/reminder2/sqflite_database_helper.dart';
import 'package:timezone/data/latest.dart' as tzz;

class AddMedicine extends StatefulWidget {
  final double height;

  const AddMedicine(this.height, {super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  static final _formKey = GlobalKey<FormState>();
  String? _name;

  String? _dose;
  bool isEveryday = false;
  final int _selectedIndex = 0;
  final dbHelper = DatabaseHelper();
  final List<String> _icons = ['drug.png'];
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  triggerNotification(
      int id, String title, String body, int hour, int minute) async {
    tzz.initializeTimeZones();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);

    // tz.TZDateTime scheduledDate =
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    final time = scheduledDate.toUtc();
    log('time==========>>>>>${time}');
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      0,
      title,
      body,
      time,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void showNotification(
      int id, String title, String body, int hour, int minute) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    final time = scheduledDate.toUtc();
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      0,
      title,
      body,
      time,
      getPlatformChannelSpecfics(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void showOnceNotification(
      int id, String title, String body, int hour, int minute) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    final time = scheduledDate.toUtc();
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      0,
      title,
      body,
      time,
      getPlatformChannelSpecfics(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin?.cancel(notificationId);
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

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.3,
      Container(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
          height: widget.height * .8,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Add Reminder',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // back to main screen
                        Navigator.pop(context, null);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Theme.of(context).primaryColor.withOpacity(.65),
                      ),
                    )
                  ],
                ),
                _buildForm(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isEveryday,
                      onChanged: (value) {
                        setState(() {
                          isEveryday = !isEveryday;
                        });
                      },
                    ),
                    const Text('Remind me everyday')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      _submit();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Colors.white,
                    highlightColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Add Reminder'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Form _buildForm() {
    TextStyle labelsStyle =
        const TextStyle(fontWeight: FontWeight.w400, fontSize: 24);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input!.length < 5) ? 'Name is short' : null,
            onSaved: (input) => _name = input,
          ),
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              labelText: 'Remarks',
              labelStyle: labelsStyle,
            ),
            validator: (input) =>
                (input!.length > 50) ? 'Remarks is long' : null,
            onSaved: (input) => _dose = input,
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      ).then((TimeOfDay? selectedTime) async {
        int hour = selectedTime!.hour;
        int minute = selectedTime.minute;
        String type = selectedTime.period.toString();
        var newString = type.substring(type.length - 2).toUpperCase();
        var everyDay = isEveryday == true
            ? 'Set for Everyday, $hour:$minute $newString'
            : '$hour:$minute $newString';
        MedicineReminder scope = MedicineReminder(
          name: _name.toString(),
          dose: _dose.toString(),
          image: 'assets/images/${_icons[_selectedIndex]}',
          time: everyDay,
          isEveryDay: isEveryday == true ? 1 : 0,
        );
        final id = await dbHelper.insertReminderDetails(scope);

        isEveryday == true
            ? triggerNotification(id, _name!, _dose!, hour, minute)
            : triggerNotification(id, _name!, _dose!, hour, minute);
        Navigator.pop(context, id);
      });
    }
  }
}
