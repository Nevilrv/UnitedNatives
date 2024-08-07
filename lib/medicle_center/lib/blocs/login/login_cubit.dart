import 'package:bloc/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/application.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/repository/user_repository.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils_medicalcenter.dart';

enum LoginState {
  init,
  loading,
  success,
  fail,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.init);

  void onLogin({
    String username,
    String password,
  }) async {
    ///Notify
    emit(LoginState.loading);

    ///Set Device Token
    Application.device?.token = await UtilsMedicalCenter.getDeviceToken();

    ///login via repository
    final result = await UserRepository.login(
      username: username,
      password: password,
    );
    print('++++++++++LogIn++++++$result');
    if (result != null) {
      ///Begin start Auth flow
      await AppBloc.authenticateCubit.onSave(result);

      ///Notify
      emit(LoginState.success);
    } else {
      ///Notify
      emit(LoginState.fail);
    }
  }

  void onLogout() async {
    ///Begin start auth flow
    emit(LoginState.init);
    AppBloc.authenticateCubit.onClear();
  }

  void onDeactivate() async {
    final result = await UserRepository.deactivate();
    if (result) {
      AppBloc.authenticateCubit.onClear();
    }
  }
}
