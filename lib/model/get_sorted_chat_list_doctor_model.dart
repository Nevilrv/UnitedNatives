import 'api_state_enum.dart';

class GetSortedChatListDoctor {
  String status;
  List<ShortedDoctorChat> doctorChatList;
  String message;
  APIState apiState;

  GetSortedChatListDoctor({this.status, this.doctorChatList, this.message});

  GetSortedChatListDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorChatList = <ShortedDoctorChat>[];
      json['data'].forEach((v) {
        doctorChatList.add(new ShortedDoctorChat.fromJson(v));
        doctorChatList.removeWhere(
            (element) => element.chatKey == null || element.chatKey == "");
      });
    }
    if (doctorChatList.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.doctorChatList != null) {
      data['data'] = this.doctorChatList.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ShortedDoctorChat {
  String chatId;
  String fromType;
  String fromId;
  String toType;
  String toId;
  String message;
  String attachment;
  String chatKey;
  String chatDatetime;
  String doctorProfilePic;
  String doctorSocialProfilePic;
  String patientId;
  String patientFirstName;
  String patientLastName;
  String patientProfilePic;
  String patientSocialProfilePic;
  String bloodGroup;
  String maritalStatus;
  String height;
  String weight;
  String emergencyContact;
  String caseManager;
  String insuranceEligibility;
  String gender;
  String mail;
  String tribalStatus;
  String lastMessage;
  int unreadMessagesCount;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['from_type'] = this.fromType;
    data['from_id'] = this.fromId;
    data['to_type'] = this.toType;
    data['to_id'] = this.toId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['chat_key'] = this.chatKey;
    data['chat_datetime'] = this.chatDatetime;
    data['doctor_profile_pic'] = this.doctorProfilePic;
    data['doctor_social_profile_pic'] = this.doctorSocialProfilePic;
    data['patient_id'] = this.patientId;
    data['patient_first_name'] = this.patientFirstName;
    data['patient_last_name'] = this.patientLastName;
    data['patient_profile_pic'] = this.patientProfilePic;
    data['patient_social_profile_pic'] = this.patientSocialProfilePic;
    data['blood_group'] = this.bloodGroup;
    data['marital_status'] = this.maritalStatus;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['emergency_contact'] = this.emergencyContact;
    data['case_manager'] = this.caseManager;
    data['insurance_eligibility'] = this.insuranceEligibility;
    data['tribal_status'] = this.tribalStatus;
    data['patient_gender'] = this.gender;
    data['patient_email'] = this.mail;

    data['last_message'] = this.lastMessage;
    data['unread_messages_count'] = this.unreadMessagesCount;
    return data;
  }
}
