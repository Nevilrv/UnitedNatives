import 'dart:convert';

import 'api_state_enum.dart';

DeleteChatUserResponseModel deleteChatUserResponseModelFromJson(String str) =>
    DeleteChatUserResponseModel.fromJson(json.decode(str));

String deleteChatUserResponseModelToJson(DeleteChatUserResponseModel data) =>
    json.encode(data.toJson());

class DeleteChatUserResponseModel {
  String? status;
  Data? data;
  String? message;
  APIState? apiState;

  DeleteChatUserResponseModel({
    this.status,
    this.data,
    this.message,
  });

  DeleteChatUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (data == null) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }

  // factory DeleteChatUserResponseModel.fromJson(Map<String, dynamic> json) =>
  //     DeleteChatUserResponseModel(
  //       status: json["status"],
  //       data: Data.fromJson(json["data"]),
  //       message: json["message"],
  //     );
  //
  // Map<String, dynamic> toJson() => {
  //       "status": status,
  //       "data": data.toJson(),
  //       "message": message,
  //     };
}

class Data {
  String? status;
  String? message;

  Data({
    this.status,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
