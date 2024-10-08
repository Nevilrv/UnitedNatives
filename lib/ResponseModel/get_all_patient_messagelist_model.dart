import 'api_state_enum.dart';

class GetAllPatientChatMessages {
  String? status;
  List<PatientChat>? patientChatList;
  String? message;
  APIState? apiState;

  GetAllPatientChatMessages({this.status, this.patientChatList, this.message});

  GetAllPatientChatMessages.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      patientChatList = <PatientChat>[];
      json['data'].forEach((v) {
        patientChatList?.add(PatientChat.fromJson(v));
      });
    }
    if (patientChatList!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (patientChatList != null) {
      data['data'] = patientChatList?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PatientChat {
  String? id;
  String? fromType;
  String? fromId;
  String? toType;
  String? toId;
  String? message;
  String? attachment;
  String? chatKey;
  String? created;
  String? modified;

  PatientChat(
      {this.id,
      this.fromType,
      this.fromId,
      this.toType,
      this.toId,
      this.message,
      this.attachment,
      this.chatKey,
      this.created,
      this.modified});

  PatientChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromType = json['from_type'];
    fromId = json['from_id'];
    toType = json['to_type'];
    toId = json['to_id'];
    message = json['message'];
    attachment = json['attachment'];
    chatKey = json['chat_key'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_type'] = fromType;
    data['from_id'] = fromId;
    data['to_type'] = toType;
    data['to_id'] = toId;
    data['message'] = message;
    data['attachment'] = attachment;
    data['chat_key'] = chatKey;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}
