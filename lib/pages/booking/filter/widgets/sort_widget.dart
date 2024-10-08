import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

enum SortBy { nothing, fee }

class SortWidget extends StatefulWidget {
  final Color color;

  const SortWidget({super.key, required this.color});
  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  SortBy _sortBy = SortBy.nothing;

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
              Translate.of(context)!.translate('sort_by'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        RadioListTile(
          value: SortBy.nothing,
          onChanged: (value) {
            setState(() {
              _sortBy = value!;
            });
          },
          groupValue: _sortBy,
          title: Text(
            Translate.of(context)!.translate('default'),
          ),
        ),
        RadioListTile(
          value: SortBy.fee,
          onChanged: (value) {
            setState(() {
              _sortBy = value!;
            });
          },
          groupValue: _sortBy,
          title: Text(
            Translate.of(context)!.translate('consultaion_fee'),
          ),
        ),
      ],
    );
  }
}
