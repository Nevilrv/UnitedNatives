import 'package:bloc/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/authentication/authentication_state.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/application.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_user.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/repository/user_repository.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils_medicalcenter.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event load user
    UserModel user = await AppBloc.userCubit.onLoadUser();
    print('==user==> $user');
    if (user != null) {
      ///Attach token push
      Application.device?.token = await UtilsMedicalCenter.getDeviceToken();

      ///Save user
      await AppBloc.userCubit.onSaveUser(user);

      ///Valid token server
      final result = await UserRepository.validateToken();
      print('validateToken==result====>$result');
      if (result) {
        ///Load wishList
        AppBloc.wishListCubit.onLoad();

        ///Fetch user
        AppBloc.userCubit.onFetchUser();

        ///Notify
        emit(AuthenticationState.success);
      } else {
        ///Logout
        onClear();
      }
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onSave(UserModel user) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event Save user
    await AppBloc.userCubit.onSaveUser(user);

    ///Load wishList
    AppBloc.wishListCubit.onLoad();

    /// Notify
    emit(AuthenticationState.success);
  }

  void onClear() {
    /// Notify
    emit(AuthenticationState.fail);

    ///Delete user
    AppBloc.userCubit.onDeleteUser();
  }
}
