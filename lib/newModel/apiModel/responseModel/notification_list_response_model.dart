class NotificationListResponseModel {
  String status;
  List<Data> data;
  String message;

  NotificationListResponseModel({this.status, this.data, this.message});

  NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String id;
  String type;
  String isRead;
  String relationId;
  String relationType;
  String subject;
  String body;
  String fromUserId;
  String toUserId;
  String pushSend;
  String smsSend;
  String emailSend;
  String pushSendTs;
  String smsSendTs;
  String emailSendTs;
  String status;
  String created;
  String modified;
  dynamic deleted;
  FromUserData fromUserData;
  RelationData relationData;

  Data(
      {this.id,
      this.type,
      this.isRead,
      this.relationId,
      this.relationType,
      this.subject,
      this.body,
      this.fromUserId,
      this.toUserId,
      this.pushSend,
      this.smsSend,
      this.emailSend,
      this.pushSendTs,
      this.smsSendTs,
      this.emailSendTs,
      this.status,
      this.created,
      this.modified,
      this.deleted,
      this.fromUserData,
      this.relationData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "" : json['id'].toString();
    type = json['type'] == null ? "" : json['type'].toString();
    isRead = json['is_read'] == null ? "" : json['is_read'].toString();
    relationId =
        json['relation_id'] == null ? "" : json['relation_id'].toString();
    relationType =
        json['relation_type'] == null ? "" : json['relation_type'].toString();
    subject = json['subject'] == null ? "" : json['subject'].toString();
    body = json['body'] == null ? "" : json['body'].toString();
    fromUserId =
        json['from_user_id'] == null ? "" : json['from_user_id'].toString();
    toUserId = json['to_user_id'] == null ? "" : json['to_user_id'].toString();
    pushSend = json['push_send'] == null ? "" : json['push_send'].toString();
    smsSend = json['sms_send'] == null ? "" : json['sms_send'].toString();
    emailSend = json['email_send'] == null ? "" : json['email_send'].toString();
    pushSendTs =
        json['push_send_ts'] == null ? "" : json['push_send_ts'].toString();
    smsSendTs =
        json['sms_send_ts'] == null ? "" : json['sms_send_ts'].toString();
    emailSendTs =
        json['email_send_ts'] == null ? "" : json['email_send_ts'].toString();
    status = json['status'] == null ? "" : json['status'].toString();
    created = json['created'] == null ? "" : json['created'].toString();
    modified = json['modified'] == null ? "" : json['modified'].toString();
    deleted = json['deleted'] == null ? false : json['deleted'];
    fromUserData = json['from_user_data'] == null
        ? null
        : new FromUserData.fromJson(json['from_user_data']);
    relationData =
        json['relation_data'] == false || json['relation_data'] == null
            ? null
            : RelationData.fromJson(json['relation_data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['is_read'] = this.isRead;
    data['relation_id'] = this.relationId;
    data['relation_type'] = this.relationType;
    data['subject'] = this.subject;
    data['body'] = this.body;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['push_send'] = this.pushSend;
    data['sms_send'] = this.smsSend;
    data['email_send'] = this.emailSend;
    data['push_send_ts'] = this.pushSendTs;
    data['sms_send_ts'] = this.smsSendTs;
    data['email_send_ts'] = this.emailSendTs;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['deleted'] = this.deleted;
    if (this.fromUserData != null) {
      data['from_user_data'] = this.fromUserData.toJson();
    }
    if (this.relationData != null) {
      data['relation_data'] = this.relationData.toJson();
    }
    return data;
  }
}

class FromUserData {
  String id;
  String firstName;
  String lastName;
  String gender;
  String email;
  String contactNumber;
  String dateOfBirth;
  String socialProfilePic;
  String profilePic;
  ChatData chatData;

  FromUserData(
      {this.id,
      this.firstName,
      this.lastName,
      this.gender,
      this.email,
      this.contactNumber,
      this.dateOfBirth,
      this.socialProfilePic,
      this.profilePic,
      this.chatData});

  FromUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "" : json['id'].toString();
    firstName = json['first_name'] == null ? "" : json['first_name'].toString();
    lastName = json['last_name'] == null ? "" : json['last_name'].toString();
    gender = json['gender'] == null ? "" : json['gender'].toString();
    email = json['email'] == null ? "" : json['email'].toString();
    contactNumber =
        json['contact_number'] == null ? "" : json['contact_number'].toString();
    dateOfBirth =
        json['date_of_birth'] == null ? "" : json['date_of_birth'].toString();
    socialProfilePic = json['social_profile_pic'] == null
        ? ""
        : json['social_profile_pic'].toString();
    profilePic =
        json['profile_pic'] == null ? "" : json['profile_pic'].toString();
    chatData =
        json['chat_data'] != null ? ChatData.fromJson(json['chat_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['date_of_birth'] = this.dateOfBirth;
    data['social_profile_pic'] = this.socialProfilePic;
    data['profile_pic'] = this.profilePic;
    if (this.chatData != null) {
      data['chat_data'] = this.chatData.toJson();
    }
    return data;
  }
}

class ChatData {
  String id;
  String chatKey;

  ChatData({
    this.id,
    this.chatKey,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        id: json["id"] ?? "",
        chatKey: json["chat_key"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chat_key": chatKey,
      };
}

class RelationData {
  String id;
  String patientId;
  String doctorId;
  String appointmentType;
  String appointmentDate;
  String appointmentTime;
  String appointmentStatus;
  String createdDate;
  String modifiedDate;
  String appointmentId;
  String treatmentDays;
  String pillsPerDay;
  String created;
  String modified;
  String fromUserId;
  String toUserId;
  String meetingId;
  String meetingPassword;
  String meetingStatus;

  RelationData(
      {this.id,
      this.patientId,
      this.doctorId,
      this.appointmentType,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentStatus,
      this.createdDate,
      this.modifiedDate,
      this.appointmentId,
      this.treatmentDays,
      this.pillsPerDay,
      this.created,
      this.modified,
      this.fromUserId,
      this.toUserId,
      this.meetingId,
      this.meetingPassword,
      this.meetingStatus});

  RelationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "" : json['id'].toString();
    patientId = json['patient_id'] == null ? "" : json['patient_id'].toString();
    doctorId = json['doctor_id'] == null ? "" : json['doctor_id'].toString();
    appointmentType = json['appointment_type'] == null
        ? ""
        : json['appointment_type'].toString();
    appointmentDate = json['appointment_date'] == null
        ? ""
        : json['appointment_date'].toString();
    appointmentTime = json['appointment_time'] == null
        ? ""
        : json['appointment_time'].toString();
    appointmentStatus = json['appointment_status'] == null
        ? ""
        : json['appointment_status'].toString();
    createdDate =
        json['created_date'] == null ? "" : json['created_date'].toString();
    modifiedDate =
        json['modified_date'] == null ? "" : json['modified_date'].toString();
    appointmentId =
        json['appointment_id'] == null ? "" : json['appointment_id'].toString();
    treatmentDays =
        json['treatment_days'] == null ? "" : json['treatment_days'].toString();
    pillsPerDay =
        json['pills_per_day'] == null ? "" : json['pills_per_day'].toString();
    created = json['created'] == null ? "" : json['created'].toString();
    modified = json['modified'] == null ? "" : json['modified'].toString();
    fromUserId =
        json['from_user_id'] == null ? "" : json['from_user_id'].toString();
    toUserId = json['to_user_id'] == null ? "" : json['to_user_id'].toString();
    meetingId = json['meeting_id'] == null ? "" : json['meeting_id'].toString();
    meetingPassword = json['meeting_password'] == null
        ? ""
        : json['meeting_password'].toString();
    meetingStatus =
        json['meeting_status'] == null ? "" : json['meeting_status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['appointment_type'] = this.appointmentType;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_status'] = this.appointmentStatus;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    data['appointment_id'] = this.appointmentId;
    data['treatment_days'] = this.treatmentDays;
    data['pills_per_day'] = this.pillsPerDay;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['meeting_id'] = this.meetingId;
    data['meeting_password'] = this.meetingPassword;
    data['meeting_status'] = this.meetingStatus;
    return data;
  }
}

// // To parse this JSON data, do
// //
// //     final notificationListResponseModel = notificationListResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// NotificationListResponseModel notificationListResponseModelFromJson(
//         String str) =>
//     NotificationListResponseModel.fromJson(json.decode(str));
//
// String notificationListResponseModelToJson(
//         NotificationListResponseModel data) =>
//     json.encode(data.toJson());
//
// class NotificationListResponseModel {
//   NotificationListResponseModel({
//     this.status,
//     this.data,
//     this.message,
//   });
//
//   String status;
//   List<Datum> data;
//   String message;
//
//   factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) =>
//       json["status"] == 'Fail'
//           ? NotificationListResponseModel(
//               status: json["status"] == null ? null : json["status"],
//               message: json["message"] == null ? null : json["message"],
//             )
//           : NotificationListResponseModel(
//               status: json["status"] == null ? null : json["status"],
//               data: json["data"] == null
//                   ? null
//                   : List<Datum>.from(
//                       json["data"].map((x) => Datum.fromJson(x))),
//               message: json["message"] == null ? null : json["message"],
//             );
//
//   Map<String, dynamic> toJson() => {
//         "status": status == null ? null : status,
//         "data": data == null
//             ? null
//             : List<dynamic>.from(data.map((x) => x.toJson())),
//         "message": message == null ? null : message,
//       };
// }
//
// class Datum {
//   Datum({
//     this.id,
//     this.type,
//     this.isRead,
//     this.relationId,
//     this.relationType,
//     this.subject,
//     this.body,
//     this.fromUserId,
//     this.toUserId,
//     this.pushSend,
//     this.smsSend,
//     this.emailSend,
//     this.pushSendTs,
//     this.smsSendTs,
//     this.emailSendTs,
//     this.created,
//     this.modified,
//     this.fromUserData,
//     this.relationData,
//   });
//
//   String id;
//   String type;
//   String isRead;
//   String relationId;
//   String relationType;
//   String subject;
//   String body;
//   String fromUserId;
//   String toUserId;
//   String pushSend;
//   String smsSend;
//   String emailSend;
//   dynamic pushSendTs;
//   dynamic smsSendTs;
//   dynamic emailSendTs;
//   DateTime created;
//   DateTime modified;
//   FromUserData fromUserData;
//   RelationData relationData;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"] == null ? null : json["id"],
//         type: json["type"] == null ? null : json["type"],
//         isRead: json["is_read"] == null ? null : json["is_read"],
//         relationId: json["relation_id"] == null ? null : json["relation_id"],
//         relationType:
//             json["relation_type"] == null ? null : json["relation_type"],
//         subject: json["subject"] == null ? null : json["subject"],
//         body: json["body"] == null ? null : json["body"],
//         fromUserId: json["from_user_id"] == null ? null : json["from_user_id"],
//         toUserId: json["to_user_id"] == null ? null : json["to_user_id"],
//         pushSend: json["push_send"] == null ? null : json["push_send"],
//         smsSend: json["sms_send"] == null ? null : json["sms_send"],
//         emailSend: json["email_send"] == null ? null : json["email_send"],
//         pushSendTs: json["push_send_ts"],
//         smsSendTs: json["sms_send_ts"],
//         emailSendTs: json["email_send_ts"],
//         created:
//             json["created"] == null ? null : DateTime.parse(json["created"]),
//         modified:
//             json["modified"] == null ? null : DateTime.parse(json["modified"]),
//         fromUserData: json["from_user_data"] == null
//             ? null
//             : FromUserData.fromJson(json["from_user_data"]),
//         relationData: json["relation_data"] == false
//             ? null
//             : RelationData.fromJson(json["relation_data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "type": type == null ? null : type,
//         "is_read": isRead == null ? null : isRead,
//         "relation_id": relationId == null ? null : relationId,
//         "relation_type": relationType == null ? null : relationType,
//         "subject": subject == null ? null : subject,
//         "body": body == null ? null : body,
//         "from_user_id": fromUserId == null ? null : fromUserId,
//         "to_user_id": toUserId == null ? null : toUserId,
//         "push_send": pushSend == null ? null : pushSend,
//         "sms_send": smsSend == null ? null : smsSend,
//         "email_send": emailSend == null ? null : emailSend,
//         "push_send_ts": pushSendTs,
//         "sms_send_ts": smsSendTs,
//         "email_send_ts": emailSendTs,
//         "created": created == null ? null : created.toIso8601String(),
//         "modified": modified == null ? null : modified.toIso8601String(),
//         "from_user_data": fromUserData == null ? null : fromUserData.toJson(),
//         "relation_data": relationData == false ? null : relationData.toJson(),
//       };
// }
//
// class FromUserData {
//   FromUserData({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.gender,
//     this.email,
//     this.contactNumber,
//     this.dateOfBirth,
//     this.socialProfilePic,
//     this.profilePic,
//   });
//
//   String id;
//   String firstName;
//   String lastName;
//   String gender;
//   String email;
//   String contactNumber;
//   DateTime dateOfBirth;
//   dynamic socialProfilePic;
//   String profilePic;
//
//   factory FromUserData.fromJson(Map<String, dynamic> json) => FromUserData(
//         id: json["id"] == null ? null : json["id"],
//         firstName: json["first_name"] == null ? null : json["first_name"],
//         lastName: json["last_name"] == null ? null : json["last_name"],
//         gender: json["gender"] == null ? null : json["gender"],
//         email: json["email"] == null ? null : json["email"],
//         contactNumber:
//             json["contact_number"] == null ? null : json["contact_number"],
//         dateOfBirth: json["date_of_birth"] == null
//             ? null
//             : DateTime.parse(json["date_of_birth"]),
//         socialProfilePic: json["social_profile_pic"],
//         profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "first_name": firstName == null ? null : firstName,
//         "last_name": lastName == null ? null : lastName,
//         "gender": gender == null ? null : gender,
//         "email": email == null ? null : email,
//         "contact_number": contactNumber == null ? null : contactNumber,
//         "date_of_birth": dateOfBirth == null
//             ? null
//             : "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
//         "social_profile_pic": socialProfilePic,
//         "profile_pic": profilePic == null ? null : profilePic,
//       };
// }
//
// class RelationData {
//   RelationData({
//     this.id,
//     this.fromUserId,
//     this.toUserId,
//     this.meetingId,
//     this.meetingPassword,
//     this.meetingStatus,
//     this.created,
//     this.modified,
//   });
//
//   String id;
//   String fromUserId;
//   String toUserId;
//   String meetingId;
//   String meetingPassword;
//   String meetingStatus;
//   DateTime created;
//   DateTime modified;
//
//   factory RelationData.fromJson(Map<String, dynamic> json) => RelationData(
//         id: json["id"] == null ? null : json["id"],
//         fromUserId: json["from_user_id"] == null ? null : json["from_user_id"],
//         toUserId: json["to_user_id"] == null ? null : json["to_user_id"],
//         meetingId: json["meeting_id"] == null ? null : json["meeting_id"],
//         meetingPassword:
//             json["meeting_password"] == null ? null : json["meeting_password"],
//         meetingStatus:
//             json["meeting_status"] == null ? null : json["meeting_status"],
//         created:
//             json["created"] == null ? null : DateTime.parse(json["created"]),
//         modified:
//             json["modified"] == null ? null : DateTime.parse(json["modified"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "from_user_id": fromUserId == null ? null : fromUserId,
//         "to_user_id": toUserId == null ? null : toUserId,
//         "meeting_id": meetingId == null ? null : meetingId,
//         "meeting_password": meetingPassword == null ? null : meetingPassword,
//         "meeting_status": meetingStatus == null ? null : meetingStatus,
//         "created": created == null ? null : created.toIso8601String(),
//         "modified": modified == null ? null : modified.toIso8601String(),
//       };
// }
