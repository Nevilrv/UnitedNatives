class ClassDetailDoctorResponseModel {
  String status;
  Data data;
  String message;

  ClassDetailDoctorResponseModel({this.status, this.data, this.message});

  ClassDetailDoctorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String id;
  String doctorId;
  String title;
  String description;
  String classDate;
  String classStartTime;
  String classStartTs;
  String classEndTime;
  String classEndTs;
  String classFeaturedImage;
  String classAttendees;
  String classStatus;
  String createdDate;
  String modifiedDate;
  String classStatusDisplay;

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
      this.createdDate,
      this.modifiedDate,
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
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    classStatusDisplay = json['class_status_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['class_date'] = this.classDate;
    data['class_start_time'] = this.classStartTime;
    data['class_start_ts'] = this.classStartTs;
    data['class_end_time'] = this.classEndTime;
    data['class_end_ts'] = this.classEndTs;
    data['class_featured_image'] = this.classFeaturedImage;
    data['class_attendees'] = this.classAttendees;
    data['class_status'] = this.classStatus;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    data['class_status_display'] = this.classStatusDisplay;
    return data;
  }
}
