import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

enum ConsultationFee { free, range1, range2, range3, range4 }

class ConsultationFeeWidget extends StatefulWidget {
  final Color color;

  const ConsultationFeeWidget({super.key, required this.color});
  @override
  State<ConsultationFeeWidget> createState() => _ConsultationFeeWidgetState();
}

class _ConsultationFeeWidgetState extends State<ConsultationFeeWidget> {
  ConsultationFee _consultationFee = ConsultationFee.free;

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
              Translate.of(context)!.translate('consultaion_fee'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        RadioListTile(
          value: ConsultationFee.free,
          onChanged: (value) {
            setState(() {
              _consultationFee = value!;
            });
          },
          groupValue: _consultationFee,
          title: Text(
            Translate.of(context)!.translate('free'),
          ),
        ),
        RadioListTile(
          value: ConsultationFee.range1,
          onChanged: (value) {
            setState(() {
              _consultationFee = value!;
            });
          },
          groupValue: _consultationFee,
          title: const Text('1-50'),
        ),
        RadioListTile(
          value: ConsultationFee.range2,
          onChanged: (value) {
            setState(() {
              _consultationFee = value!;
            });
          },
          groupValue: _consultationFee,
          title: const Text('51-100'),
        ),
        RadioListTile(
          value: ConsultationFee.range3,
          onChanged: (value) {
            setState(() {
              _consultationFee = value!;
            });
          },
          groupValue: _consultationFee,
          title: const Text('101-150'),
        ),
        RadioListTile(
          value: ConsultationFee.range4,
          onChanged: (value) {
            setState(() {
              _consultationFee = value!;
            });
          },
          groupValue: _consultationFee,
          title: const Text('151+'),
        )
      ],
    );
  }
}
