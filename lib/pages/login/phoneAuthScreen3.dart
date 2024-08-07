import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/model/login_verification.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PhoneVerification3 extends StatefulWidget {
  final LoginVerificationData loginVerificationData;
  final String resetPINId;

  PhoneVerification3({this.loginVerificationData, this.resetPINId});

  @override
  _PhoneVerification3State createState() => _PhoneVerification3State();
}

class _PhoneVerification3State extends State<PhoneVerification3> {
  String userType1 = "1";
  var appBarHeight = 0.0;
  var otpController = new TextEditingController();
  bool _btnEnabled = false;

  // get userType => UserController().user.value.userType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserController _userController = Get.find<UserController>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  FocusNode focusNode = FocusNode();
  var currentFocus;

  unFocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(children: <Widget>[
          Container(
            color: kColorPrimary,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: appBarHeight,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     InkWell(
                  //       highlightColor: Colors.transparent,
                  //       splashColor: Colors.transparent,
                  //       onTap: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       child: Icon(
                  //         Icons.arrow_back,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    'Reset Your Secret PIN',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    ('Enter your secret pin here'),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
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
                                              focusNode: focusNode,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: otpController,
                                              maxLength: 4,
                                              onChanged: (String txt) {
                                                if (txt.length == 4) {
                                                  setState(() {
                                                    _btnEnabled = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _btnEnabled = false;
                                                  });
                                                }
                                              },
                                              onTap: () {},
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18,
                                              ),
                                              decoration: new InputDecoration(
                                                  // errorText: validatePassword(
                                                  //     otpController.text),
                                                  border: InputBorder.none,
                                                  labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  counterText: ""),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
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
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, left: 32),
                    child: RoundedLoadingButton(
                      color: Colors.white,
                      valueColor: kColorBlue,
                      successColor: Colors.white,
                      child: _btnEnabled == true
                          ? Text('PROCEED',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kColorBlue,
                                  fontWeight: FontWeight.bold))
                          : Text('Enter Secure PIN to Proceed',
                              style: TextStyle(
                                  color: kColorBlue,
                                  fontWeight: FontWeight.bold)),
                      controller: _btnController,
                      onPressed: _btnEnabled == true
                          ? () async {
                              unFocus();
                              final userPIN = '${otpController.text}';
                              final encryptedUtf = utf8.encode(userPIN);
                              final encryptedPIN = md5.convert(encryptedUtf);
                              if (_formKey.currentState.validate()) {
                                await _userController.changePIN(
                                    widget.loginVerificationData.id,
                                    widget.resetPINId,
                                    encryptedPIN.toString());
                              }
                            }
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 25, right: 15, left: 15),
                      padding: EdgeInsets.only(bottom: 15, right: 15, left: 15),
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
                          SizedBox(
                            height: 15,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Note",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RichText(
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Choose a PIN that’s hard to guess : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 19.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      "This means that you  shouldn’t use “12345” as your PIN, nor should you use a birthday or another significant date that someone else can guess.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        letterSpacing: 0.2,
                                        height: 1.5,
                                        color: Colors.black,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RichText(
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Keep your PIN private : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 19.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      "It’s just good practice to keep your PIN to yourself and never share with anyone.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        letterSpacing: 0.2,
                                        height: 1.5,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RichText(
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Memorize your PIN : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 19.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      "If you record this number anywhere, then someone might come across it and may be able to login into the app. That’s why it’s always a good idea to create a PIN you will know and then commit it to memory.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 15.5,
                                        letterSpacing: 0.2,
                                        height: 1.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ]));
  }

  Widget getOtpTextUI({String otptxt = ""}) {
    List<Widget> otpList = <Widget>[];
    Widget getUI({String otxt = ""}) {
      return Expanded(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 12,
            ),
            Text(
              otxt,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2.5,
                width: 50,
                color: Theme.of(context).dividerColor,
              ),
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
