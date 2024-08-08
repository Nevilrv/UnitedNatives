import 'package:dio/dio.dart' as dio;

class AddNewMessageReqModel {
  String? fromType;
  String? fromId;
  String? toType;
  String? toId;
  String? chatKey;
  String? message;
  String? attachment;

  AddNewMessageReqModel(
      {this.fromType,
      this.fromId,
      this.toType,
      this.toId,
      this.chatKey,
      this.message,
      this.attachment});
  Future<Map<String, dynamic>> toJson() async {
    return {
      'from_type': fromType,
      'from_id': fromId,
      'to_id': toId,
      'chat_key': chatKey,
      'message': message,
      'attachment': await dio.MultipartFile.fromFile(attachment!),
    };
  }
}
