import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/model/login_verification.dart';
import 'package:united_natives/model/pin_status_model.dart';
import 'package:united_natives/model/reset_pin_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/app_enum.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';

class PhoneVerification2 extends StatefulWidget {
  const PhoneVerification2({super.key});
  @override
  State<PhoneVerification2> createState() => _PhoneVerification2State();
}

class _PhoneVerification2State extends State<PhoneVerification2> {
  String userType1 = "1";
  var appBarHeight = 0.0;
  var otpController = TextEditingController();
  bool onPressed = false;
  bool btnEnabled = false;
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.put(UserController());
  LoginVerificationData loginVerificationData = LoginVerificationData();
  PINStatusModel pinStatusModelData = PINStatusModel();
  ResetPIN resetPINData = ResetPIN();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  FocusNode focusNode = FocusNode();
  var currentFocus;
  unFocus() {
    currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  LogOutController logOutController = Get.find();

  Future<void> addChatOnlineStatus({required bool type}) async {
    AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
    model.isOnline = type;
    model.lastSeen = DateTime.now().toString();
    await logOutController.addChatStatus(model: model);
    if (logOutController.addChatStatusApiResponse.status == Status.COMPLETE) {
    } else if (logOutController.addChatStatusApiResponse.status ==
        Status.ERROR) {}
  }

  @override
  Widget build(BuildContext context) {
    _userController.isPinScreen.value = true;
    appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
        backgroundColor: _isDark ? Colors.black : kColorPrimary,
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            // Container(
            //   color: kColorPrimary,
            //   // alignment: Alignment.center,
            //   // child: CircularProgressIndicator(),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: Column(
                children: <Widget>[
                  //back arrow

                  SizedBox(
                    height: appBarHeight,
                  ),
                  /* widget.isShow == true
                      ?*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ) /*  : const SizedBox()*/,

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    'Enter Your Secret PIN',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    ('Enter Your Secret PIN here!'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: getOtpTextUI(otptxt: otpController.text),
                        ),
                        Opacity(
                          opacity: 0.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Form(
                                      key: _formKey,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18,
                                                ),
                                                focusNode: focusNode,
                                                textInputAction:
                                                    TextInputAction.go,
                                                autofocus: Prefs.getString(Prefs
                                                            .isLoginFirst) ==
                                                        "1"
                                                    ? false
                                                    : true,
                                                obscureText: true,
                                                controller: otpController,
                                                maxLength: 4,
                                                onChanged: (String txt) {
                                                  if (txt.length == 4) {
                                                    setState(() {
                                                      btnEnabled = true;
                                                      _userController.isCheck =
                                                          true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      btnEnabled = false;
                                                      _userController.isCheck =
                                                          false;
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    counterText: ""),
                                                keyboardType:
                                                    TextInputType.number),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 32, left: 32),
                        child: RoundedLoadingButton(
                          color: Colors.white,
                          valueColor: kColorBlue,
                          successColor: Colors.white,
                          controller: _btnController,
                          onPressed: controller.isCheck == true
                              ? () async {
                                  unFocus();
                                  final userPIN = otpController.text;

                                  final encryptedUtf = utf8.encode(userPIN);
                                  var md5 = crypto.md5;
                                  final encryptedPIN =
                                      md5.convert(encryptedUtf);
                                  if (_formKey.currentState!.validate()) {
                                    await _userController.userLogin(
                                        LogInType.NORMAL,
                                        _userController.loginData?.userType ??
                                            Config.getUserType(),
                                        _userController.loginData?.email ??
                                            Config.getEmail(),
                                        _userController.loginData?.password ??
                                            Config.getPassword(),
                                        encryptedPIN.toString(),
                                        userPIN,
                                        context);
                                    _btnController.stop();
                                    controller.isCheck = false;
                                    if (_userController.user.value != null) {
                                      _btnController.reset();
                                    }
                                  }
                                }
                              : null,
                          child: controller.isCheck == true
                              ? const Text('PROCEED',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kColorBlue,
                                      fontWeight: FontWeight.bold))
                              : const Text('Enter Secure PIN to Proceed',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kColorBlue,
                                      fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Center(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        setState(() {
                          onPressed = true;
                        });
                        loginVerificationData =
                            await _userController.loginVerificationDetails(
                                _userController.loginData?.email ??
                                    Config.getEmail(),
                                _userController.loginData?.password ??
                                    Config.getPassword());

                        pinStatusModelData = await _userController
                            .statusPIN(loginVerificationData.id!);
                        if (pinStatusModelData.toInitiate == "1") {
                          resetPINData = await _userController.resetPIN(
                              loginVerificationData.id!,
                              context /* _userController.loginData.userType*/);
                          setState(() {
                            onPressed = false;
                          });
                        } else {
                          if (pinStatusModelData.pinStatusData?.requestStatus ==
                              "1") {
                            Utils.showSnackBar('Admin Verification Pending',
                                'Please try again after some time');
                          } /*else if (pinStatusModelData
                                  .pinStatusData.requestStatus ==
                              "2") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhoneVerification3(
                                      loginVerificationData:
                                          loginVerificationData,
                                      resetPINId:
                                          pinStatusModelData.pinStatusData.id),
                                ));
                          }*/
                          setState(() {
                            onPressed = false;
                          });
                        }
                      },
                      child: onPressed
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          // ? Center(
                          //     child: Utils.circular(),
                          //   )
                          : Text(
                              ('Reset PIN'),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Are you sure want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () async {
                                    _userController.user.value.id = null;
                                    await addChatOnlineStatus(type: false);
                                    await logOutController.doctorLogOut().then(
                                      (value) {
                                        _userController.signOut();
                                        Prefs.clear();
                                        AppBloc.loginCubit.onLogout();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                Routes.login,
                                                (Route<dynamic> route) =>
                                                    false);

                                        TimerChange.timer?.cancel();
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Log out',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        ('Logout'),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),

                  Prefs.getString(Prefs.isLoginFirst) == "1"
                      ? Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.29,
                              right: 15,
                              left: 15),
                          padding: const EdgeInsets.all(12),
                          // height: MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 0,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Note",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                overflow: TextOverflow.visible,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don't have a secret PIN : ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          "If you don't have a secret PIN then click on Reset PIN to set your secret PIN.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            letterSpacing: 0.25,
                                            height: 1.5,
                                            color: Colors.black,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ]),
        ));
  }

  Widget getOtpTextUI({String otptxt = ""}) {
    List<Widget> otpList = <Widget>[];
    Widget getUI({String otxt = ""}) {
      return Expanded(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 12,
            ),
            Text(
              otxt,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isDark ? Colors.white : Colors.black,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 2.5,
                  width: 50,
                  color: Theme.of(context).dividerColor),
            )
          ],
        ),
      );
    }

    for (var i = 0; i < 4; i++) {
      otpList.add(getUI(otxt: otptxt.length > i ? otptxt[i] : ""));
    }
    return Row(
      children: otpList,
    );
  }
}
