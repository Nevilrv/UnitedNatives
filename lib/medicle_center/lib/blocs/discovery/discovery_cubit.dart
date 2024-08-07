import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_discovery.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_product.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/repository/category_repository.dart';

import 'cubit.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit() : super(DiscoveryLoading());

  Future<void> onLoad() async {
    final result = await CategoryRepository.loadDiscovery();

    log('result==========>>>>>$result');

    List<DiscoveryModel> navajoData =
        result.where((e) => e.category.title.contains('Navajo')).toList();
    result.removeWhere((element) => element.category.title.contains('Navajo'));

    List<ProductModel> postData = [];
    navajoData.forEach((element) {
      postData.addAll(element.list);
    });
    DiscoveryModel navajoNationModel = navajoData
        .where((element) => element.category.title == 'Navajo Nation Services')
        .first;
    DiscoveryModel navajoModel =
        DiscoveryModel(list: postData, category: navajoNationModel.category);

    result.add(navajoModel);

    if (result != null) {
      emit(DiscoverySuccess(result));
    }
  }
}
