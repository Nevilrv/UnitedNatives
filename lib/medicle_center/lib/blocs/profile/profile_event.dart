import 'package:united_natives/medicle_center/lib/models/model_filter.dart';

abstract class ProfileEvent {}

class OnLoad extends ProfileEvent {
  final FilterModel? filter;
  final String? keyword;
  final int? userID;
  final bool? listing;

  OnLoad({
    this.filter,
    this.keyword,
    this.userID,
    this.listing,
  });
}

class OnLoadMore extends ProfileEvent {
  final FilterModel? filter;
  final String? keyword;
  final int? userID;
  final bool? listing;

  OnLoadMore({
    this.filter,
    this.keyword,
    this.userID,
    this.listing,
  });
}

class OnProfileSearch extends ProfileEvent {
  final FilterModel? filter;
  final String? keyword;
  final int? userID;
  final bool? listing;

  OnProfileSearch({
    this.filter,
    this.keyword,
    this.userID,
    this.listing,
  });
}
