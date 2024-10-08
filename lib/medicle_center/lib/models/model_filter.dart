import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_sort.dart';
import 'package:united_natives/medicle_center/lib/utils/utils_medicalcenter.dart';
import 'package:flutter/material.dart';

class FilterModel {
  final List<CategoryModel>? categories;
  final List<CategoryModel>? features;
  CategoryModel? country;
  CategoryModel? city;
  CategoryModel? state;
  double? distance;
  double? minPrice;
  double? maxPrice;
  String? color;
  SortModel? sort;
  TimeOfDay? startHour;
  TimeOfDay? endHour;

  FilterModel({
    this.categories,
    this.features,
    this.country,
    this.city,
    this.state,
    this.distance,
    this.minPrice,
    this.maxPrice,
    this.color,
    this.sort,
    this.startHour,
    this.endHour,
  });

  Future<Map<String, dynamic>> getParams() async {
    final location = await UtilsMedicalCenter.getLocation();

    Map<String, dynamic> params = {
      "category[]": categories?.map((item) {
        return item.id;
      }).toList(),
      "feature[]": features?.map((item) {
        return item.id;
      }).toList(),
    };
    if (country != null) {
      params['location'] = country?.id;
    }
    if (city != null) {
      params['location'] = city?.id;
    }
    if (state != null) {
      params['location'] = state?.id;
    }
    if (distance != null) {
      params['distance'] = distance;
    }
    if (minPrice != null) {
      params['price_min'] = minPrice;
    }
    if (maxPrice != null) {
      params['price_max'] = minPrice;
    }
    if (color != null) {
      params['color'] = color;
    }
    if (sort != null) {
      params['orderby'] = sort?.field;
      params['order'] = sort?.value;
    }
    if (startHour != null) {
      params['start_time'] = startHour.toString();
    }
    if (endHour != null) {
      params['end_time'] = endHour.toString();
    }
    if (location != null) {
      params['latitude'] = location.latitude;
      params['longitude'] = location.longitude;
    }
    return params;
  }

  factory FilterModel.fromDefault() {
    return FilterModel(
      categories: [],
      features: [],
      sort: Application.setting.sort!.isNotEmpty
          ? Application.setting.sort?.first
          : null,
      startHour: Application.setting.startHour,
      endHour: Application.setting.endHour,
    );
  }

  factory FilterModel.fromSource(FilterModel source) {
    return FilterModel(
      categories: List<CategoryModel>.from(source.categories!),
      features: List<CategoryModel>.from(source.features!),
      country: source.country,
      city: source.city,
      state: source.state,
      distance: source.distance,
      minPrice: source.minPrice,
      maxPrice: source.maxPrice,
      color: source.color,
      sort: source.sort,
      startHour: source.startHour,
      endHour: source.endHour,
    );
  }

  FilterModel clone() {
    return FilterModel.fromSource(this);
  }
}
