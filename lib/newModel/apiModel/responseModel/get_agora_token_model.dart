// To parse this JSON data, do
//
//     final getAgoraToken = getAgoraTokenFromJson(jsonString);

import 'dart:convert';

GetAgoraToken getAgoraTokenFromJson(String str) =>
    GetAgoraToken.fromJson(json.decode(str));

String getAgoraTokenToJson(GetAgoraToken data) => json.encode(data.toJson());

class GetAgoraToken {
  GetAgoraToken({
    this.status,
    this.data,
    this.message,
  });

  String status;
  Data data;
  String message;

  factory GetAgoraToken.fromJson(Map<String, dynamic> json) => GetAgoraToken(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.channelName,
    this.token,
  });

  String channelName;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        channelName: json["channel_name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "channel_name": channelName,
        "token": token,
      };
}
