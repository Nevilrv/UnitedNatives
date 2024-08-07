import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleModel {
  String view;
  TimeOfDay start;
  TimeOfDay end;

  ScheduleModel({this.view, this.start, this.end});

  get title {
    if (view != null) {
      return view;
    }
    return '$start - $end';
  }

  factory ScheduleModel.fromString(String value) {
    final arr = value.split(" - ");
    return ScheduleModel(
      start: TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(arr[0])),
      end: TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(arr[1])),
    );
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    if (json['start'].toString() == '0') {
      json['start'] = '00:00';
    }
    if (json['end'].toString() == '0') {
      json['end'] = '00:00';
    }
    print('==start[]====>${json['start']}');
    print('==end[]====>${json['end']}');
    return ScheduleModel(
      view: json['format'],
      start: json['start'] == null ||
              json['start'].toString() == 'NULL' ||
              json['start'].toString() == ""
          ? null
          : TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(json['start'])),
      end: json['end'] == null ||
              json['end'].toString() == 'NULL' ||
              json['end'].toString() == ""
          ? null
          : TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(json['end'])),
    );
  }
}
