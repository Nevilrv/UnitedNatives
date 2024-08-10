import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';

class DocNotificationSettingsPage extends StatefulWidget {
  const DocNotificationSettingsPage({super.key});

  @override
  State<DocNotificationSettingsPage> createState() =>
      _DocNotificationSettingsPageState();
}

class _DocNotificationSettingsPageState
    extends State<DocNotificationSettingsPage> {
  bool? _allNotifications;
  bool? _campain,
      _pm,
      _alerts,
      _appointments,
      _healthTips,
      _reminders,
      _updates;

  @override
  void initState() {
    super.initState();
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
          Translate.of(context)!.translate('notification_settings'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile(
              value: _allNotifications!,
              onChanged: (_) {
                setState(() {
                  _allNotifications = !_allNotifications!;
                });
              },
              title: Text(
                Translate.of(context)!.translate('all_notifications'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CheckboxListTile(
              value: _campain,
              onChanged: _allNotifications!
                  ? (value) {
                      if (!_allNotifications!) return;
                      setState(() {
                        _campain = !_campain!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('campain_messages'),
              ),
            ),
            const Divider(),
            CheckboxListTile(
              value: _pm,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _pm = !_pm!;
                      });
                    }
                  : null,
              title: Text(
                  Translate.of(context)!.translate('conversation_messages')),
            ),
            const Divider(),
            CheckboxListTile(
              value: _alerts,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _alerts = !_alerts!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('alerts'),
              ),
            ),
            const Divider(),
            CheckboxListTile(
              value: _appointments,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _appointments = !_appointments!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('appointments'),
              ),
            ),
            const Divider(),
            CheckboxListTile(
              value: _healthTips,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _healthTips = !_healthTips!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('health_tips'),
              ),
            ),
            const Divider(),
            CheckboxListTile(
              value: _reminders,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _reminders = !_reminders!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('reminders_and_records'),
              ),
            ),
            const Divider(),
            CheckboxListTile(
              value: _updates,
              onChanged: _allNotifications!
                  ? (value) {
                      setState(() {
                        _updates = !_updates!;
                      });
                    }
                  : null,
              title: Text(
                Translate.of(context)!.translate('updates_and_offers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
