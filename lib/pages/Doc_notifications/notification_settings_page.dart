import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

class DocNotificationSettingsPage extends StatefulWidget {
  @override
  _DocNotificationSettingsPageState createState() =>
      _DocNotificationSettingsPageState();
}

class _DocNotificationSettingsPageState
    extends State<DocNotificationSettingsPage> {
  var _allNotifications;
  var _campain, _pm, _alerts, _appointments, _healthTips, _reminders, _updates;

  @override
  void initState() {
    super.initState();
    //TODO get from shared preferences
    _allNotifications = true;
    _campain = true;
    _pm = true;
    _alerts = true;
    _appointments = true;
    _healthTips = true;
    _reminders = true;
    _updates = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context).translate('notification_settings'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              value: _allNotifications,
              onChanged: (_) {
                setState(() {
                  _allNotifications = !_allNotifications;
                });
              },
              title: Text(
                Translate.of(context).translate('all_notifications'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            CheckboxListTile(
              value: _campain,
              onChanged: _allNotifications
                  ? (value) {
                      if (!_allNotifications) return;
                      setState(() {
                        _campain = !_campain;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('campain_messages'),
              ),
            ),
            Divider(),
            CheckboxListTile(
              value: _pm,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _pm = !_pm;
                      });
                    }
                  : null,
              title: Text(
                  Translate.of(context).translate('conversation_messages')),
            ),
            Divider(),
            CheckboxListTile(
              value: _alerts,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _alerts = !_alerts;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('alerts'),
              ),
            ),
            Divider(),
            CheckboxListTile(
              value: _appointments,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _appointments = !_appointments;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('appointments'),
              ),
            ),
            Divider(),
            CheckboxListTile(
              value: _healthTips,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _healthTips = !_healthTips;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('health_tips'),
              ),
            ),
            Divider(),
            CheckboxListTile(
              value: _reminders,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _reminders = !_reminders;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('reminders_and_records'),
              ),
            ),
            Divider(),
            CheckboxListTile(
              value: _updates,
              onChanged: _allNotifications
                  ? (value) {
                      setState(() {
                        _updates = !_updates;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context).translate('updates_and_offers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
