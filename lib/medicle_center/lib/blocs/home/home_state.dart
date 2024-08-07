import 'package:doctor_appointment_booking/medicle_center/lib/models/model_category.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<String> banner;
  final List<CategoryModel> category;
  final List<CategoryModel> location;
  final List<ProductModel> recent;
  final List<ProductModel> nativeAmericanData;
  final List<ProductModel> americanNativeData;

  HomeSuccess({
    this.banner,
    this.category,
    this.location,
    this.recent,
    this.nativeAmericanData,
    this.americanNativeData,
  });
}
