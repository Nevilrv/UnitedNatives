import 'package:doctor_appointment_booking/medicle_center/lib/api/api.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_comment.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_rate.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_result_api.dart';

class ReviewRepository {
  ///Fetch api getReview
  static Future<List> loadReview(id) async {
    final response = await Api.requestReview({"post_id": id});
    if (response.success) {
      final listComment = List.from(response.data ?? []).map((item) {
        return CommentModel.fromJson(item);
      }).toList();
      final rate = RateModel.fromJson(response.attr['rating']);
      return [listComment, rate];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///Fetch save review
  static Future<bool> saveReview({
    int id,
    String content,
    double rate,
  }) async {
    final params = {
      "post": id,
      "content": content,
      "rating": rate,
    };
    final response = await Api.requestSaveReview(params);
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch author review
  static Future<ResultApiModel> loadAuthorReview({
    int page,
    int perPage,
    String keyword,
    int userID,
  }) async {
    Map<String, dynamic> params = {
      "page": page,
      "per_page": perPage,
      "s": keyword,
      "user_id": userID,
    };
    return await Api.requestAuthorReview(params);
  }
}
