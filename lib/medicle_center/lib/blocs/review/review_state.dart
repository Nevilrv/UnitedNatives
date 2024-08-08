import 'package:doctor_appointment_booking/medicle_center/lib/models/model_comment.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_rate.dart';
import 'package:united_natives/medicle_center/lib/models/model_comment.dart';
import 'package:united_natives/medicle_center/lib/models/model_rate.dart';

abstract class ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final int? id;
  final List<CommentModel>? list;
  final RateModel? rate;

  ReviewSuccess({
    this.id,
    this.list,
    this.rate,
  });
}
