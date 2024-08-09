import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

class GenderWidget extends StatefulWidget {
  final Color color;

  const GenderWidget({super.key, required this.color});
  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  bool _male = false;
  bool _female = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: widget.color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              Translate.of(context)!.translate('gender'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        CheckboxListTile(
          value: _male,
          onChanged: (value) {
            setState(() {
              _male = value!;
            });
          },
          title: Text(
            Translate.of(context)!.translate('male_doctor'),
          ),
        ),
        CheckboxListTile(
          value: _female,
          onChanged: (value) {
            setState(() {
              _female = value!;
            });
          },
          title: Text(
            Translate.of(context)!.translate('female_doctor'),
          ),
        ),
      ],
    );
  }
}
