import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_icon.dart';
import 'package:united_natives/medicle_center/lib/models/model_open_time.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'cubit.dart';

class SubmitCubit extends Cubit<SubmitState> {
  SubmitCubit() : super(SubmitInitial());

  Future<bool> onSubmit({
    int? id,
    String? title,
    String? content,
    CategoryModel? country,
    CategoryModel? state,
    CategoryModel? city,
    String? address,
    String? zipcode,
    String? phone,
    String? fax,
    String? email,
    String? website,
    Color? color,
    IconModel? icon,
    String? status,
    String? date,
    int? featureImage,
    List<int>? galleryImage,
    String? price,
    String? priceMin,
    String? priceMax,
    LocationData? gps,
    List<String>? tags,
    List<CategoryModel>? categories,
    List<CategoryModel>? facilities,
    String? bookingStyle,
    List<OpenTimeModel>? time,
    Map<String, dynamic>? socials,
  }) async {
    String? colorValue;
    if (color != null) {
      colorValue = color.value.toRadixString(16).substring(2);
    }

    Map<String, dynamic> params = {
      "post_id": id,
      "title": title,
      "content": content,
      "country": country?.id,
      "state": state?.id,
      "city": city?.id,
      "address": address,
      "zip_code": zipcode,
      "phone": phone,
      "fax": fax,
      "email": email,
      "website": website,
      "color": colorValue,
      "icon": icon?.value,
      "status": status,
      "date_establish": date,
      "thumbnail": featureImage,
      "gallery": galleryImage?.join(","),
      "booking_price": price,
      "booking_style": bookingStyle,
      "price_min": priceMin,
      "price_max": priceMax,
      "longitude": gps?.longitude,
      "latitude": gps?.latitude,
      "tags_input": tags?.join(",")
    };
    for (var i = 0; i < categories!.length; i++) {
      final item = categories[i];
      params['tax_input[listar_category][$i]'] = item.id;
    }
    for (var i = 0; i < facilities!.length; i++) {
      final item = facilities[i];
      params['tax_input[listar_feature][$i]'] = item.id;
    }
    if (time != null && time.isNotEmpty) {
      for (var i = 0; i < time.length; i++) {
        final item = time[i];
        if (item.schedule!.isNotEmpty) {
          for (var x = 0; x < item.schedule!.length; x++) {
            final element = item.schedule![x];
            final d = item.dayOfWeek;
            params['opening_hour[$d][start][$x]'] = element.start;
            params['opening_hour[$d][end][$x]'] = element.end;
          }
        }
      }
    }
    if (socials != null && socials.isNotEmpty) {
      socials.forEach((k, v) {
        params['social_network[$k]'] = v;
      });
    }

    ///Fetch API
    final result = await ListRepository.saveProduct(params);

    ///Notify
    emit(Submitted());
    return result;
  }
}
