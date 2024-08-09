import 'package:united_natives/medicle_center/lib/models/model_product.dart';

abstract class ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final ProductModel product;

  ProductDetailSuccess(this.product);
}
