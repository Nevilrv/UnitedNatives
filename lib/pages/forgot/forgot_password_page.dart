import 'dart:async';
import 'dart:convert';

import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AdsController adsController = Get.find();
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(height: 80),
                        ),
                        Text(
                          Translate.of(context).translate('forgot_password'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 30),
                        WidgetForgot(),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(height: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class WidgetForgot extends StatefulWidget {
  @override
  _WidgetForgotState createState() => _WidgetForgotState();
}

class _WidgetForgotState extends State<WidgetForgot> {
  final _emailController = TextEditingController();
  bool _btnEnabled = false;
  final _formKey = GlobalKey<FormState>();
  UserController _userController = Get.find();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future forGotPassWord({var body}) async {
    Map<String, String> headers = {
      "Authorization": 'Bearer Bearer 81dc9bdb52d04dc20036dbd8313ed055',
      "Content-Type": 'application/x-www-form-urlencoded',
    };
    http.Response response = await http.post(
        Uri.parse(Constants.updateRoutineHealthReport),
        headers: headers,
        body: body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print('$result');
      return result;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Translate.of(context).translate('email_dot'),
            style: kInputTextStyle,
          ),
          TextFormField(
            validator: (value) => EmailValidator.validate(value)
                ? null
                : "Please Enter a Valid E-mail.",
            controller: _emailController,
            onChanged: (String txt) {
              if (txt.isEmpty) {
                setState(() {
                  _btnEnabled = false;
                });
              } else {
                setState(() {
                  _btnEnabled = true;
                });
              }
            },
            onTap: () {},
          ),
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: RoundedLoadingButton(
              color: kColorBlue,
              valueColor: Colors.white,
              successColor: Colors.white,
              child: _btnEnabled == true
                  ? Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : Text('Enter Email to Reset Password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
              controller: _btnController,
              onPressed: _btnEnabled == true
                  ? () async {
                      User userData = User(email: _emailController.text);
                      if (_formKey.currentState.validate()) {
                        await _userController.forgotPassword(userData);
                      }
                      _btnController.reset();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
