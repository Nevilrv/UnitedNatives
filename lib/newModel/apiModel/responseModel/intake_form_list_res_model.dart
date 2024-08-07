import 'dart:convert';

IntakeFormListResponseModel intakeFormListResponseModelFromJson(String str) =>
    IntakeFormListResponseModel.fromJson(json.decode(str));

String intakeFormListResponseModelToJson(IntakeFormListResponseModel data) =>
    json.encode(data.toJson());

class IntakeFormListResponseModel {
  bool success;
  Data data;

  IntakeFormListResponseModel({
    this.success,
    this.data,
  });

  factory IntakeFormListResponseModel.fromJson(Map<String, dynamic> json) =>
      IntakeFormListResponseModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  List<Form> forms;

  Data({
    this.forms,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        forms: List<Form>.from(json["forms"].map((x) => Form.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "forms": List<dynamic>.from(forms.map((x) => x.toJson())),
      };
}

class Form {
  int id;
  String postAuthor;
  DateTime postDate;
  DateTime postDateGmt;
  String postContent;
  String postTitle;
  String postExcerpt;
  String postStatus;
  String commentStatus;
  String pingStatus;
  String postPassword;
  String postName;
  String toPing;
  String pinged;
  DateTime postModified;
  DateTime postModifiedGmt;
  String postContentFiltered;
  int postParent;
  String guid;
  int menuOrder;
  String postType;
  String postMimeType;
  String commentCount;
  String filter;
  bool isDone;
  String userStatus;

  Form({
    this.id,
    this.userStatus,
    this.isDone,
    this.postAuthor,
    this.postDate,
    this.postDateGmt,
    this.postContent,
    this.postTitle,
    this.postExcerpt,
    this.postStatus,
    this.commentStatus,
    this.pingStatus,
    this.postPassword,
    this.postName,
    this.toPing,
    this.pinged,
    this.postModified,
    this.postModifiedGmt,
    this.postContentFiltered,
    this.postParent,
    this.guid,
    this.menuOrder,
    this.postType,
    this.postMimeType,
    this.commentCount,
    this.filter,
  });

  factory Form.fromJson(Map<String, dynamic> json) => Form(
        id: json["ID"],
        isDone: json["isDone"] ?? false,
        postAuthor: json["post_author"],
        postDate: DateTime.parse(json["post_date"]),
        postDateGmt: DateTime.parse(json["post_date_gmt"]),
        postContent: json["post_content"],
        postTitle: json["post_title"],
        postExcerpt: json["post_excerpt"],
        postStatus: json["post_status"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        postPassword: json["post_password"],
        postName: json["post_name"],
        toPing: json["to_ping"],
        pinged: json["pinged"],
        postModified: DateTime.parse(json["post_modified"]),
        postModifiedGmt: DateTime.parse(json["post_modified_gmt"]),
        postContentFiltered: json["post_content_filtered"],
        postParent: json["post_parent"],
        guid: json["guid"],
        menuOrder: json["menu_order"],
        postType: json["post_type"],
        postMimeType: json["post_mime_type"],
        commentCount: json["comment_count"],
        filter: json["filter"],
        userStatus: json["user_status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "isDone": isDone,
        "post_author": postAuthor,
        "post_date": postDate.toIso8601String(),
        "post_date_gmt": postDateGmt.toIso8601String(),
        "post_content": postContent,
        "post_title": postTitle,
        "post_excerpt": postExcerpt,
        "post_status": postStatus,
        "comment_status": commentStatus,
        "ping_status": pingStatus,
        "post_password": postPassword,
        "post_name": postName,
        "to_ping": toPing,
        "pinged": pinged,
        "post_modified": postModified.toIso8601String(),
        "post_modified_gmt": postModifiedGmt.toIso8601String(),
        "post_content_filtered": postContentFiltered,
        "post_parent": postParent,
        "guid": guid,
        "menu_order": menuOrder,
        "post_type": postType,
        "post_mime_type": postMimeType,
        "comment_count": commentCount,
        "filter": filter,
        "user_status": userStatus,
      };
}
