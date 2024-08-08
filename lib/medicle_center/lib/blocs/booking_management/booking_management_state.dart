import 'package:united_natives/medicle_center/lib/models/model_booking_item.dart';

abstract class BookingManagementState {}

class BookingListLoading extends BookingManagementState {}

class BookingListSuccess extends BookingManagementState {
  final List<BookingItemModel>? listBooking;
  final List<BookingItemModel>? listRequest;
  final bool? canLoadMoreBooking;
  final bool? canLoadMoreRequest;
  final bool? loadingMoreBooking;
  final bool? loadingMoreRequest;

  BookingListSuccess({
    this.listBooking,
    this.listRequest,
    this.canLoadMoreBooking,
    this.canLoadMoreRequest,
    this.loadingMoreRequest = false,
    this.loadingMoreBooking = false,
  });
}
