import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';

class SettingsWidget extends StatefulWidget {
  final Color color;

  const SettingsWidget({super.key, required this.color});
  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _healthTips = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: widget.color,
          padding: const EdgeInsets.all(15),
          child: Text(
            Translate.of(context)!.translate('settings'),
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        SwitchListTile(
          value: _healthTips,
          onChanged: (_) {
            setState(() {
              _healthTips = !_healthTips;
            });
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context)!.translate('health_tips_for_you'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                Translate.of(context)!.translate('get_information_tips'),
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
