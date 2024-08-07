import 'package:doctor_appointment_booking/medicle_center/lib/models/model_booking_payment.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_booking_style.dart';

abstract class BookingState {}

class FormLoading extends BookingState {}

class FormSuccess extends BookingState {
  final BookingStyleModel bookingStyle;
  final BookingPaymentModel bookingPayment;

  FormSuccess({
    this.bookingStyle,
    this.bookingPayment,
  });
}
