import 'package:doctor_appointment_booking/pages/reminder/notifications/NotificationManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../reminder/database/moor_database.dart';

class AddMedicine extends StatefulWidget {
  final double height;
  final AppDatabase _database;
  final NotificationManager manager;

  AddMedicine(this.height, this._database, this.manager);

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  static final _formKey = new GlobalKey<FormState>();
  String _name;
  String _dose;
  bool isEveryday = false;
  int _selectedIndex = 0;
  List<String> _icons = ['drug.png'];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotification(
      int id, String title, String body, int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      title,
      body,
      time,
      getPlatformChannelSpecfics(),
    );
    print('Notification Succesfully Scheduled at ${time.toString()}');
  }

  void showOnceNotification(
      int id, String title, String body, int hour, int minute) async {
    DateTime now1 = DateTime.now();
    DateTime now =
        DateTime(now1.year, now1.month, now1.day, hour, minute, 00, 00);

    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, now, getPlatformChannelSpecfics());

    print('Notification Succesfully Scheduled at ${now.toString()}');
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'Medicine Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
  /* Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      'Flutter is awesome',
      platformChannelSpecifics,
      payload: 'This is notification detail Text...',
    );
  }*/

  // Future _showSchedulaeedNotification() async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //     0,
  //     'New Notification',
  //     'Flutter is awesome',
  //     Time(14, 38, 00),
  //     platformChannelSpecifics,
  //     payload: 'This is notification detail Text...',
  //   );
  // }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Your Notification Detail"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
        height: widget.height * .8,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
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
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 15,
              ),
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
                  Text('Remind me everyday')
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    _submit(widget.manager);
                  },
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Add Reminder'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Form _buildForm() {
    TextStyle labelsStyle =
        TextStyle(fontWeight: FontWeight.w400, fontSize: 27);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: labelsStyle,
            ),
            validator: (input) => (input.length < 5) ? 'Name is short' : null,
            onSaved: (input) => _name = input,
          ),
          TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Remarks',
              labelStyle: labelsStyle,
            ),
            validator: (input) =>
                (input.length > 50) ? 'Remarks is long' : null,
            onSaved: (input) => _dose = input,
          )
        ],
      ),
    );
  }

  void _submit(NotificationManager manager) async {
    if (_formKey.currentState.validate()) {
      // form is validated
      _formKey.currentState.save();
      print(_name);
      print(_dose);
      //show the time picker dialog
      showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      ).then((selectedTime) async {
        int hour = selectedTime.hour;
        int minute = selectedTime.minute;
        String type = selectedTime.period.toString();
        // DateTime now=DateTime.
        var newString = type.substring(type.length - 2).toUpperCase();
        print('TYPE   >>>${newString.toUpperCase()}');

        // _time = DateTime.parse(selectedTime.format(context));
        // print('TIME$_time');
        // insert into database

        var medicineId = await widget._database.insertMedicine(
            MedicinesTableData(
                name: _name,
                dose: _dose,
                time: isEveryday == true
                    ? 'Set for Everyday ,$hour:$minute $newString'
                    : '$hour:$minute $newString',
                image: 'assets/images/' + _icons[_selectedIndex],
                id: null));
        // sehdule the notification

        isEveryday == true
            ? showNotification(medicineId, _name, _dose, hour, minute)
            : showOnceNotification(medicineId, _name, _dose, hour, minute);

        // isEveryday == true
        //     ? manager.showNotification(medicineId, _name, _dose, hour, minute)
        //     : manager.showOnceNotification(
        //         medicineId, _name, _dose, hour, minute);

        // NotificationApi()
        //     .showOnceNotification(medicineId, _name, _dose, hour, minute);
        // // // The medicine Id and Notitfaciton Id are the same
        print('New Med id' + medicineId.toString());
        // go back
        Navigator.pop(context, medicineId);
      });
    }
  }

  Widget _buildIcons(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: (index == _selectedIndex)
              ? Theme.of(context).accentColor.withOpacity(.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset('assets/images/' + _icons[index]),
      ),
    );
  }
}
