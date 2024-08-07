import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/api/api.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/application.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_filter.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_result_api.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_setting.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils_medicalcenter.dart';

class ListRepository {
  ///load setting
  static Future<SettingModel> loadSetting() async {
    final response = await Api.requestSetting();
    if (response.success) {
      print('success');
      return SettingModel.fromJson(response.data);
    }
    AppBloc.messageCubit.onShow(response.message);
    print('failed');
    return null;
  }

  ///load list
  static Future<List> loadList({
    int page,
    int perPage,
    FilterModel filter,
    String keyword,
  }) async {
    Map<String, dynamic> params = {
      "page": page,
      "per_page": perPage,
      "s": keyword,
    };
    if (filter != null) {
      params.addAll(await filter.getParams());
    }
    final response = await Api.requestList(params);
    if (response.success) {
      final list = List.from(response.data ?? []).map((item) {
        return ProductModel.fromJson(item, setting: Application.setting);
      }).toList();
      return [
        list,
        response.pagination,
        response.pagination.page >= response.pagination.maxPage
      ];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///load wish list
  static Future<List> loadWishList({
    int page,
    int perPage,
  }) async {
    Map<String, dynamic> params = {
      "page": page,
      "per_page": perPage,
    };
    final response = await Api.requestWishList(params);
    if (response.success) {
      final list = List.from(response.data ?? []).map((item) {
        return ProductModel.fromJson(item, setting: Application.setting);
      }).toList();

      return [list, response.pagination];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///add wishList
  static Future<bool> addWishList(id) async {
    final response = await Api.requestAddWishList({"post_id": id});
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///remove wishList
  static Future<bool> removeWishList(id) async {
    final response = await Api.requestRemoveWishList({"post_id": id});
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///clear wishList
  static Future<bool> clearWishList() async {
    final response = await Api.requestClearWishList();
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///load author post
  static Future<List> loadAuthorList({
    int page,
    int perPage,
    String keyword,
    int userID,
    FilterModel filter,
    bool pending,
  }) async {
    Map<String, dynamic> params = {
      "page": page,
      "per_page": perPage,
      "s": keyword,
      "user_id": userID,
    };
    if (pending == true) {
      params['post_status'] = 'pending';
    }
    params.addAll(await filter.getParams());
    final response = await Api.requestAuthorList(params);
    print("result>>data>>1111$params");
    print("result>>success>>1111${response.success}");
    print("result>>message>1111>${response.message}");
    print("result>>>111>$response");
    if (response.success) {
      final list = List.from(response.data ?? []).map((item) {
        return ProductModel.fromJson(item, setting: Application.setting);
      }).toList();
      return [list, response.pagination, response.user];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///Upload image
  static Future<ResultApiModel> uploadImage(File file, progress) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path),
    });
    return await Api.requestUploadImage(formData, progress);
  }

  ///load detail
  static Future<ProductModel> loadProduct(id) async {
    final params = {"id": id};
    final location = await UtilsMedicalCenter.getLocation();
    if (location != null) {
      params['latitude'] = location.latitude;
      params['longitude'] = location.longitude;
    }
    final response = await Api.requestProduct(params);
    if (response.success) {
      log('response.data---------->>>>>>>>${response.data}');
      return ProductModel.fromJson(response.data, setting: Application.setting);
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///save product
  static Future<bool> saveProduct(params) async {
    final response = await Api.requestSaveProduct(params);
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Delete author item
  static Future<bool> removeProduct(id) async {
    final response = await Api.requestDeleteProduct({"post_id": id});
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Load tags list with keyword
  static Future<List<String>> loadTags(String keyword) async {
    final response = await Api.requestTags({"s": keyword});
    if (response.success) {
      return List.from(response.data ?? []).map((e) {
        return e['name'] as String;
      }).toList();
    }
    AppBloc.messageCubit.onShow(response.message);
    return [];
  }
}
