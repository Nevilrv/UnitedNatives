import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/application.dart';
import 'package:united_natives/medicle_center/lib/models/model_booking_item.dart';
import 'package:united_natives/medicle_center/lib/models/model_pagination.dart';
import 'package:united_natives/medicle_center/lib/models/model_sort.dart';
import 'package:united_natives/medicle_center/lib/repository/booking_repository.dart';
import 'cubit.dart';

class BookingManagementCubit extends Cubit<BookingManagementState> {
  BookingManagementCubit() : super(BookingListLoading());

  int pageBooking = 1;
  int pageRequest = 1;
  List<BookingItemModel> listBooking = [];
  List<BookingItemModel> listRequest = [];
  PaginationModel? paginationRequest;
  PaginationModel? paginationBooking;
  SortModel? sortRequest;
  SortModel? sortBooking;
  SortModel? statusRequest;
  SortModel? statusBooking;
  List<SortModel> sortOptionRequest = [];
  List<SortModel> sortOptionBooking = [];
  List<SortModel> statusOptionRequest = [];
  List<SortModel> statusOptionBooking = [];

  Future<void> onLoad({
    SortModel? sort,
    SortModel? status,
    String? keyword,
    bool? request,
  }) async {
    bool loadMoreBooking = false;
    bool loadMoreRequest = false;
    if (request!) {
      pageRequest = 1;

      ///Fetch API
      final result = await BookingRepository.loadList(
        page: pageRequest,
        perPage: Application.setting.perPage!,
        sort: sort,
        status: status,
        keyword: "$keyword",
        request: request,
      );
      if (result!.isNotEmpty) {
        listRequest = result[0];
        paginationRequest = result[1];
        loadMoreRequest =
            (paginationRequest!.page! < paginationRequest!.maxPage!);
        if (sortOptionRequest.isEmpty) {
          sortOptionRequest = result[2];
        }
        if (statusOptionRequest.isEmpty) {
          statusOptionRequest = result[3];
        }
      }
    } else {
      pageBooking = 1;

      ///Fetch API
      final result = await BookingRepository.loadList(
        page: pageBooking,
        perPage: Application.setting.perPage!,
        sort: sort,
        status: status,
        keyword: "$keyword",
        request: request,
      );
      if (result!.isNotEmpty) {
        listBooking = result[0];
        paginationBooking = result[1];
        loadMoreBooking =
            (paginationBooking!.page! < paginationBooking!.maxPage!);
        if (sortOptionBooking.isEmpty) {
          sortOptionBooking = result[2];
        }
        if (statusOptionBooking.isEmpty) {
          statusOptionBooking = result[3];
        }
      }
    }

    ///Notify
    emit(BookingListSuccess(
      listBooking: listBooking,
      listRequest: listRequest,
      canLoadMoreBooking: loadMoreBooking,
      canLoadMoreRequest: loadMoreRequest,
    ));
  }

  Future<void> onLoadMore({
    SortModel? sort,
    SortModel? status,
    String? keyword,
    bool? request,
  }) async {
    bool loadMoreBooking =
        paginationBooking!.page! < paginationBooking!.maxPage!;
    bool loadMoreRequest =
        paginationRequest!.page! < paginationRequest!.maxPage!;

    if (request!) {
      pageRequest = pageRequest + 1;

      ///Notify
      emit(BookingListSuccess(
        loadingMoreRequest: true,
        listBooking: listBooking,
        listRequest: listRequest,
        canLoadMoreBooking: loadMoreBooking,
        canLoadMoreRequest: loadMoreRequest,
      ));

      ///Fetch API
      final result = await BookingRepository.loadList(
        page: pageRequest,
        perPage: Application.setting.perPage!,
        sort: sort,
        status: status,
        keyword: "$keyword",
        request: request,
      );

      if (result!.isNotEmpty) {
        listRequest.addAll(result[0]);
        paginationRequest = result[1];
      }
    } else {
      pageBooking = pageBooking + 1;

      ///Notify
      emit(BookingListSuccess(
        loadingMoreBooking: true,
        listBooking: listBooking,
        listRequest: listRequest,
        canLoadMoreBooking: loadMoreBooking,
        canLoadMoreRequest: loadMoreRequest,
      ));

      ///Fetch API
      final result = await BookingRepository.loadList(
        page: pageBooking,
        perPage: Application.setting.perPage!,
        sort: sort,
        status: status,
        keyword: "$keyword",
        request: request,
      );

      if (result!.isNotEmpty) {
        listBooking.addAll(result[0]);
        paginationBooking = result[1];
      }
    }

    ///Notify
    emit(BookingListSuccess(
      listBooking: listBooking,
      listRequest: listRequest,
      canLoadMoreBooking:
          paginationBooking!.page! < paginationBooking!.maxPage!,
      canLoadMoreRequest:
          paginationRequest!.page! < paginationRequest!.maxPage!,
    ));
  }
}
