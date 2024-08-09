import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_filter.dart';
import 'package:united_natives/medicle_center/lib/models/model_pagination.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';
import 'package:united_natives/medicle_center/lib/utils/logger.dart';

import 'cubit.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListLoading());

  int page = 1;
  List<ProductModel> list = [];
  PaginationModel? pagination;

  Future<void> onLoad(FilterModel filter) async {
    page = 1;

    ///Fetch API
    final result = await ListRepository.loadList(
      page: page,
      perPage: Application.setting.perPage!,
      filter: filter,
    );
    if (result!.isNotEmpty) {
      list = result[0];
      pagination = result[1];

      ///Notify
      emit(ListSuccess(
        list: list,
        canLoadMore: pagination!.page! < pagination!.maxPage!,
      ));
    } else {
      emit(ListSuccess(
        list: list,
      ));
    }
  }

  Future<void> onLoadMore(FilterModel filter) async {
    page = page + 1;

    ///Notify
    emit(ListSuccess(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.page! < pagination!.maxPage!,
    ));

    ///Fetch API
    final result = await ListRepository.loadList(
      page: page,
      perPage: Application.setting.perPage!,
      filter: filter,
    );
    if (result!.isNotEmpty) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(ListSuccess(
        list: list,
        canLoadMore: pagination!.page! < pagination!.maxPage!,
      ));
    } else {
      list.sort(
          (a, b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));

      emit(ListSuccess(
        list: list,
      ));
    }
  }

  Future<void> onUpdate(int id) async {
    try {
      final exist = list.firstWhere((e) => e.id == id);
      final result = await ListRepository.loadProduct(id);
      if (result != null) {
        list = list.map((e) {
          if (e.id == exist.id) {
            return result;
          }
          return e;
        }).toList();

        ///Notify
        emit(ListSuccess(
          list: list,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      } else {
        emit(ListSuccess(
          list: list,
        ));
      }
    } catch (error) {
      UtilLogger.log("LIST NOT FOUND UPDATE");
    }
  }
}
