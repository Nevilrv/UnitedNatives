import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/login_verification.dart';
import 'package:doctor_appointment_booking/model/pin_status_model.dart';
import 'package:doctor_appointment_booking/model/user.dart';
import 'package:doctor_appointment_booking/pages/login/phoneAuthScreen3.dart';
import 'package:doctor_appointment_booking/pages/resources/show_all_screen.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DoctorLoginPage extends StatefulWidget {
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  // LocalAuthentication _auth = LocalAuthentication();
  // bool _checkBio = false;
  // bool _isBioFinger = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserController userController = Get.put<UserController>(UserController());
  UserCredential authResult;
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    print('HELLO');

    // _checkBiometrics();
    // _listBioAndFindFingerType();
    // _startAuth();
  }

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        key: _scaffoldKey,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(height: 80),
                        ),
                        Row(children: [
                          Text(
                            Translate.of(context).translate('Provider Login'),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.fingerprint,
                          //     size: 80,
                          //   ),
                          //   onPressed: _startAuth,
                          //   iconSize: 100,
                          // ),
                        ]),
                        SizedBox(
                          height: 30,
                        ),
                        WidgetSignin(),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.forgotPassword);
                            },
                            child: Text(
                              Translate.of(context)
                                  .translate('forgot_yout_password'),
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),

                        /// TEMP HIDE DON'T DELETE GOOGLE LOGIN CODE ////

                        /*Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                endIndent: 20,
                              ),
                            ),
                            Text(
                              Translate.of(context).translate('social_login'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                indent: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0xffff4f38),
                                Color(0xff1ff355d),
                              ], tileMode: TileMode.clamp),
                            ),
                            child: RoundedLoadingButton(
                                color: Colors.red,
                                valueColor: Colors.white,
                                successColor: Colors.red,
                                child: Icon(
                                  CustomIcons.googlePlus,
                                  color: Colors.white,
                                ),
                                controller: _btnController,
                                onPressed: () async {
                                  _userController.authResult =
                                      await _userController
                                          .socialUserRegister();

                                  setState(() {
                                    if (_userController.authResult != null) {
                                      _btnController.success();
                                    }
                                    _btnController.reset();
                                  });
                                  // Get.toNamed(Routes.phoneAuthScreen4);

                                  // print("Email===>${authResult.user.email}");

                                  if (_userController.authResult == null) {
                                    Navigator.pop(context);
                                  } else {
                                    Get.toNamed(Routes.phoneAuthScreen7);
                                    Utils.showSnackBar(
                                        "${_userController.authResult?.user?.email} successfully login! ",
                                        "Enter your Secret PIN");
                                  }
                                }),
                            // RoundedLoadingButton(
                            //   child:
                            // ),
                          ),
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 99,
                              height: 99,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    'assets/images/login_patient.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            textSize: 24,
                            onPressed:
                                () => /*_onAlertWithCustomContentPressed(context), */
                                    Navigator.of(context).popAndPushNamed(
                                        Routes.login), //Doctor login path
                            text: Translate.of(context)
                                .translate('I am a Client')),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ShowAllScreen();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff2e83f8),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 45)),
                          child: Text(
                            'Resources',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 24),
                          ),
                        ),
                        SafeArea(
                          child: Center(
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    Translate.of(context)
                                        .translate('Register as Provider'),
                                    style: TextStyle(
                                      color: Color(0xffbcbcbc),
                                      fontSize: 20,
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(2),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.docsignup);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      Translate.of(context)
                                          .translate('Click here'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
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

  // void _checkBiometrics() async {
  //   try {
  //     final bio = await _auth.canCheckBiometrics;
  //     setState(() {
  //       _checkBio = bio;
  //     });
  //     print('Biometrics = $_checkBio');
  //   } catch (e) {}
  // }

  // void _listBioAndFindFingerType() async {
  //   List<BiometricType> _listType;
  //   try {
  //     _listType = await _auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }
  //   print('List Biometrics = $_listType');
  //
  //   if (_listType.contains(BiometricType.fingerprint)) {
  //     setState(() {
  //       _isBioFinger = true;
  //     });
  //     print('Fingerprint is $_isBioFinger');
  //   }
  // }
  //
  // void _startAuth() async {
  //   bool _isAuthenticated;
  //   try {
  //     _isAuthenticated = await _auth.authenticateWithBiometrics(
  //       localizedReason: 'Scan Your Fingerprint',
  //       useErrorDialogs: true,
  //       stickyAuth: true,
  //       //androidAuthStrings: null,
  //       //iOSAuthStrings: null
  //     );
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }
  //   if (_isAuthenticated) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (c) => Home()));
  //   }
  // }
}

class WidgetSignin extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  WidgetSignin({this.scaffoldKey});

  @override
  _WidgetSigninState createState() => _WidgetSigninState();
}

