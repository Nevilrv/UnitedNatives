import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/user.dart';

import '../../components/text_form_field.dart';
import '../../utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AdsController adsController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

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
          surfaceTintColor: Colors.transparent,
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
                        const Expanded(
                          child: SizedBox(height: 80),
                        ),
                        Text(
                          Translate.of(context)!.translate('forgot_password'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const WidgetForgot(),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        const Expanded(
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
  const WidgetForgot({super.key});

  @override
  State<WidgetForgot> createState() => _WidgetForgotState();
}

class _WidgetForgotState extends State<WidgetForgot> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
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
      return result;
    } else {
      return null;
    }
  }

  bool btnEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Translate.of(context)!.translate('email_dot'),
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            validator: (value) => EmailValidator.validate(value!)
                ? null
                : "Please Enter a Valid E-mail.",
            controller: _emailController,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  btnEnabled = false;
                });
              } else {
                setState(() {
                  btnEnabled = true;
                });
              }
            },
            hintText: '',
          ),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: RoundedLoadingButton(
              color: kColorBlue,
              valueColor: Colors.white,
              successColor: Colors.white,
              controller: _btnController,
              onPressed: btnEnabled == true
                  ? () async {
                      User userData = User(email: _emailController.text);
                      if (_formKey.currentState!.validate()) {
                        await _userController.forgotPassword(userData);
                      }
                      _btnController.reset();
                    }
                  : null,
              child: btnEnabled == true
                  ? const Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text('Enter Email to Reset Password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
