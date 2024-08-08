class ClassDetailPatientResponseModel {
  String? status;
  Data? data;
  String? message;

  ClassDetailPatientResponseModel({this.status, this.data, this.message});

  ClassDetailPatientResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? id;
  String? doctorId;
  String? title;
  String? description;
  String? classDate;
  String? classStartTime;
  String? classStartTs;
  String? classEndTime;
  String? classEndTs;
  String? classFeaturedImage;
  String? classAttendees;
  String? classStatus;
  String? created;
  String? modified;
  String? doctorFullName;
  bool? isBooked;
  String? classStatusDisplay;

  Data(
      {this.id,
      this.doctorId,
      this.title,
      this.description,
      this.classDate,
      this.classStartTime,
      this.classStartTs,
      this.classEndTime,
      this.classEndTs,
      this.classFeaturedImage,
      this.classAttendees,
      this.classStatus,
      this.created,
      this.modified,
      this.doctorFullName,
      this.isBooked,
      this.classStatusDisplay});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    title = json['title'];
    description = json['description'];
    classDate = json['class_date'];
    classStartTime = json['class_start_time'];
    classStartTs = json['class_start_ts'];
    classEndTime = json['class_end_time'];
    classEndTs = json['class_end_ts'];
    classFeaturedImage = json['class_featured_image'];
    classAttendees = json['class_attendees'];
    classStatus = json['class_status'];
    created = json['created'];
    modified = json['modified'];
    doctorFullName = json['doctor_full_name'];
    isBooked = json['is_booked'];
    classStatusDisplay = json['class_status_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['title'] = title;
    data['description'] = description;
    data['class_date'] = classDate;
    data['class_start_time'] = classStartTime;
    data['class_start_ts'] = classStartTs;
    data['class_end_time'] = classEndTime;
    data['class_end_ts'] = classEndTs;
    data['class_featured_image'] = classFeaturedImage;
    data['class_attendees'] = classAttendees;
    data['class_status'] = classStatus;
    data['created'] = created;
    data['modified'] = modified;
    data['doctor_full_name'] = doctorFullName;
    data['is_booked'] = isBooked;
    data['class_status_display'] = classStatusDisplay;
    return data;
  }
}
