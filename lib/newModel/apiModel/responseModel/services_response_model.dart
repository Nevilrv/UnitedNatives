class ServicesResponseModel {
  String? status;
  List<Data>? data;
  String? message;

  ServicesResponseModel({this.status, this.data, this.message});

  ServicesResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  String? featuredImage;
  String? createdDate;
  String? modifiedDate;

  Data(
      {this.id,
      this.title,
      this.description,
      this.featuredImage,
      this.createdDate,
      this.modifiedDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    featuredImage = json['featured_image'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['featured_image'] = featuredImage;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    return data;
  }
}
