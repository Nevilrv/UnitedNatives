import 'package:doctor_appointment_booking/medicle_center/lib/models/model_city_data.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_state_data.dart';

abstract class FilterState {}

class InitialFilterState extends FilterState {}

class FilterLoading extends FilterState {}

class FilterSuccess extends FilterState {
  List<StateModel> stateList;
  List<CityModel> cityList;

  FilterSuccess({this.stateList, this.cityList});
}
