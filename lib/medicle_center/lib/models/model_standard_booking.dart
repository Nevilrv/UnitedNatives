import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model_booking_style.dart';

class StandardBookingModel extends BookingStyleModel {
  DateTime? startDate;
  TimeOfDay? startTime;

  StandardBookingModel({
    price,
    adult,
    children,
    this.startDate,
    this.startTime,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    return {
      'booking_style': 'standard',
      'adult': adult,
      'children': children,
      'start_date': startDate,
      'start_time': startTime,
    };
  }

  factory StandardBookingModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? startTime;
    if (json['start_time'] != null) {
      startTime = TimeOfDay.fromDateTime(
        DateFormat('hh:mm').parse(json['start_time']),
      );
    }
    return StandardBookingModel(
      price: json['price'] as String,
      startDate: DateTime.tryParse(json['start_date']),
      startTime: startTime,
    );
  }
}
