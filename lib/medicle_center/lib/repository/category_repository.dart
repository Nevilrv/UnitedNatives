import 'package:united_natives/medicle_center/lib/api/api.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_discovery.dart';

class CategoryRepository {
  ///Load Category
  static Future<List<CategoryModel>?> loadCategory({int? id}) async {
    final Map<String, dynamic> params = {};
    if (id != null) {
      params['category_id'] = id;
    }
    final result = await Api.requestCategory(params);
    if (result.success!) {
      return List.from(result.data ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message!);
    return null;
  }

  ///Load Location category
  static Future<List<CategoryModel>?> loadLocation(int id) async {
    final result = await Api.requestLocation({"parent_id": id});
    if (result.success!) {
      return List.from(result.data ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message!);
    return null;
  }

  ///Load Discovery
  static Future<List<DiscoveryModel>?> loadDiscovery() async {
    final result = await Api.requestDiscovery();
    if (result.success!) {
      return List.from(result.data ?? []).map((item) {
        return DiscoveryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message!);
    return null;
  }
}
