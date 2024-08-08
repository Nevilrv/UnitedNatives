import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:united_natives/utils/constants.dart';

class CustomCircularIndicator extends StatelessWidget {
  final double? radius;
  final double? percent;
  final double? lineWidth;
  final double? line1Width;
  final String? footer;

  const CustomCircularIndicator(
      {super.key,
      @required this.radius,
      @required this.percent,
      this.lineWidth,
      this.line1Width,
      this.footer});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: radius,
          height: radius! + (lineWidth ?? 5),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: radius,
                  height: radius,
                  // margin: EdgeInsets.only(
                  //     top: lineWidth != null ? lineWidth / 2 : 2.5,
                  //     right: lineWidth != null ? lineWidth : 5),
                  margin: EdgeInsets.all((lineWidth! - (line1Width ?? 2)) / 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.grey[300]!,
                        width: line1Width != null ? lineWidth! / 2 : 2),
                  ),
                ),
              ),
              CircularPercentIndicator(
                radius: radius ?? 0,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: kColorBlue,
                lineWidth: lineWidth ?? 5,
                percent: percent ?? 0,
                center: Center(
                  child: Text(
                    '${(percent! * 100).toInt()}%',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: footer != null ? true : false,
          child: Text(
            footer ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
