import 'package:flutter/material.dart';
import 'package:united_natives/utils/utils.dart';

class ProgressIndicatorScreen extends StatelessWidget {
  const ProgressIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Utils.circular(),
      ),
    );
  }
}
