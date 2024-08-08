import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

IntakeFormResponseModel intakeFormResponseModelFromJson(String str) =>
    IntakeFormResponseModel.fromJson(json.decode(str));

String intakeFormResponseModelToJson(IntakeFormResponseModel data) =>
    json.encode(data.toJson());

class IntakeFormResponseModel {
  bool? success;
  FromDataTemp? data;

  IntakeFormResponseModel({
    this.success,
    this.data,
  });

  factory IntakeFormResponseModel.fromJson(Map<String, dynamic> json) =>
      IntakeFormResponseModel(
        success: json["success"],
        data: FromDataTemp.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class FromDataTemp {
  List<FormParam>? formParams;

  FromDataTemp({
    this.formParams,
  });

  factory FromDataTemp.fromJson(Map<String, dynamic> json) => FromDataTemp(
        formParams: json["form_params"] == null ||
                json["form_params"].isEmpty ||
                json["form_params"] == []
            ? null
            : List<FormParam>.from(
                json["form_params"].map((x) => FormParam.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "form_params": List<dynamic>.from(formParams!.map((x) => x.toJson())),
      };
}

class FormParam {
  String? label;
  String? key;
  String? type;
  String? isRequired;
  TextEditingController? controller;
  String? path;

  FormParam(
      {this.label,
      this.key,
      this.type,
      this.isRequired,
      this.controller,
      this.path});

  factory FormParam.fromJson(Map<String, dynamic> json) => FormParam(
        label: json["label"],
        key: json["key"],
        type: json["type"],
        isRequired: json["is_required"].isEmpty ? "false" : json["is_required"],
        controller: TextEditingController(
            text: json["type"] == "date"
                ? DateFormat('MM/dd/yyyy').format(DateTime.now())
                : json["controller"] ?? ""),
        path: json["path"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "key": key,
        "type": type,
        "path": path,
        "is_required": isRequired,
        "controller": controller,
      };
}
