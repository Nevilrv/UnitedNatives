import 'package:doctor_appointment_booking/medicle_center/lib/models/model_image.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/color.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/icon.dart';
import 'package:flutter/cupertino.dart';

enum CategoryType { category, location, feature }

class CategoryModel {
  final int id;
  final String title;
  final int count;
  final ImageModel image;
  final IconData icon;
  final Color color;
  final CategoryType type;
  final bool hasChild;

  CategoryModel({
    this.id,
    this.title,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.type = CategoryType.category,
    this.hasChild = false,
  });

  @override
  bool operator ==(Object other) => other is CategoryModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    CategoryType categoryType = CategoryType.category;
    ImageModel image;
    if (json['image'] != null) {
      image = json['image'] == null
          ? ImageModel(id: 0, full: json['image'], thumb: json['image'])
          : json['image'].runtimeType == String
              ? ImageModel(id: 0, full: json['image'], thumb: json['image'])
              : ImageModel.fromJson(json['image']);
    }
    if (json['taxonomy'] == 'listar_feature') {
      categoryType = CategoryType.feature;
    }
    if (json['taxonomy'] == 'listar_location') {
      categoryType = CategoryType.location;
    }
    final icon = UtilIcon.getIconFromCss(json['icon']);
    final color = UtilColor.getColorFromHex(json['color']);
    return CategoryModel(
      id: json['term_id'] ?? json['id'] ?? 0,
      title: json['name'] ?? 'Unknown',
      count: json['count'] ?? 0,
      // image:  ImageModel(id: 10,thumb:"https://medicalcenter.sataware.dev/wp-content/uploads/2020/05/service-automotive-150x150.jpg}, medium: {url: https://medicalcenter.sataware.dev/wp-content/uploads/2020/05/service-automotive-300x200.jpg",full:"https://medicalcenter.sataware.dev/wp-content/uploads/2020/05/service-automotive-1024x682.jpg"  ),
      image: image,
      icon: icon,
      color: color,
      type: categoryType,
      hasChild: json['has_child'] ?? false,
    );
  }
}
