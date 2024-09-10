import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/viewModel/user_update_contoller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/main.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/appointment/doctor_appointment.dart';
import 'package:united_natives/pages/home/nav_transition/nav_slide_from_bottom.dart';
import 'package:united_natives/pages/home2/drawer_controller.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:united_natives/viewModel/rate_and%20_contactus_viewModel.dart';

import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../docdrawer/drawer_page.dart';
import '../doctormessages/messages_page.dart';
import '../doctorprofile/profile_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';
import 'widgets/widgets.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> with WidgetsBindingObserver {
  DoctorHomeScreenController? doctorHomeScreenController;
  UserController userController = Get.put(UserController());
  final UserUpdateController _userUpdateController =
      Get.put<UserUpdateController>(UserUpdateController());

  RateContactUsController rateContactUsController =
      Get.put(RateContactUsController());

  LogOutController logOutController = Get.put(LogOutController());
  @override
  void initState() {
    Bloc.observer = AppBlocObserver();
    AppBloc.loginCubit.onLogin(
      username: Prefs.getString(Prefs.EMAIL),
      password: Prefs.getString(Prefs.PASSWORD),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Prefs.getString(Prefs.isLoginFirst) == "1") {
        await setTempPasswordDialog();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userController.user.value.medicalCenterID!.isEmpty ||
          userController.user.value.state!.isEmpty ||
          userController.user.value.city!.isEmpty) {
        editProfileDialog();
      }
    });

    doctorHomeScreenController = Get.put(DoctorHomeScreenController())
      ?..callDoctorHomeScreenApi();

    addChatOnlineStatus(type: true);
    drawerController2.initPageView();

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  Future<void> refresh() async {
    await doctorHomeScreenController?.getDoctorHomePage();
    await doctorHomeScreenController?.filterData();
  }

  editProfileDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Update Profile",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Please complete your profile details to access the app features."),
            SizedBox(height: 15),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Go to edit profile"),
            onPressed: () {
              _userUpdateController.editProfileFlag.value = true;
              Navigator.of(context).pop();

              Navigator.of(context).pushNamed(Routes.doceditprofile);
            },
          ),
        ],
      ),
    );
  }

  Future<String?> setTempPasswordDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Reset your temporary password",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Please reset your temporary password. Your password is temporary generated by admin so for your security please reset your password and make secure your account."),
            SizedBox(height: 15),
            Text(
              "Setting menu > Change Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Go to setting"),
                onPressed: () {
                  Navigator.of(context).pop();
                  // _selectPage(3);
                  drawerController2.selectPage(3);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> addChatOnlineStatus({required bool type}) async {
    AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
    model.isOnline = type;
    model.lastSeen = DateTime.now().toUtc().toString();
    await logOutController.addChatStatus(model: model);
    if (logOutController.addChatStatusApiResponse.status == Status.COMPLETE) {
      log('COMPLETE');
    } else if (logOutController.addChatStatusApiResponse.status ==
        Status.ERROR) {
      log('ERROR');
    }
  }

  bool filterLoading = false;
  int itemCount = 0;

  @override
  void dispose() {
    drawerController2.disposePageController();
    super.dispose();
    // _pageController.dispose();
  }

  // _selectPage(int index) {
  //   if (_pageController.hasClients) _pageController.jumpToPage(index);
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  final _pages = [
    const Home2Page(),
    const DocProfilePage(),
    const DoctorMessagesPage(),
    const SettingsPage(),
  ];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      log('>>>>>> RESUMED<<<<<<<<');
      addChatOnlineStatus(type: true);
    } else if (state == AppLifecycleState.detached) {
      log('>>>>>> DETACHED<<<<<<<<');
    } else if (state == AppLifecycleState.inactive) {
      log('>>>>>> INACTIVE<<<<<<<<');
    } else if (state == AppLifecycleState.paused) {
      log('>>>>>> PAUSED<<<<<<<<');
      addChatOnlineStatus(type: false);
    }
  }

  DrawerController2 drawerController2 = Get.put(DrawerController2());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<DrawerController2>(builder: (controller) {
      return Stack(
        children: <Widget>[
          DocDrawerPage(
            onTap: () async {
              // setState(
              //   () {
              //     xOffset = 0;
              //     yOffset = 0;
              //     scaleFactor = 1;
              //     isDrawerOpen = false;
              //     refresh();
              //   },
              // );
              controller.closeDrawer();
              await refresh();
            },
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(
                controller.xOffset, controller.yOffset, 0)
              ..scale(controller.scaleFactor)
              ..rotateY(controller.isDrawerOpen ? -0.5 : 0),
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius:
                  BorderRadius.circular(controller.isDrawerOpen ? 40 : 0.0),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(controller.isDrawerOpen ? 40 : 0.0),
              child: Scaffold(
                appBar: AppBar(
                  surfaceTintColor: Colors.transparent,
                  leading: controller.isDrawerOpen
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () async {
                            // setState(
                            //   () {
                            //     xOffset = 0;
                            //     yOffset = 0;
                            //     scaleFactor = 1;
                            //     isDrawerOpen = false;
                            //     refresh();
                            //   },
                            // );
                            controller.closeDrawer();
                            await refresh();
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            // setState(() {
                            //   xOffset = size.width - size.width / 3;
                            //   yOffset = size.height * 0.1;
                            //   scaleFactor = 0.8;
                            //   isDrawerOpen = true;
                            // });

                            controller.openDrawer(size);
                          },
                        ),
                  title: const AppBarTitleWidget(),
                  actions: <Widget>[
                    controller.selectedIndex == 2
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.messagePatient);
                              TimerChange.timer?.cancel();
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.docnotification)
                                  .then((value) => refresh());
                            },
                            icon: const Icon(
                              Icons.notifications_active_sharp,
                            ),
                          ),
                  ],
                ),
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    // setState(() {
                    //   _selectedIndex = index;
                    // });
                  },
                  children: _pages,
                ),
                floatingActionButton:
                    KeyboardVisibilityBuilder(builder: (context, visible) {
                  return visible
                      ? const SizedBox()
                      : Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x202e83f8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.push(
                                    context,
                                    NavSlideFromBottom(
                                        page: const MyAppointmentsDoctor()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kColorBlue,
                                ),
                                child: const Icon(
                                  Icons.perm_contact_calendar,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                }),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: BottomAppBar(
                  elevation: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: NavBarItemWidget(
                          onTap: () {
                            controller.selectPage(0);
                            TimerChange.timer?.cancel();
                          },
                          iconData: Icons.home,
                          text: Translate.of(context)!.translate('home'),
                          color: controller.selectedIndex == 0
                              ? kColorBlue
                              : Colors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavBarItemWidget(
                          onTap: () {
                            // TimerChange().docTimerchange();
                            // TimerChange.timer.cancel();
                            // TimerChange().docTimerchange();
                            controller.selectPage(2);
                          },
                          iconData: Icons.message,
                          text: Translate.of(context)!.translate('messages'),
                          color: controller.selectedIndex == 2
                              ? kColorBlue
                              : Colors.grey,
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavBarItemWidget(
                          onTap: () async {
                            controller.selectPage(3);
                            String url =
                                '${Constants.baseUrl + Constants.patientRating}/${userController.user.value.id}';
                            String url1 =
                                '${Constants.baseUrl + Constants.doctorRating}/${userController.user.value.id}';

                            Map<String, String> header1 = {
                              "Authorization":
                                  'Bearer ${Prefs.getString(Prefs.BEARER)}',
                            };
                            http.Response response1 = await http.get(
                                Uri.parse(Prefs.getString(Prefs.USERTYPE) == '1'
                                    ? url
                                    : url1),
                                headers: header1);

                            var data = jsonDecode(response1.body);

                            if (data["status"] == 'Fail') {
                              rateContactUsController.setRate(rate1: '0');
                            } else {
                              log('rating ${data["data"]['rating']}');
                              rateContactUsController.setRate(
                                  rate1: '${data["data"]['rating']}');
                            }

                            // TimerChange.timer.cancel();
                          },
                          iconData: Icons.settings,
                          text: Translate.of(context)!.translate('settings'),
                          color: controller.selectedIndex == 3
                              ? kColorBlue
                              : Colors.grey,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NavBarItemWidget(
                          onTap: () {
                            // AppNotificationHandler.sendMessage(
                            //     token:
                            //         // 'cXyFoFNt20PTsjg8ejdcGS:APA91bFT2AmyR-O0i0mvKvcMz8faW7UaCwoyrMCtaGOA3N5jp5JXNwZy3tpuq67mER6Uh-dowu7e2OPcLAon7lG6lU-SCVUhZhhZwf32H9_K-sWd8yh7c18IQ-3POX0aEDqgETQzMQg4');
                            //         'dR1Gt6haTXGyqZU76h7XAR:APA91bE6l1CM7I4-Cc6bt5riMZbkxyN00979ZFF1nrfSGxZ8HBXLk4P4chatthpgbQhGhlUkYSIihSO0TkpiIDuyDVe0EkiFl2ibHpUtMaP2h7SzXg5Db1cV-fHJW2XRy1GQM1lBDAfO3dps');

                            controller.selectPage(1);
                            final timer = TimerChange.timer;
                            if (timer != null) {
                              timer.cancel();
                            }
                          },
                          iconData: Icons.person,
                          text: Translate.of(context)!.translate('profile'),
                          color: controller.selectedIndex == 1
                              ? kColorBlue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

onAlertWithCustomContentPress(context) {
  Alert(
      context: context,
      image: const Image(
        image: AssetImage('assets/images/Coming soon.gif'),
      ),
      title: "Coming Soon",
      content: const Column(
        children: <Widget>[],
      ),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        )
      ]).show();
}
