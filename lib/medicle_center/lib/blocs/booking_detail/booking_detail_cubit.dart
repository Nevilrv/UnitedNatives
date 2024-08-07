import 'package:bloc/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/repository/booking_repository.dart';

import 'cubit.dart';

class BookingDetailCubit extends Cubit<BookingDetailState> {
  BookingDetailCubit() : super(BookingDetailLoading());

  void onLoad(int id) async {
    final result = await BookingRepository.loadDetail(id);
    if (result != null) {
      emit(BookingDetailSuccess(result));
    }
  }

  Future<void> onCancel(int id) async {
    final result = await BookingRepository.cancel(id);
    if (result != null) {
      emit(BookingDetailSuccess(result));
    }
  }
}
