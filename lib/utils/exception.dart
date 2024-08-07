import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppException implements Exception {
  String message, tag;
  int errorCode;

  AppException(
      {required this.message, required this.errorCode, required this.tag});

  int getErrorCode() => errorCode;

  String getMessage() => message;

  String getMessageWithTag() => "$tag : $message";

  String getTag() => tag;

  @override
  String toString() {
    return "${errorCode.toString()} : $tag : $message";
  }

  static dynamic exceptionHandler(exception, [stackTrace]) {
    if (exception is AppException) {
      throw exception;
    } else if (exception is SocketException) {
      throw AppException(
          message: "No Internet connection",
          errorCode: exception.osError?.errorCode ?? 0,
          tag: '');
    } else if (exception is HttpException) {
      throw AppException(
          message: "Couldn't find the requested data", errorCode: 0, tag: '');
    } else if (exception is FormatException) {
      throw AppException(message: "Bad response format", errorCode: 0, tag: '');
    }
    throw AppException(message: "Unknown error", errorCode: 0, tag: '');
  }

  static dynamic showException(exception, [stackTrace]) {
    if (exception is AppException) {
      exception.show();
    } else if (exception is SocketException) {
      AppException(
              message: "No Internet connection",
              errorCode: exception.osError?.errorCode ?? 0,
              tag: '')
          .show();
    } else if (exception is HttpException) {
      AppException(
              message: "Couldn't find the requested data",
              errorCode: 0,
              tag: '')
          .show();
    } else if (exception is FormatException) {
      AppException(message: "Bad response format", errorCode: 0, tag: '')
          .show();
    } else {
      AppException(message: "Unknown error", errorCode: 0, tag: '').show();
    }
  }

  void show() {
    if (getMessage() == 'fail') return;
    Fluttertoast.showToast(
        msg: getMessage(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 18.0);
  }
}
