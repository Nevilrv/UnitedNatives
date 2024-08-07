import 'package:dio/dio.dart' as dio;

class AddClassReqModel {
  String doctorId;
  String title;
  String description;
  String date;
  String startTime;
  String endTime;
  String featuredImage;
  String streaming;
  AddClassReqModel({
    this.title,
    this.date,
    this.description,
    this.endTime,
    this.featuredImage,
    this.startTime,
    this.streaming,
  });
  Future<Map<String, dynamic>> toJson() async {
    return {
      'doctor_id': doctorId,
      'title': title,
      'description': description,
      'date': date,
      'start_time': startTime,
      'streaming': streaming,
      'end_time': endTime,
      'featured_image': await dio.MultipartFile.fromFile(featuredImage)
      // 'featured_image': await dio.MultipartFile.fromFile(featuredImage)
    };
  }
}
