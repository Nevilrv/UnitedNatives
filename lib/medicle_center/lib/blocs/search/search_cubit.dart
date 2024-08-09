import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';
import 'cubit.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(InitialSearchState());
  Timer? timer;
  String? searchValue;
  int page = 1;
  bool isMax = false;
  List<ProductModel> datList = [];
  bool isLoadData = false;
  void onSearch(String keyword) async {
    if (searchValue != keyword) {
      page = 1;
      datList.clear();
    }

    searchValue = keyword;
    if (keyword.isNotEmpty) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 500), () async {
        if (page == 1) {
          emit(SearchLoading());
        } else {
          isLoadData = true;
          emit(SearchSuccess(list: datList, isMax: isMax, isLoad: isLoadData));
        }
        final result = await ListRepository.loadList(
          keyword: keyword,
          perPage: Application.setting.perPage!,
          page: page,
        );
        if (result!.isNotEmpty) {
          datList.addAll(result[0]);

          isMax = result[2] ?? false;
          isLoadData = false;
          emit(SearchSuccess(list: datList, isMax: isMax, isLoad: isLoadData));
        }
      });
    }
  }

  void onClear() {
    searchValue = null;
    page = 1;
    isMax = false;
    datList = [];
    isLoadData = false;
    emit(InitialSearchState());
  }
}
