import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/profile/profile_state.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_comment.dart';
import 'package:united_natives/medicle_center/lib/models/model_filter.dart';
import 'package:united_natives/medicle_center/lib/models/model_pagination.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/models/model_user.dart';
import 'package:united_natives/medicle_center/lib/repository/list_repository.dart';
import 'package:united_natives/medicle_center/lib/repository/review_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  int page = 1;
  List<ProductModel> listProduct = [];
  List<ProductModel> listProductPending = [];
  List<CommentModel> listComment = [];
  PaginationModel? pagination;
  UserModel? user;
  Timer? timer;

  void onLoad({
    FilterModel? filter,
    String? keyword,
    int? userID,
    String? currentTab,
  }) async {
    page = 1;
    if (currentTab == 'listing') {
      if (listProduct.isEmpty) {
        emit(ProfileLoading());
      }

      ///Listing Load
      final result = await ListRepository.loadAuthorList(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? "",
        userID: userID ?? 0,
        filter: filter,
      );
      if (result!.isNotEmpty) {
        listProduct = result[0];
        pagination = result[1];
        user = result[2];
        user?.updateUser(total: pagination!.total);

        ///Notify
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      } else {
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: false,
        ));
      }
    } else if (currentTab == 'pending') {
      if (listProductPending.isEmpty) {
        emit(ProfileLoading());
      }

      ///Listing Load
      final result = await ListRepository.loadAuthorList(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? '',
        userID: userID ?? 0,
        filter: filter,
        pending: true,
      );
      if (result!.isNotEmpty) {
        listProductPending = result[0];
        pagination = result[1];
        user = result[2];
        user?.updateUser(total: pagination!.total);

        ///Notify
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      } else {
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: false,
        ));
      }
    } else {
      if (listComment.isEmpty) {
        emit(ProfileLoading());
      }

      ///Review Load
      final response = await ReviewRepository.loadAuthorReview(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? '',
        userID: userID ?? 0,
      );
      if (response.success!) {
        listComment = List.from(response.data ?? []).map((item) {
          return CommentModel.fromJson(item);
        }).toList();

        pagination = response.pagination;

        ///Notify
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      } else {
        AppBloc.messageCubit.onShow(response.message!);
      }
    }
  }

  void onSearch({
    FilterModel? filter,
    String? keyword,
    int? userID,
    String? currentTab,
  }) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () async {
      page = 1;

      if (currentTab == 'listing') {
        if (listProduct.isEmpty) {
          emit(ProfileLoading());
        }

        ///Listing Load
        final result = await ListRepository.loadAuthorList(
          page: page,
          perPage: Application.setting.perPage!,
          keyword: keyword ?? '',
          userID: userID ?? 0,
          filter: filter,
        );
        if (result!.isNotEmpty) {
          listProduct = result[0];
          pagination = result[1];
          user = result[2];
          user?.updateUser(total: pagination!.total);

          ///Notify
          emit(ProfileSuccess(
            user: user,
            listProduct: listProduct,
            listProductPending: listProductPending,
            listComment: listComment,
            canLoadMore: pagination!.page! < pagination!.maxPage!,
          ));
        }
      } else if (currentTab == 'pending') {
        if (listProductPending.isEmpty) {
          emit(ProfileLoading());
        }

        ///Listing Load
        final result = await ListRepository.loadAuthorList(
          page: page,
          perPage: Application.setting.perPage!,
          keyword: keyword ?? '',
          userID: userID ?? 0,
          filter: filter,
          pending: true,
        );

        if (result!.isNotEmpty) {
          listProductPending = result[0];
          pagination = result[1];
          user = result[2];
          user?.updateUser(total: pagination!.total);

          ///Notify
          emit(ProfileSuccess(
            user: user,
            listProduct: listProduct,
            listProductPending: listProductPending,
            listComment: listComment,
            canLoadMore: pagination!.page! < pagination!.maxPage!,
          ));
        }
      } else {
        if (listComment.isEmpty) {
          emit(ProfileLoading());
        }

        ///Review Load
        final response = await ReviewRepository.loadAuthorReview(
          page: page,
          perPage: Application.setting.perPage!,
          keyword: keyword ?? "",
          userID: userID ?? 0,
        );

        if (response.success!) {
          listComment = List.from(response.data ?? []).map((item) {
            return CommentModel.fromJson(item);
          }).toList();

          pagination = response.pagination;

          ///Notify
          emit(ProfileSuccess(
            user: user,
            listProduct: listProduct,
            listProductPending: listProductPending,
            listComment: listComment,
            canLoadMore: pagination!.page! < pagination!.maxPage!,
          ));
        } else {
          AppBloc.messageCubit.onShow(response.message!);
        }
      }
    });
  }

  void onLoadMore({
    FilterModel? filter,
    String? keyword,
    int? userID,
    String? currentTab,
  }) async {
    page += 1;

    ///Notify loading more

    emit(ProfileSuccess(
      user: user,
      listProduct: listProduct,
      listProductPending: listProductPending,
      listComment: listComment,
      canLoadMore: pagination!.page! < pagination!.maxPage!,
      loadingMore: true,
    ));

    if (currentTab == 'listing') {
      ///Listing Load
      final result = await ListRepository.loadAuthorList(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? "",
        userID: userID ?? 0,
        filter: filter,
      );
      if (result!.isNotEmpty) {
        listProduct.addAll(result[0]);
        pagination = result[1];
        user = result[2];
        user?.updateUser(total: pagination!.total);

        ///Notify
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      }
    } else if (currentTab == 'pending') {
      ///pending
      final result = await ListRepository.loadAuthorList(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? '',
        userID: userID ?? 0,
        filter: filter,
        pending: true,
      );
      if (result!.isNotEmpty) {
        listProductPending.addAll(result[0]);
        pagination = result[1];
        user = result[2];
        user?.updateUser(total: pagination!.total);

        ///Notify
        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      }
    } else {
      ///Review Load
      final response = await ReviewRepository.loadAuthorReview(
        page: page,
        perPage: Application.setting.perPage!,
        keyword: keyword ?? '',
        userID: userID ?? 0,
      );
      if (response.success!) {
        final moreList = List.from(response.data ?? []).map((item) {
          return CommentModel.fromJson(item);
        }).toList();

        listComment.addAll(moreList);
        pagination = response.pagination;

        ///Notify

        emit(ProfileSuccess(
          user: user,
          listProduct: listProduct,
          listProductPending: listProductPending,
          listComment: listComment,
          canLoadMore: pagination!.page! < pagination!.maxPage!,
        ));
      } else {
        AppBloc.messageCubit.onShow(response.message!);
      }
    }
  }
}
