import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model_image.dart';
import 'package:united_natives/medicle_center/lib/models/model_user.dart';
import 'package:united_natives/medicle_center/lib/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserCubit extends Cubit<UserModel> {
  UserCubit() : super(UserModel());

  ///Event load user
  Future<UserModel> onLoadUser() async {
    UserModel user = await UserRepository.loadUser();
    emit(user);
    return user;
  }

  ///Event fetch user
  Future<UserModel> onFetchUser() async {
    UserModel? local = await UserRepository.loadUser();
    UserModel? remote = await UserRepository.fetchUser();
    final sync = local.updateUser(
      name: remote?.name,
      email: remote?.email,
      url: remote?.url,
      description: remote?.description,
      image: remote?.image,
    );
    onSaveUser(sync);
    return sync;
  }

  ///Event save user
  Future<void> onSaveUser(UserModel user) async {
    await UserRepository.saveUser(user: user);
    emit(user);
  }

  ///Event delete user
  void onDeleteUser() {
    FirebaseMessaging.instance.deleteToken();
    UserRepository.deleteUser();
    emit(UserModel());
  }

  ///Event update user
  Future<bool> onUpdateUser({
    String? name,
    String? email,
    String? url,
    String? description,
    ImageModel? image,
  }) async {
    ///Fetch change profile
    final result = await UserRepository.changeProfile(
      name: name!,
      email: email!,
      url: url!,
      description: description!,
      imageID: image!.id!,
    );

    ///Case success
    if (result) {
      await onFetchUser();
    }
    return result;
  }

  ///Event change password
  Future<bool> onChangePassword(String password) async {
    return await UserRepository.changePassword(password: password);
  }

  ///Event register
  Future<bool> onRegister({
    String? username,
    String? password,
    String? email,
  }) async {
    return await UserRepository.register(
      username: username!,
      password: password!,
      email: email!,
    );
  }

  ///Event forgot password
  Future<bool> onForgotPassword(String email) async {
    return await UserRepository.forgotPassword(email: email);
  }
}
