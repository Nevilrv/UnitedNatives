import 'dart:async';
import 'dart:io' show Platform;
import 'package:share_plus/share_plus.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/app.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/home2/drawer_controller.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart' as utils;
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;

var getIhDoctor;
var getIhDoctorData;

class DocDrawerPage extends StatefulWidget {
  final Function()? onTap;

  const DocDrawerPage({super.key, required this.onTap});

  @override
  State<DocDrawerPage> createState() => _DocDrawerPageState();
}

class _DocDrawerPageState extends State<DocDrawerPage> {
  final UserController _userController = Get.find<UserController>();

  LogOutController logOutController = Get.put(LogOutController());
  String? subject;
  String? text;

  DrawerController2 drawerController2 = Get.put(DrawerController2());
  DoctorHomeScreenController? doctorHomeScreenController;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    getIhDoctor = _userController.user.value.isIhUser;

    // String subject = 'Invite your Friends and get a Free promo Code';
    // String text = 'promo code 2FK876G';
    if (Platform.isAndroid) {
      subject =
          'Hi there, I hope United Natives app will be helpful for you. Here is the link to install UN App: com.sataware.unitednativesllc&hl  Stay Safe!';
      text =
          'Hi there, I hope United Natives app will be helpful for you. Here is the link to install UN App: ${'https://play.google.com/store/apps/details?id=com.sataware.unitednativesllc&hl=en_IN&gl=US'}  Stay Safe!';
      // https://apps.apple.com/in/app/Indigenous%20Health/id1603407096
    } else if (Platform.isIOS) {
      subject =
          'Hi there, I hope United Natives app will be helpful for you. Here is the link to install UN App: com.sataware.unitednativesllc&hl  Stay Safe!';
      text =
          'Hi there, I hope United Natives app will be helpful for you. Here is the link to install UN App: ${'https://apps.apple.com/app/united-natives/id6483363927'}  Stay Safe!';
      // 'Hi there, I hope IH app will be helpful for you. Here is the link to install IH app: ${'https://play.google.com/store/apps/details?id=com.sataware.indigenoushealth&hl=en_IN&gl=US'}  Stay Safe!';

      // https://apps.apple.com/in/app/Indigenous%20Health/id1603407096
      // https://apps.apple.com/in/app/Indigenous%20Health/id1603407096
    }

    return GetBuilder<DrawerController2>(builder: (controller) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Obx(() {
                            return utils.Utils().patientProfile(
                                _userController.user.value.profilePic ?? '',
                                _userController.user.value.socialProfilePic ??
                                    '',
                                40);
                          }),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: w * 0.5,
                            child: Text(
                              '${_userController.user.value.firstName} ${_userController.user.value.lastName}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _docdrawerItem(
                      image: 'home_icon',
                      text: 'Home',
                      onTap: () {
                        controller.closeDrawer();
                        controller.selectPage(0);
                        doctorHomeScreenController =
                            Get.put(DoctorHomeScreenController())
                              ?..getDoctorHomePage()
                              ..filterData();
                      },
                    ),

                    _docdrawerItem(
                      image: 'calendar',
                      text: 'My Appointments',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.appointments),
                    ),

