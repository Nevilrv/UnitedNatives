import 'dart:convert';
import 'dart:developer';

import 'package:united_natives/medicle_center/lib/api/api.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/preferences.dart';
import 'package:united_natives/medicle_center/lib/models/model_user.dart';

class UserRepository {
  ///Fetch api login
  static Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
    };

    log('MEDI LOGIN PARAMS REPO ==========>>>>>${params}');

    final response = await Api.requestLogin(params);

    log('MEDI LOGIN RESPONSE REPO====success======>>>>>${response.success}');
    log('MEDI LOGIN RESPONSE REPO====data======>>>>>${response.data}');
    log('MEDI LOGIN RESPONSE REPO====user======>>>>>${response.user}');
    log('MEDI LOGIN RESPONSE REPO====message======>>>>>${response.message}');

    if (response.success!) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageCubit.onShow(response.message!);
    return null;
  }

  ///Fetch api validToken
  static Future<bool> validateToken() async {
    final response = await Api.requestValidateToken();
    if (response.success!) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message!);
    return false;
  }

  ///Fetch api deactivate
  static Future<bool> deactivate() async {
    final response = await Api.requestDeactivate();
    if (response.success!) {
      return true;
    }
    return false;
  }

  ///Fetch api change Password
  static Future<bool> changePassword({
    String? password,
  }) async {
    final Map<String, dynamic> params = {"password": password};
    final response = await Api.requestChangePassword(params);
    AppBloc.messageCubit.onShow(response.message!);
    if (response.success!) {
      return true;
    }
    return false;
  }

  ///Fetch api forgot Password
  static Future<bool> forgotPassword({String? email}) async {
    final Map<String, dynamic> params = {"email": email};
    final response = await Api.requestForgotPassword(params);
    AppBloc.messageCubit.onShow(response.message!);
    if (response.success!) {
      return true;
    }

    return false;
  }

  ///Fetch api register account
  static Future<bool> register({
    String? username,
    String? password,
    String? email,
  }) async {
    final Map<String, dynamic> params = {
      "username": username,
      "password":
          password.toString() == "null" ? "12345678" : password.toString(),
      "email": email,
    };

    log('params==========>>>>>$params');

    final response = await Api.requestRegister(params);
    AppBloc.messageCubit.onShow(response.message ?? "");
    if (response.success!) {
      return true;
    }
    return false;
  }

  ///Fetch api forgot Password
  static Future<bool> changeProfile({
    String? name,
    String? email,
    String? url,
    String? description,
    int? imageID,
  }) async {
    Map<String, dynamic> params = {
      "name": name,
      "email": email,
      "url": url,
      "description": description,
    };
    if (imageID != null) {
      params['listar_user_photo'] = imageID;
    }
    final response = await Api.requestChangeProfile(params);
    AppBloc.messageCubit.onShow(response.message!);

    ///Case success
    if (response.success!) {
      return true;
    }
    return false;
  }

  ///Save User
  static Future<bool> saveUser({UserModel? user}) async {
    return Preferences.instance!.setString(Preferences.user, jsonEncode(user));
  }

  ///Load User
  static Future<UserModel> loadUser() async {
    final result = Preferences.getString(Preferences.user);
    if (result != null) {
      return UserModel.fromJson(jsonDecode(result));
    }
    return UserModel();
  }

  ///Fetch User
  static Future<UserModel?> fetchUser() async {
    final response = await Api.requestUser();
    if (response.success!) {
      return UserModel.fromJson(response.data);
    }
    AppBloc.messageCubit.onShow(response.message!);
    return null;
  }

  ///Delete User
  static Future<bool?> deleteUser() async {
    log('Preferences.user---------->>>>>>>>${Preferences.user}');
    return await Preferences.remove(Preferences.user);
  }
}
