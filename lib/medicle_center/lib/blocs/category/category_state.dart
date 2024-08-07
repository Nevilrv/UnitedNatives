import 'package:doctor_appointment_booking/medicle_center/lib/models/model_category.dart';

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryModel> list;
  CategorySuccess(this.list);
}
