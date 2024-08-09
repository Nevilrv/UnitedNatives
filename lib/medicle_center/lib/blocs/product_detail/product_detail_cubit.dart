import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/product_detail/product_detail_state.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailLoading());
  ProductModel? product;

  void onLoad(int id) async {
    log('id==========>>>>>$id');
    final result = await ListRepository.loadProduct(id);
    if (result != null) {
      product = result;
      log('product---------->>>>>>>>$result');
      emit(ProductDetailSuccess(product!));
    }
  }

  void onFavorite() {
    if (product != null) {
      product?.favorite = !product!.favorite!;
      emit(ProductDetailSuccess(product!));
      if (product!.favorite!) {
        AppBloc.wishListCubit.onAdd(product!.id!);
      } else {
        AppBloc.wishListCubit.onRemove(product!.id!);
      }
    }
  }
}
