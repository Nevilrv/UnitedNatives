import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSnackBar {
  static void snackBar({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        padding: const EdgeInsets.only(bottom: 10, left: 20),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        title: '',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
