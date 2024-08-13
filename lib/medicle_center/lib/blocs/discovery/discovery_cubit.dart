import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model_discovery.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/repository/category_repository.dart';

import 'cubit.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit() : super(DiscoveryLoading());

  Future<void> onLoad() async {
    final result = await CategoryRepository.loadDiscovery();

    List<DiscoveryModel>? navajoData = result
        ?.where((DiscoveryModel e) => e.category!.title!.contains('Navajo'))
        .toList();
    result?.removeWhere((DiscoveryModel element) =>
        element.category!.title!.contains('Navajo'));

    List<ProductModel> postData = [];
    for (var element in navajoData ?? []) {
      postData.addAll(element.list!);
    }
    DiscoveryModel? navajoNationModel = navajoData
        ?.where(
            (element) => element.category?.title == 'Navajo Nation Services')
        .first;
    DiscoveryModel navajoModel =
        DiscoveryModel(list: postData, category: navajoNationModel?.category);

    result?.add(navajoModel);
    if (result != null) {
      if (result.isNotEmpty) {
        emit(DiscoverySuccess(result));
      }
    }
  }
}
