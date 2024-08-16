import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/api/api.dart';
import 'package:united_natives/medicle_center/lib/models/model_city_data.dart';
import 'package:united_natives/medicle_center/lib/models/model_state_data.dart';
import 'cubit.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(InitialFilterState());

  StateModel? selectedState;

  CityModel? selectedCity;

  List<StateModel> stateList = [];

  List<CityModel> cityList = [];

  Future<void> onStateLoad() async {
    selectedState = Prefs.getString(Prefs.stateFilter) != null
        ? StateModel.fromJson(
            json.decode(Prefs.getString(Prefs.stateFilter) ?? ""))
        : null;

    selectedCity = Prefs.getString(Prefs.cityFilter) != null
        ? CityModel.fromJson(
            json.decode(Prefs.getString(Prefs.cityFilter) ?? ""))
        : null;

    try {
      final responseState = await Api.requestState();
      final categoryOfStatess = List.from(responseState ?? []).map((item) {
        return StateModel.fromJson(
          item,
        );
      }).toList();
      // if (categoryOfStatess.isEmpty) {
      //   emit(
      //     FilterSuccess(stateList: categoryOfStatess ?? []),
      //   );
      //   return;
      // }
      emit(
        FilterSuccess(stateList: categoryOfStatess),
      );
      if (categoryOfStatess.isNotEmpty &&
          categoryOfStatess.first.name != 'All States') {
        int stateMedicalCenterCount = 0;
        for (var e in categoryOfStatess) {
          stateMedicalCenterCount += e.medicalCenterInState!;
        }

        StateModel stateAllModel = StateModel(
          name: 'All States',
          medicalCenterInState: stateMedicalCenterCount,
          id: '',
        );

        categoryOfStatess.insert(0, stateAllModel);
      }

      onCitiesLoad(
          stateData: categoryOfStatess,
          stateId: categoryOfStatess.first.id.toString());
    } catch (e) {
      log('e==========>>>>>$e');
    }
  }

  Future<void> onCitiesLoad(
      {List<StateModel>? stateData, String? stateId}) async {
    selectedCity = null;
    try {
      final responseCity = await Api.requestCity(stateId: stateId);

      List<CityModel> categoryOfCities = [];
      if (responseCity != null && responseCity != []) {
        categoryOfCities = List<CityModel>.from(
            responseCity.map((x) => CityModel.fromJson(x)));

        if (categoryOfCities.isNotEmpty &&
            categoryOfCities.first.name != 'All Cities') {
          int cityMedicalCenterCount = 0;
          for (var e in categoryOfCities) {
            cityMedicalCenterCount =
                cityMedicalCenterCount + e.medicalCenterInCity!;
          }
          CityModel cityAllModel = CityModel(
            name: 'All Cities',
            medicalCenterInCity: cityMedicalCenterCount,
            id: '',
          );
          categoryOfCities.insert(0, cityAllModel);
        }
      }
      emit(
        FilterSuccess(
          stateList: stateData ?? [],
          cityList: categoryOfCities,
        ),
      );
    } catch (e) {
      emit(FilterSuccess(stateList: stateData ?? [], cityList: []));
    }
  }

  void onUpdateStateData(
      {List<StateModel>? stateDataList, StateModel? stateData}) async {
    selectedState = stateData;
    selectedCity = null;

    // cityList = [];
    log('cityList======1111====>>>>>$cityList');
    cityList.clear();
    log('cityList======2222====>>>>>$cityList');

    emit(state);
  }

  void onUpdateCityData({CityModel? cityData}) {
    selectedCity = cityData;
    emit(state);
  }

  void clearAllFilter(
      {List<StateModel>? stateDataList, List<CityModel>? cityDataList}) {
    selectedCity = null;
    selectedState = null;
    emit(FilterSuccess(
        stateList: stateDataList ?? [], cityList: cityDataList ?? []));
  }
}
