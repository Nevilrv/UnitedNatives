import 'package:united_natives/medicle_center/lib/models/model_booking_item.dart';

abstract class BookingDetailState {}

class BookingDetailLoading extends BookingDetailState {}

class BookingDetailSuccess extends BookingDetailState {
  final BookingItemModel item;
  BookingDetailSuccess(this.item);
}
