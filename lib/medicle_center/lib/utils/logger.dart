import 'dart:developer' as developer;

import 'package:doctor_appointment_booking/medicle_center/lib/configs/application.dart';

class UtilLogger {
  static log([String tag = "LOGGER", dynamic msg]) {
    if (Application.debug) {
      developer.log('$msg', name: tag);
    }
  }

  ///Singleton factory
  static final _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}
