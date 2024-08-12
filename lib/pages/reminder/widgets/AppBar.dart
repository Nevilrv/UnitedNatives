import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
    required this.greenColor,
  });

  final Color greenColor;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      color: greenColor,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          Text(
            'Reminders',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: deviceWidth * .09,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
