import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/repository/review_repository.dart';
import 'cubit.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewLoading());

  Future<void> onLoad(int id) async {
    ///Notify
    emit(ReviewLoading());

    ///Fetch API
    final result = await ReviewRepository.loadReview(id);
    if (result!.isNotEmpty) {
      ///Notify
      emit(
        ReviewSuccess(
          list: result[0],
          rate: result[1],
        ),
      );
    }
  }

  Future<bool> onSave({
    int? id,
    String? content,
    double? rate,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReview(
      id: id!,
      content: content!,
      rate: rate!,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(id);
      if (result!.isNotEmpty) {
        ///Notify
        emit(
          ReviewSuccess(
            id: id,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }
}
