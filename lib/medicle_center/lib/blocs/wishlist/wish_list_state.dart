import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';

abstract class WishListState {}

class WishListLoading extends WishListState {}

class WishListSuccess extends WishListState {
  final int updateID;
  final List<ProductModel> list;
  final bool canLoadMore;
  final bool loadingMore;

  WishListSuccess({
    this.updateID,
    this.list,
    this.canLoadMore,
    this.loadingMore = false,
  });
}
