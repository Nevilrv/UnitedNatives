import 'dart:async';
import 'package:get/get.dart';

class AdsController extends GetxController {
  bool adShow = true;
  Timer _timer;
  timer() {
    const oneDecimal = const Duration(minutes: 15);
    _timer = Timer.periodic(oneDecimal, (Timer timer) {
      adShow = true;
      _timer.cancel();
      update();
    });
  }
}