                    _docdrawerItem(
                      image: 'person',
                      text: 'My Clients',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.mypatient),
                    ),

                    /// TEMPORARY HIDE
                    // Prefs.getString(Prefs.IsAdmin) == '2'
                    //     ? _docdrawerItem(
                    //         image: 'hospitalstructure',
                    //         text: 'Room Layout',
                    //         onTap: () => Navigator.of(context)
                    //             .pushNamed(Routes.hospitalStructure),
                    //       )
                    //     : SizedBox(),

                    /// TEMPORARY HIDE
                    // getIhDoctor =='0'?
                    //      _docdrawerItem(
                    //         image: 'hospitalstructure',
                    //         text: 'Room Layout',
                    //         onTap: () => Navigator.of(context)
                    //             .pushNamed(Routes.hospitalStructure),
                    //       )
                    //     : SizedBox(),

                    /// TEMPORARY HIDE
                    // getIhDoctor=='0'?_docdrawerItem(
                    //   image: 'Availability',
                    //   text: 'Availability',
                    //   onTap: () =>
                    //       Navigator.of(context).pushNamed(Routes.availability),
                    // ):SizedBox(),

                    /// TEMPORARY HIDE
                    /*_docdrawerItem(
                        image: 'researchdocs',
                        text: 'Add Class',
                        onTap: () =>
                            Navigator.of(context).pushNamed(Routes.addClass),
                      ),*/
                    _docdrawerItem(
                      image: 'Availability',
                      text: 'Availability',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.availability),
                    ),
                    _docdrawerItem(
                      image: 'remainder',
                      text: 'Reminders',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.remainder),
                    ),

                    /// TEMPORARY HIDE
                    // _docdrawerItem(
                    //   image: 'researchdocs',
                    //   text: 'Research & Information',
                    //   onTap: () =>
                    //       Navigator.of(context).pushNamed(Routes.blogpage),
                    // ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, login) {
                        return _docdrawerItem(
                            image: 'logoo',
                            text: 'medical_centers',
                            onTap: () async {
                              // log('USER NAME ${Prefs.getString(Prefs.EMAIL)}');
                              // log('USER NAME ${Prefs.getString(Prefs.normalPassword)}');
                              // Bloc.observer = AppBlocObserver();
                              Get.to(const App1()) /*.then(
                                  (value) => AppBloc.loginCubit.onLogin(
                                    username: Prefs.getString(Prefs.EMAIL),
                                    password: Prefs.getString(Prefs.PASSWORD),
                                  ),
                                )*/
                                  ;
                              // AppBloc.loginCubit.onLogin(
                              //   username: Prefs.getString(Prefs.EMAIL),
                              //   password: Prefs.getString(Prefs.normalPassword),
                              // );
                              // Future.delayed(Duration(seconds: 2), () {
                              // Navigator.of(context).pushNamed(Routes.nearby);
                              // });
                            } /*_onAlertWithCustomContentPressed(context),*/
                            //Nearby app
                            );
                      },
                    ),

                    /// TEMPORARY HIDE
                    /*
                      _docdrawerItem(
                        image: 'nearby',
                        text: 'Medical Center',
                        onTap: () => Navigator.of(context).pushNamed(Routes.nearby),
                      ),*/

                    _docdrawerItem(
                      image: 'phone',
                      text: 'Technical-Assistance',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.telehealth),
                    ),

                    _docdrawerItem(
                      image: 'survey',
                      text: 'Survey',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.survey),
                    ),

                    /// TEMPORARY HIDE
                    /*getIhDoctor == '0'
                          ? _docdrawerItem(
                              image: 'schedule',
                              text: 'Schedule classes',
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routes.dr_schedule_class),
                            )
                          : SizedBox(),*/

                    getIhDoctor == '0'
                        ? _docdrawerItem(
                            image: 'services',
                            text: 'Services',
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.servicesDoctor),
                          )
                        : const SizedBox(),
                    _docdrawerItem(
                      image: 'Contactus',
                      text: 'Contact Us',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.contact),
                    ),
                    _docdrawerItem(
                      image: 'Contactus',
                      text: 'Report a Problem',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.reportAProblem),
                    ),
                    _docdrawerItem(
                      image: 'group',
                      text: 'Invite Friends',
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                          text.toString(),
                          subject: subject,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    ),

                    _docdrawerItem(
                        image: 'logout',
                        text: 'Logout',
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Are you sure want to logout?'),
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
                                      if (_userController.authResult != null) {
                                        await logOutController
                                            .doctorLogOut()
                                            .then(
                                          (value) async {
                                            _userController.signOut();
                                            Prefs.clear();
                                            AppBloc.loginCubit.onLogout();
                                            await Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    Routes.doctorlogin,
                                                    (Route<dynamic> route) =>
                                                        false);

                                            TimerChange.timer?.cancel();
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          AppBloc.loginCubit.onLogout();
                                        });

                                        await logOutController
                                            .doctorLogOut()
                                            .then((value) async {
                                          Prefs.clear();
                                          // Get.reset();
                                          // Get.offAndToNamed(Routes.doctorlogin);
                                          await Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  Routes.doctorlogin,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        });
                                      }

                                      AddChatOnlineStatusReqModel model =
                                          AddChatOnlineStatusReqModel();
                                      model.isOnline = false;
                                      model.lastSeen =
                                          DateTime.now().toUtc().toString();

                                      await logOutController.addChatStatus(
                                          model: model);
                                      if (logOutController
                                              .addChatStatusApiResponse
                                              .status ==
                                          Status.COMPLETE) {
                                      } else if (logOutController
                                              .addChatStatusApiResponse
                                              .status ==
                                          Status.ERROR) {}

                                      controller.closeDrawer();
                                      controller.selectPage(0);
                                    },
                                    child: const Text(
                                      'Log out',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> addChatOnlineStatus({bool? type}) async {
    AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
    model.isOnline = type;
    model.lastSeen = DateTime.now().toString();
    await logOutController.addChatStatus(model: model);
    if (logOutController.addChatStatusApiResponse.status == Status.COMPLETE) {
    } else if (logOutController.addChatStatusApiResponse.status ==
        Status.ERROR) {}
  }

  InkWell _docdrawerItem({
    required String image,
    required String text,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        //this.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 65,
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/$image.png',
              color: Colors.grey.shade100,
              height: Get.height * 0.043,
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              Translate.of(context)!.translate(text),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
