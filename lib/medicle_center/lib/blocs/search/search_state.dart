import 'package:united_natives/medicle_center/lib/models/model_product.dart';

abstract class SearchState {}

class InitialSearchState extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ProductModel>? list;
  final bool? isMax;
  final bool? isLoad;
  SearchSuccess({this.list, this.isMax, this.isLoad});
}
