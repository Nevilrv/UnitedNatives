import 'api_state_enum.dart';

class GetSortedChatListDoctor {
  String? status;
  List<ShortedDoctorChat>? doctorChatList;
  String? message;
  APIState? apiState;

  GetSortedChatListDoctor({this.status, this.doctorChatList, this.message});

  GetSortedChatListDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorChatList = <ShortedDoctorChat>[];
      json['data'].forEach((v) {
        doctorChatList?.add(ShortedDoctorChat.fromJson(v));
        doctorChatList?.removeWhere((element) => element.chatKey == "");
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

class ShortedDoctorChat {
  String? chatId;
  String? fromType;
  String? fromId;
  String? toType;
  String? toId;
  String? message;
  String? attachment;
  String? chatKey;
  String? chatDatetime;
  String? doctorProfilePic;
  String? doctorSocialProfilePic;
  String? patientId;
  String? patientFirstName;
  String? patientLastName;
  String? patientProfilePic;
  String? patientSocialProfilePic;
  String? bloodGroup;
  String? maritalStatus;
  String? height;
  String? weight;
  String? emergencyContact;
  String? caseManager;
  String? insuranceEligibility;
  String? gender;
  String? mail;
  String? tribalStatus;
  String? lastMessage;
  int? unreadMessagesCount;

  ShortedDoctorChat({
    this.chatId,
    this.fromType,
    this.fromId,
    this.toType,
    this.toId,
    this.message,
    this.attachment,
    this.chatKey,
    this.chatDatetime,
    this.doctorProfilePic,
    this.doctorSocialProfilePic,
    this.patientId,
    this.patientFirstName,
    this.patientLastName,
    this.patientProfilePic,
    this.patientSocialProfilePic,
    this.tribalStatus,
    this.bloodGroup,
    this.insuranceEligibility,
    this.height,
    this.caseManager,
    this.emergencyContact,
    this.lastMessage,
    this.maritalStatus,
    this.gender,
    this.mail,
    this.weight,
    this.unreadMessagesCount,
  });

  ShortedDoctorChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    fromType = json['from_type'];
    fromId = json['from_id'];
    toType = json['to_type'];
    toId = json['to_id'];
    message = json['message'];
    attachment = json['attachment'];
    chatKey = json['chat_key'];
    chatDatetime = json['chat_datetime'];
    doctorProfilePic = json['doctor_profile_pic'];
    doctorSocialProfilePic = json['doctor_social_profile_pic'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastName = json['patient_last_name'];
    patientProfilePic = json['patient_profile_pic'];
    patientSocialProfilePic = json['patient_social_profile_pic'];
    bloodGroup = json['blood_group'];
    maritalStatus = json['marital_status'];
    height = json['height'];
    weight = json['weight'];
    emergencyContact = json['emergency_contact'];
    caseManager = json['case_manager'];
    insuranceEligibility = json['insurance_eligibility'];
    tribalStatus = json['tribal_status'];
    gender = json['patient_gender'];
    mail = json['patient_email'];
    lastMessage = json['last_message'];
    unreadMessagesCount = json['unread_messages_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['from_type'] = fromType;
    data['from_id'] = fromId;
    data['to_type'] = toType;
    data['to_id'] = toId;
    data['message'] = message;
    data['attachment'] = attachment;
    data['chat_key'] = chatKey;
    data['chat_datetime'] = chatDatetime;
    data['doctor_profile_pic'] = doctorProfilePic;
    data['doctor_social_profile_pic'] = doctorSocialProfilePic;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_last_name'] = patientLastName;
    data['patient_profile_pic'] = patientProfilePic;
    data['patient_social_profile_pic'] = patientSocialProfilePic;
    data['blood_group'] = bloodGroup;
    data['marital_status'] = maritalStatus;
    data['height'] = height;
    data['weight'] = weight;
    data['emergency_contact'] = emergencyContact;
    data['case_manager'] = caseManager;
    data['insurance_eligibility'] = insuranceEligibility;
    data['tribal_status'] = tribalStatus;
    data['patient_gender'] = gender;
    data['patient_email'] = mail;

    data['last_message'] = lastMessage;
    data['unread_messages_count'] = unreadMessagesCount;
    return data;
  }
}
