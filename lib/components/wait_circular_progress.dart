import 'package:flutter/material.dart';
import 'package:united_natives/utils/utils.dart';

class WaitCircularProgress extends StatelessWidget {
  final String? title;

  const WaitCircularProgress({super.key, @required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 30,
            height: 30,
            child: Utils.circular(),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins-Medium',
            ),
          ),
        ],
      ),
    );
  }
}
