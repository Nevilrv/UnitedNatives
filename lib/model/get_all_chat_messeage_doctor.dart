import 'package:united_natives/model/api_state_enum.dart';

class GetAllChatMessagesDoctor {
  String? status;
  List<DoctorChat>? doctorChatList;
  String? message;
  APIState? apiState;

  GetAllChatMessagesDoctor({this.status, this.doctorChatList, this.message});

  GetAllChatMessagesDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorChatList = <DoctorChat>[];
      json['data'].forEach((v) {
        doctorChatList?.add(DoctorChat.fromJson(v));
      });
    }
    if (doctorChatList!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (doctorChatList != null) {
      data['data'] = doctorChatList?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DoctorChat {
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

  DoctorChat(
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

  DoctorChat.fromJson(Map<String, dynamic> json) {
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
