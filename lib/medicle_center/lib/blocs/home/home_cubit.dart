import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/api/api.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/home/home_state.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> onLoad() async {
    ///Fetch API Home
    final response = await Api.requestHome();
    if (response.success!) {
      // log('response.data[categories]----->${response.data['categories']}');
      final banner = List<String>.from(response.data['sliders'] ?? []);

      final category = List.from(response.data['categories'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      final location = List.from(response.data['locations'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      final recent = List.from(response.data['recent_posts'] ?? []).map((item) {
        return ProductModel.fromJson(
          item,
          setting: Application.setting,
        );
      }).toList();

      final nativeAmericanData =
          List.from(response.data['na'] ?? []).map((item) {
        return ProductModel.fromJson(
          item,
          setting: Application.setting,
        );
      }).toList();

      final americanNativeData =
          List.from(response.data['an'] ?? []).map((item) {
        return ProductModel.fromJson(
          item,
          setting: Application.setting,
        );
      }).toList();

      ///Notify
      emit(HomeSuccess(
        banner: banner,
        category: category,
        location: location,
        recent: recent,
        nativeAmericanData: nativeAmericanData,
        americanNativeData: americanNativeData,
      ));
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message!);
    }
  }
}
