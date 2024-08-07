import 'package:doctor_appointment_booking/medicle_center/lib/models/model_comment.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_user.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;
  final List<ProductModel> listProduct;
  final List<ProductModel> listProductPending;
  final List<CommentModel> listComment;
  final bool canLoadMore;
  final bool loadingMore;

  ProfileSuccess({
    this.user,
    this.listProduct,
    this.listProductPending,
    this.listComment,
    this.canLoadMore,
    this.loadingMore = false,
  });
}
