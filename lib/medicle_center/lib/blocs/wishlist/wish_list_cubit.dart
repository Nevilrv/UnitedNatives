import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_pagination.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';
import 'cubit.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListLoading());

  int page = 1;
  List<ProductModel> list = [];
  PaginationModel? pagination;

  Future<void> onLoad({int? updateID}) async {
    page = 1;
    final result = await ListRepository.loadWishList(
      page: page,
      perPage: Application.setting.perPage!,
    );
    if (result!.isNotEmpty) {
      list = result[0];
      pagination = result[1];

      ///Notify
      emit(WishListSuccess(
        updateID: updateID,
        list: list,
        canLoadMore: pagination!.page! < pagination!.maxPage!,
      ));
    }
  }

  Future<void> onLoadMore() async {
    page = page + 1;

    ///Notify
    emit(WishListSuccess(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.page! < pagination!.maxPage!,
    ));

    final result = await ListRepository.loadWishList(
      page: page,
      perPage: Application.setting.perPage!,
    );
    if (result!.isNotEmpty) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(WishListSuccess(
        list: list,
        canLoadMore: pagination!.page! < pagination!.maxPage!,
      ));
    }
  }

  void onAdd(int? id) async {
    final result = await ListRepository.addWishList(id);
    if (result) {
      onLoad(updateID: id);
    }
  }

  void onRemove(int? id) async {
    if (id != null) {
      await ListRepository.removeWishList(id);
    } else {
      await ListRepository.clearWishList();
    }
    onLoad(updateID: id);
  }
}
