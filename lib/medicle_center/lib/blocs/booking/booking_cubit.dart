import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model_result_api.dart';
import 'package:united_natives/medicle_center/lib/repository/booking_repository.dart';

import 'cubit.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(FormLoading());

  ///Init Booking data
  Future<void> initBooking(int id) async {
    final result = await BookingRepository.loadBookingForm(id);
    if (result != null) {
      emit(FormSuccess(
        bookingStyle: result[0],
        bookingPayment: result[1],
      ));
    }
  }

  ///Calc price
  Future<String?> calcPrice({
    int? id,
    FormSuccess? form,
  }) async {
    final params = {
      "resource_id": id,
      ...?form?.bookingStyle?.params,
    };
    return await BookingRepository.calcPrice(params);
  }

  ///Order
  Future<ResultApiModel> order({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? message,
    FormSuccess? form,
  }) async {
    final params = {
      "resource_id": id,
      "payment_method": form?.bookingPayment?.method?.id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "address": address,
      "memo": message,
      ...?form?.bookingStyle?.params,
    };
    return await BookingRepository.order(params);
  }
}
