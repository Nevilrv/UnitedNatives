import 'api_state_enum.dart';

class GetSortedPatientChatListModel {
  String status;
  List<SortedPatientChat> data;
  String message;
  APIState apiState;

  GetSortedPatientChatListModel({this.status, this.data, this.message});

  GetSortedPatientChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SortedPatientChat>[];
      json['data'].forEach((v) {
        data.add(new SortedPatientChat.fromJson(v));
      });
    }
    message = json['message'];
    if (data.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
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

class SortedPatientChat {
  String chatId;
  String fromType;
  String fromId;
  String toType;
  String toId;
  String message;
  String attachment;
  String chatKey;
  String chatDatetime;
  String patientProfilePic;
  String patientSocialProfilePic;
  String doctorId;
  String doctorFirstName;
  String doctorLastName;
  String doctorProfilePic;
  String doctorSocialProfilePic;
  String lastMessage;
  int unreadMessagesCount;

  SortedPatientChat({
    this.chatId,
    this.fromType,
    this.fromId,
    this.toType,
    this.toId,
    this.message,
    this.attachment,
    this.chatKey,
    this.chatDatetime,
    this.patientProfilePic,
    this.patientSocialProfilePic,
    this.doctorId,
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorProfilePic,
    this.doctorSocialProfilePic,
    this.lastMessage,
    this.unreadMessagesCount,
  });

  SortedPatientChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    fromType = json['from_type'];
    fromId = json['from_id'];
    toType = json['to_type'];
    toId = json['to_id'];
    message = json['message'];
    attachment = json['attachment'];
    chatKey = json['chat_key'];
    chatDatetime = json['chat_datetime'];
    patientProfilePic = json['patient_profile_pic'];
    patientSocialProfilePic = json['patient_social_profile_pic'];
    doctorId = json['doctor_id'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctorProfilePic = json['doctor_profile_pic'];
    doctorSocialProfilePic = json['doctor_social_profile_pic'];
    lastMessage = json['last_message'];
    unreadMessagesCount = json['unread_messages_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['from_type'] = this.fromType;
    data['from_id'] = this.fromId;
    data['to_type'] = this.toType;
    data['to_id'] = this.toId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['chat_key'] = this.chatKey;
    data['chat_datetime'] = this.chatDatetime;
    data['patient_profile_pic'] = this.patientProfilePic;
    data['patient_social_profile_pic'] = this.patientSocialProfilePic;
    data['doctor_id'] = this.doctorId;
    data['doctor_first_name'] = this.doctorFirstName;
    data['doctor_last_name'] = this.doctorLastName;
    data['doctor_profile_pic'] = this.doctorProfilePic;
    data['doctor_social_profile_pic'] = this.doctorSocialProfilePic;
    data['last_message'] = this.lastMessage;
    data['unread_messages_count'] = this.unreadMessagesCount;
    return data;
  }
}
