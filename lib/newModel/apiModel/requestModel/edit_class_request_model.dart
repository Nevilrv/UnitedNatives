import 'package:dio/dio.dart' as dio;

class EditClassReqModel {
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? featuredImage;
  EditClassReqModel({
    this.date,
    this.description,
    this.endTime,
    this.featuredImage,
    this.startTime,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'title': title,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'featured_image': featuredImage == null || featuredImage == ''
          ? ''
          : await dio.MultipartFile.fromFile(featuredImage!)
    };
  }
}
