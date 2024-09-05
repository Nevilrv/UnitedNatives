import 'dart:async';
import 'dart:io' show Platform;
import 'package:share_plus/share_plus.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/app.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/main.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/home2/drawer_controller.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import '../../routes/routes.dart';

var getIhPatient;

class ChangeState extends GetxController {
  bool isChange = false;
  setChange(bool val) {
    isChange = val;
    update();
  }
}

class DrawerPage extends StatefulWidget {
  final Function()? onTap;

  const DrawerPage({super.key, required this.onTap});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final UserController _userController = Get.find<UserController>();
  // ChangeState changeState = Get.find();

  Utils utils = Utils();
  String? subject;
  String? text;

  LogOutController logOutController = Get.put(LogOutController());
  PatientScheduledClassController patientScheduledClassController = Get.find();
  DrawerController2 drawerController2 = Get.put(DrawerController2());
  PatientHomeScreenController? patientHomeScreenController;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    getIhPatient = _userController.user.value.isIhUser;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return utils.patientProfile(
                                _userController.user.value.profilePic ?? '',
                                _userController.user.value.socialProfilePic ??
                                    '',
                                40);
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: w * 0.5,
                            child: Text(
                              '${_userController.user.value.firstName ?? ''} ${_userController.user.value.lastName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    _drawerItem(
                      image: 'home_icon',
                      text: 'Home',
                      onTap: () {
                        controller.closeDrawer();
                        controller.selectPage(0);
                        patientHomeScreenController =
                            Get.find<PatientHomeScreenController>()
                              ..getPatientHomePage();
                      },
                    ),

                    _drawerItem(
                      image: 'calendar',
                      text: 'My Appointments',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.myAppointments),
                    ),
                    _drawerItem(
                      image: 'person',
                      text: 'My Providers',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.myDoctors),
                    ),
                    _drawerItem(
                      image: 'remainder',
                      text: 'Reminders',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.remainder),
                    ),

                    ///TEMPORARY HIDE
                    /* _drawerItem(
                        image: 'researchdocs',
                        text: 'Research & Information',
                        onTap: () =>
                            Navigator.of(context).pushNamed(Routes.blogpage1),
                      ),*/
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, login) {
                        return _drawerItem(
                            image: 'logoo',
                            text: 'medical_centers',
                            onTap: () async {
                              Bloc.observer = AppBlocObserver();

                              setState(() {});
                              Get.to(const App1())
                                  ?.then((value) => AppBloc.loginCubit.onLogin(
                                        username: Prefs.getString(Prefs.EMAIL),
                                        password:
                                            Prefs.getString(Prefs.PASSWORD),
                                      ));
                              // Navigator.of(context).pushNamed(Routes.nearby);

                              // Future.delayed(Duration(seconds: 3), () {
                              // Navigator.of(context).pushNamed(Routes.nearby);
                              // });
                            } /*_onAlertWithCustomContentPressed(context),*/
                            //Nearby app
                            );
                      },
                    ),
                    _drawerItem(
                      image: 'self-monitering',
                      text: 'Self Monitoring',
                      onTap:
                          () /*  => _onAlertWithCustomContentPress(context),*/ {
                        Navigator.of(context).pushNamed(Routes.selfmonitoring);
                        //Self monitoring Screen
                      },
                    ),
                    _drawerItem(
                      image: 'phone',
                      text: 'Technical-Assistance',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.telehealth),
                    ),

                    ///TEMPORARY HIDE
                    _drawerItem(
                      image: 'survey',
                      text: 'Survey',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.survey),
                    ),

                    ///TEMPORARY HIDE
                    /*getIhPatient == '0'
                          ? _drawerItem(
                              image: 'schedule',
                              text: 'Schedule classes',
                              onTap: () async {
                                Navigator.of(context)
                                    .pushNamed(Routes.schedule_class);
                                await patientScheduledClassController
                                    .getClassListPatient(
                                        id: _userController.user.value.id,
                                        date: '');
                              },
                            )
                          : SizedBox(),*/
                    getIhPatient == '0'
                        ? _drawerItem(
                            image: 'services',
                            text: 'Services',
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.servicesPatient),
                          )
                        : const SizedBox(),

                    ///TEMPORARY HIDE
                    // _drawerItem(
                    //   image: 'request',
                    //   text: 'Request',
                    //   onTap: () =>
                    //       Navigator.of(context).pushNamed(Routes.request),
                    // ),
                    // _drawerItem(
                    //   image: 'directappointment',
                    //   text: 'Direct Appointment',
                    //   onTap: () => Navigator.of(context)
                    //       .pushNamed(Routes.directAppointment),
                    // ),
                    _drawerItem(
                      image: 'researchdocs',
                      text: 'Personal Notes',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.allPersonalMedicationNotesList),
                    ),
                    _drawerItem(
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
                    _drawerItem(
                      image: 'Contactus',
                      text: 'Contact Us',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.contact),
                    ),
                    _drawerItem(
                      image: 'Contactus',
                      text: 'Report a Problem',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.reportAProblem),
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, login) {
                        return _drawerItem(
                          image: 'logout',
                          text: 'Logout',
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Are you sure want to logout?',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          AppBloc.loginCubit.onLogout();
                                        });

                                        if (_userController.authResult !=
                                            null) {
                                          logOutController
                                              .patientLogOut()
                                              .then((value) async {
                                            _userController.signOut();
                                            addChatOnlineStatus(type: false);
                                            Prefs.clear();
                                            await Navigator
                                                .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.login,
                                                    (route) => false);
                                            TimerChange.timer?.cancel();
                                          });
                                        } else {
                                          setState(() {
                                            AppBloc.loginCubit.onLogout();
                                          });

                                          logOutController
                                              .patientLogOut()
                                              .then((value) async {
                                            Prefs.clear();
                                            addChatOnlineStatus(type: false);
                                            // Get.reset();
                                            await Navigator
                                                .pushNamedAndRemoveUntil(
                                                    context,
                                                    Routes.login,
                                                    (route) => false);
                                            // _showInterstitialAd();
                                            // Get.offAll(Routes.login);
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
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> addChatOnlineStatus({required bool type}) async {
    AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
    model.isOnline = type;
    model.lastSeen = DateTime.now().toString();
    await logOutController.addChatStatus(model: model);
    if (logOutController.addChatStatusApiResponse.status == Status.COMPLETE) {
    } else if (logOutController.addChatStatusApiResponse.status ==
        Status.ERROR) {}
  }

  InkWell _drawerItem(
      {required String image, required String text, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
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
            const SizedBox(width: 10),
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

/// _onAlertWithCustomContentPressed

/*_onAlertWithCustomContentPressed(context) {
  Alert(
      context: context,
      image: Image(
        image: AssetImage('assets/images/Location.gif'),
      ),
      title: "Coming Soon",
      content: Column(
        children: <Widget>[],
      ),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        )
      ]).show();
}*/

/// _onAlertWithCustomContentPress

/*_onAlertWithCustomContentPress(context) {
  Alert(
      context: context,
      image: Image(
        image: AssetImage('assets/images/Coming soon.gif'),
      ),
      title: "Coming Soon",
      content: Column(
        children: <Widget>[],
      ),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        )
      ]).show();
}*/
