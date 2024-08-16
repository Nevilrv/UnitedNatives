import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/newModel/repo/reminder_response_model.dart';
import 'package:united_natives/pages/reminder2/sqflite_database_helper.dart';

class RemindersController extends GetxController {
  final dbHelper = DatabaseHelper();
  List<RemindersResponseModel> reminders = [];
  bool getData = false;

  getAllReminders() async {
    getData = true;
    reminders = [];
    update();
    final fetchDetailsData = await dbHelper.getDataFromTable();
    if (fetchDetailsData.isNotEmpty) {
      reminders = List<RemindersResponseModel>.from(
          fetchDetailsData.map((x) => RemindersResponseModel.fromJson(x)));
    }
    getData = false;
    update();
  }

  deleteReminder(int id, BuildContext context) async {
    await dbHelper.deleteMedicineReminder(id).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Reminder deleted',
              style: TextStyle(fontSize: 18),
            ),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
