import 'package:doctor_appointment_booking/medicle_center/lib/configs/application.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_category.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';

class DiscoveryModel {
  final CategoryModel category;
  final List<ProductModel> list;

  DiscoveryModel({
    this.category,
    this.list,
  });

  factory DiscoveryModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryModel(
      category: CategoryModel.fromJson(json),
      list: List.from(json['posts'] ?? []).map((e) {
        return ProductModel.fromJson(e, setting: Application.setting);
      }).toList(),
    );
  }
}
