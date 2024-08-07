import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';

abstract class ListState {}

class ListLoading extends ListState {}

class ListSuccess extends ListState {
  final List<ProductModel> list;
  final bool canLoadMore;
  final bool loadingMore;

  ListSuccess({
    this.list,
    this.canLoadMore,
    this.loadingMore = false,
  });
}