class _WidgetSigninState extends State<WidgetSignin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserController _userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    _emailController.text;
    _passwordController.text;
    super.initState();
  }

  LoginVerificationData loginVerificationData = LoginVerificationData();
  PINStatusModel pinStatusModelData = PINStatusModel();

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
          CustomTextFormField(
            textInputAction: TextInputAction.next,
            controller: _emailController,
            hintText: 'contact@sataware.com',
            validator: (text) {
              if (text.isEmpty) {
                setState(() {
                  isLoading = false;
                });
                return 'Please Enter Your Email';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Translate.of(context).translate('password_dot'),
            style: kInputTextStyle,
          ),
          CustomTextFormField(
            textInputAction: TextInputAction.done,
            controller: _passwordController,
            hintText: '* * * * * *',
            obscureText: true,
            validator: (text) {
              if (text.isEmpty) {
                setState(() {
                  isLoading = false;
                });
                return 'Please Enter Your Password';
              }
              return null;
            },
          ),
          SizedBox(
            height: 35,
          ),
          isLoading
              // ? Center(
              //     child: CircularProgressIndicator(
              //     strokeWidth: 1,
              //   ))
              ? Container(
                  height: 60,
                  child: Center(
                    child: Utils.circular(height: 60),
                  ),
                )
              : CustomButton(
                  textSize: 24,
                  // onPressed: () {
                  //   Navigator.of(context).popAndPushNamed(Routes.home2);
                  // },
                  // onPressed: () async {
                  //   await _userController.userLogin(LogInType.NORMAL, 2,
                  //       _emailController.text,
                  //       _passwordController.text, "");
                  // },
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (_formKey.currentState.validate()) {
                      _userController.loginData = User(
                        email: _emailController.text,
                        password: _passwordController.text,
                        userType: "2",
                      );

                      loginVerificationData =
                          await _userController.loginVerificationDetails(
                              _userController.loginData?.email,
                              _userController.loginData?.password);

                      if (loginVerificationData != null) {
                        pinStatusModelData = await _userController
                            .statusPIN(loginVerificationData.id);

                        if (pinStatusModelData.pinStatusData != null) {
                          if (pinStatusModelData.pinStatusData.requestStatus ==
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

                            await Future.delayed(Duration(milliseconds: 500))
                                .then((value) => Utils.showSnackBar(
                                    'Reset Password',
                                    'Admin Verified Pin Reset Request'));
                          } else {
                            await _userController.loginVerification(
                                _userController.loginData.email,
                                _userController.loginData.password,
                                _passwordController.text);
                          }
                        } else {
                          await _userController.loginVerification(
                              _userController.loginData.email,
                              _userController.loginData.password,
                              _passwordController.text);
                        }
                      }

                      setState(() {
                        isLoading = false;
                      });

                      //await Navigator.pushNamed(context, Routes.phoneAuthScreen);
                      // await _userController.userRegister(userData, 1,
                      //     useProfilePic: _image);
                    }
                  },
                  text: Translate.of(context).translate('login'),
                )
        ],
      ),
    );
  }
}
