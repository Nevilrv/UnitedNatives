import 'package:dio/dio.dart' as dio;

class AddRoomDetailsReqModel {
  String? staffInChargeName;
  String? name;
  String? reason;
  String? date;
  String? time;
  String? image;

  AddRoomDetailsReqModel({
    this.staffInChargeName,
    this.name,
    this.date,
    this.reason,
    this.time,
    this.image,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'staff_incharge_name': staffInChargeName,
      'patient_name': name,
      'patient_reason': reason,
      'patient_admissiondate': date,
      'patient_admissiontime': time,
      'patient_profilepicture': await dio.MultipartFile.fromFile(image!),
    };
  }
}

class UpdateRoomDetailsReqModel {
  String? action;
  String? staffInChargeName;
  String? name;
  String? reason;
  String? date;
  String? time;
  String? image;

  UpdateRoomDetailsReqModel({
    this.action,
    this.staffInChargeName,
    this.name,
    this.date,
    this.reason,
    this.time,
    this.image,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'action': action,
      'staff_incharge_name': staffInChargeName,
      'patient_name': name,
      'patient_reason': reason,
      'patient_admissiondate': date,
      'patient_admissiontime': time,
      'patient_profilepicture': await dio.MultipartFile.fromFile(image!),
    };
  }
}

class UpdateRoomWithoutImgReqModel {
  String? action;
  String? staffInChargeName;
  String? name;
  String? reason;
  String? date;
  String? time;

  UpdateRoomWithoutImgReqModel({
    this.action,
    this.staffInChargeName,
    this.name,
    this.date,
    this.reason,
    this.time,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'action': action,
      'staff_incharge_name': staffInChargeName,
      'patient_name': name,
      'patient_reason': reason,
      'patient_admissiondate': date,
      'patient_admissiontime': time,
    };
  }
}
