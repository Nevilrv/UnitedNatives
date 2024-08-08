class RequestListResponseModel {
  String? status;
  List<Data>? data;
  String? message;

  RequestListResponseModel({this.status, this.data, this.message});

  RequestListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? featuredImage;
  String? created;
  String? modified;

  Data({this.id, this.title, this.featuredImage, this.created, this.modified});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featured_image'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['featured_image'] = featuredImage;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}
