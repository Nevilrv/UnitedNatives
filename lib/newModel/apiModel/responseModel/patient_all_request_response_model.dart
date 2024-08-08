class AllRequestResponseModel {
  String? status;
  List<Data>? data;
  String? message;

  AllRequestResponseModel({this.status, this.data, this.message});

  AllRequestResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? id;
  String? categoryId;
  String? patientId;
  String? date;
  String? time;
  String? timestamp;
  String? notes;
  String? status;
  String? created;
  String? modified;
  String? categoryTitle;
  String? statusDisplay;

  Data(
      {this.id,
      this.categoryId,
      this.patientId,
      this.date,
      this.time,
      this.timestamp,
      this.notes,
      this.status,
      this.created,
      this.modified,
      this.categoryTitle,
      this.statusDisplay});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    patientId = json['patient_id'];
    date = json['date'];
    time = json['time'];
    timestamp = json['timestamp'];
    notes = json['notes'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    categoryTitle = json['category_title'];
    statusDisplay = json['status_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['patient_id'] = patientId;
    data['date'] = date;
    data['time'] = time;
    data['timestamp'] = timestamp;
    data['notes'] = notes;
    data['status'] = status;
    data['created'] = created;
    data['modified'] = modified;
    data['category_title'] = categoryTitle;
    data['status_display'] = statusDisplay;
    return data;
  }
}
