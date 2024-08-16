import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/main.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/pages/home2/drawer_controller.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:united_natives/viewModel/rate_and%20_contactus_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../drawer/drawer_page.dart';
import '../messages/messages_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';
import 'widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final UserController userController = Get.find();
  PatientScheduledClassController patientScheduledClassController =
      Get.put(PatientScheduledClassController());
  PatientHomeScreenController patientHomeScreenController = Get.find();
  RateContactUsController rateContactUsController =
      Get.put(RateContactUsController());
  LogOutController logOutController = Get.put(LogOutController());
  final _pages = [
    const HomePage(),
    const ProfilePage(),
    const MessagesPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    Bloc.observer = AppBlocObserver();
    AppBloc.loginCubit.onLogin(
      username: Prefs.getString(Prefs.EMAIL),
      password: Prefs.getString(Prefs.PASSWORD),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bookAppointmentController.getMedicalCenter();
    });
    WidgetsBinding.instance.addObserver(this);
    addChatOnlineStatus(type: true);
    patientScheduledClassController.getClassListPatient(
        id: userController.user.value.id!, date: '');
    drawerController2.initPageView();
    super.initState();
  }

  final BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    drawerController2.disposePageController();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      addChatOnlineStatus(type: true);
    } else if (state == AppLifecycleState.detached) {
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.paused) {
      addChatOnlineStatus(type: false);
    }
  }

  Future<void> addChatOnlineStatus({required bool type}) async {
    AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
    model.isOnline = type;
    model.lastSeen = DateTime.now().toUtc().toString();
    await logOutController.addChatStatus(model: model);
  }

  var categoryOfStatesDropDowns;
  var categoryOfMedicalCenterDropDowns;
  List categoryOfStatess = [];
  final searchController = TextEditingController();
  var chooseStateId;
  // var chooseStateName;

  /// GET STATES
  // Future getStates() async {
  //   http.Response response = await http.get(
  //     Uri.parse(
  //         '${Constants.baseUrl + Constants.getAllStates}'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);
  //     int allStateDoctorCount = 0;
  //     result.forEach((element) {
  //       allStateDoctorCount += int.parse(element['doctors_count'].toString());
  //     });
  //     setState(() {
  //       categoryOfStatess = result;
  //       categoryOfStatess.insert(
  //         0,
  //         {
  //           "id": "0",
  //           "name": "All States",
  //           "code": "",
  //           "created_at": "",
  //           "updated_at": "",
  //           "doctors_count": allStateDoctorCount
  //         },
  //       );
  //     });
  //
  //     return result;
  //   } else {}
  // }

  /// ALL MEDICAL CENTER
  // Future getMedicalCenter({String location}) async {
  //   String url;
  //   Map<String, String> body;
  //   if (location == 'All States' || location == '' || location == null) {
  //     body = {"state_name": ""};
  //   } else {
  //     body = {"state_name": "$location"};
  //   }
  //   url =
  //       'http://www.unhbackend.com/AppServices/Patient/get_medical_center_detail';
  //
  //   Map<String, String> header = {
  //     "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
  //     "Content-Type": "application/json",
  //   };
  //
  //   http.Response response = await http.post(Uri.parse(url),
  //       body: jsonEncode(body), headers: header);
  //   if (response.statusCode == 200) {
  //     var result = jsonDecode(response.body);
  //
  //     setState(() {
  //       categoryOfMedicalCenter = result;
  //     });
  //
  //     return result;
  //   } else {}
  // }
  /// ACTIVE MEDICAL CENTER
  // Future getMedicalCenter({String stateName}) async {
  //   _bookAppointmentController.medicalLoader.value = true;
  //
  //   String url;
  //   String state = "";
  //   url =
  //       '${Constants.medicalCenterURL}listar/v1/active-centres';
  //   String url1 =
  //       '${Constants.medicalCenterURL}listar/v1/active-centres?location_slug=$state';
  //
  //   Map<String, String> header = {
  //     "Content-Type": "application/json",
  //   };
  //   http.Response response = await http
  //       .get(Uri.parse(/*stateName != "" ? */ url1 /*:url*/), headers: header);
  //   print("response.body--->${response.body}");
  //   print("response.statusCode--->${response.statusCode}");
  //
  //   if (response.statusCode == 200) {
  //     if (response.body != "" || response.body != null) {
  //       var result = jsonDecode(response.body);
  //       print("result--->$result");
  //
  //       setState(() {
  //         categoryOfMedicalCenter = result['data']['locations'];
  //
  //         categoryOfMedicalCenter.forEach((element) {
  //           if (element['post_title'].toString() == "MVRP") {
  //             medicalName =
  //                 categoryOfMedicalCenter.first['post_title'].toString();
  //             chooseMedicalCenter =
  //                 categoryOfMedicalCenter.first['ID'].toString();
  //             _bookAppointmentController.getSpecialities(false.obs,
  //                 stateId: chooseStateId ?? "",
  //                 medicalCenterId: chooseMedicalCenter ?? '');
  //           }
  //         });
  //       });
  //
  //       _bookAppointmentController.medicalLoader.value = false;
  //       return result;
  //     }
  //   } else {
  //     _bookAppointmentController.medicalLoader.value = false;
  //     print('ERROR IN GETTING MEDICAL CENTER DETAILS');
  //   }
  // }

  int selected = 0;

  Future docFilter(
      {@required var userId,
      @required var specialityId,
      @required var state,
      @required var city}) async {
    var header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };

    Map<String, dynamic> body = {
      "user_id": userId,
      "speciality_id": specialityId,
      "state": state,
      "city": city
    };
    http.Response response = await http.post(
      Uri.parse(Constants.baseUrl + Constants.getAllDoctorByLocation),
      headers: header,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  DrawerController2 drawerController2 = Get.put(DrawerController2());

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    final h = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: Get.find<UserController>().user.value == null ? true : false,
      child: GetBuilder<DrawerController2>(builder: (controller) {
        return Stack(
          children: <Widget>[
            DrawerPage(
              onTap: () {
                controller.closeDrawer();
                patientHomeScreenController.getPatientHomePage();
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
                            iconSize: 40,
                            onPressed: () {
                              controller.closeDrawer();
                              patientHomeScreenController.getPatientHomePage();
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.menu,
                              size: 30,
                            ),
                            onPressed: () {
                              controller
                                  .openDrawer(MediaQuery.of(context).size);
                            },
                          ),
                    title: const AppBarTitleWidget(),
                    actions: <Widget>[
                      controller.selectedIndex == 2
                          ? IconButton(
                              onPressed: () async {
                                TimerChange.timer?.cancel();

                                Navigator.of(context).pushNamed(Routes.message);
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.patientNotification)
                                    .then((value) => patientHomeScreenController
                                        .getPatientHomePage());
                              },
                              icon: const Icon(Icons.notifications_on_rounded,
                                  size: 30),
                            )
                    ],
                  ),
                  body: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      // _selectedIndex.value = index;
                    },
                    children: _pages,
                  ),
                  floatingActionButton: KeyboardVisibilityBuilder(
                    builder: (context, visible) {
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GetBuilder<
                                            BookAppointmentController>(
                                          builder: (controller) {
                                            return StatefulBuilder(
                                              builder: (context, setState1) {
                                                return SimpleDialog(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 500),
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            top: 10,
                                                            right: 10,
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 28),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const SizedBox(
                                                                  height: 20),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  child: Text(
                                                                    Translate.of(
                                                                            context)!
                                                                        .translate(
                                                                            'choose_health_center'),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleLarge
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ),

                                                              /// STATE
                                                              // SizedBox(height: 20),
                                                              //
                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     showDialog(
                                                              //       context: context,
                                                              //       builder:
                                                              //           (context) {
                                                              //         return WillPopScope(
                                                              //           onWillPop:
                                                              //               () async {
                                                              //             return false;
                                                              //           },
                                                              //           child:
                                                              //               StatefulBuilder(
                                                              //             builder:
                                                              //                 (context,
                                                              //                     setState234) {
                                                              //               return Dialog(
                                                              //                 backgroundColor:
                                                              //                     Colors.transparent,
                                                              //                 child:
                                                              //                     ConstrainedBox(
                                                              //                   constraints:
                                                              //                       BoxConstraints(
                                                              //                     maxHeight:
                                                              //                         h * 0.6,
                                                              //                   ),
                                                              //                   child:
                                                              //                       Container(
                                                              //                     decoration:
                                                              //                         BoxDecoration(
                                                              //                       color: _isDark ? Colors.grey.shade800 : Colors.white,
                                                              //                       borderRadius: BorderRadius.circular(5),
                                                              //                     ),
                                                              //                     height:
                                                              //                         h * 0.6,
                                                              //                     width:
                                                              //                         w * 0.85,
                                                              //                     child:
                                                              //                         Padding(
                                                              //                       padding: EdgeInsets.only(
                                                              //                         top: h * 0.015,
                                                              //                         left: h * 0.015,
                                                              //                         right: h * 0.015,
                                                              //                         bottom: 0,
                                                              //                       ),
                                                              //                       child: Column(
                                                              //                         children: [
                                                              //                           Row(
                                                              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //                             children: [
                                                              //                               Expanded(
                                                              //                                 child: Container(
                                                              //                                   decoration: BoxDecoration(
                                                              //                                     color: _isDark ? Colors.grey.shade800 : Colors.white,
                                                              //                                     borderRadius: BorderRadius.circular(25),
                                                              //                                     border: Border.all(color: Colors.grey),
                                                              //                                   ),
                                                              //                                   height: 48,
                                                              //                                   child: Center(
                                                              //                                     child: TextField(
                                                              //                                       controller: searchController,
                                                              //                                       onChanged: (value) {
                                                              //                                         setState234(() {});
                                                              //                                       },
                                                              //                                       decoration: InputDecoration(
                                                              //                                         contentPadding: EdgeInsets.only(top: 10, left: 16),
                                                              //                                         suffixIcon: Icon(Icons.search),
                                                              //                                         enabledBorder: InputBorder.none,
                                                              //                                         focusedBorder: InputBorder.none,
                                                              //                                         hintText: 'Search...',
                                                              //                                       ),
                                                              //                                     ),
                                                              //                                   ),
                                                              //                                 ),
                                                              //                               ),
                                                              //                               SizedBox(
                                                              //                                 width: 15,
                                                              //                               ),
                                                              //                               GestureDetector(
                                                              //                                 onTap: () {
                                                              //                                   Navigator.pop(context, stateName);
                                                              //
                                                              //                                   searchController.clear();
                                                              //                                 },
                                                              //                                 child: Icon(
                                                              //                                   Icons.clear,
                                                              //                                   color: Colors.black,
                                                              //                                   size: 28,
                                                              //                                 ),
                                                              //                               ),
                                                              //                             ],
                                                              //                           ),
                                                              //                           SizedBox(
                                                              //                             height: h * 0.01,
                                                              //                           ),
                                                              //                           Expanded(
                                                              //                             child: Builder(
                                                              //                               builder: (context) {
                                                              //                                 int index = categoryOfStatess.indexWhere((element) => element['name'].toString().toLowerCase().contains(searchController.text.toString().toLowerCase()));
                                                              //                                 if (index < 0) {
                                                              //                                   return Center(
                                                              //                                     child: Text(
                                                              //                                       'No States !',
                                                              //                                       style: TextStyle(
                                                              //                                         fontSize: 16,
                                                              //                                         fontWeight: FontWeight.w400,
                                                              //                                       ),
                                                              //                                     ),
                                                              //                                   );
                                                              //                                 }
                                                              //
                                                              //                                 return ListView.builder(
                                                              //                                   padding: EdgeInsets.zero,
                                                              //                                   physics: const BouncingScrollPhysics(),
                                                              //                                   shrinkWrap: true,
                                                              //                                   itemCount: categoryOfStatess.length,
                                                              //                                   itemBuilder: (context, index) {
                                                              //                                     if (categoryOfStatess[index]['name'].toString().toLowerCase().contains(searchController.text.toString().toLowerCase())) {
                                                              //                                       return Column(
                                                              //                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                              //                                         children: [
                                                              //                                           InkWell(
                                                              //                                             onTap: () async {
                                                              //                                               Navigator.pop(context, "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})" ?? "");
                                                              //                                               chooseStateId = categoryOfStatess[index]['id'];
                                                              //
                                                              //                                               medicalName = '';
                                                              //                                               chooseMedicalCenter = null;
                                                              //                                               categoryOfMedicalCenterDropDowns = null;
                                                              //                                               print('drop');
                                                              //
                                                              //                                               await _bookAppointmentController.getSpecialities(false.obs, stateId: chooseStateId == '0' ? '' : chooseStateId ?? '');
                                                              //
                                                              //                                               print('=ff===iddddddddd$chooseStateId');
                                                              //
                                                              //                                               setState1(() {});
                                                              //                                             },
                                                              //                                             child: Padding(
                                                              //                                               padding: const EdgeInsets.symmetric(vertical: 5),
                                                              //                                               child: SizedBox(
                                                              //                                                 width: double.infinity,
                                                              //                                                 height: 50,
                                                              //                                                 child: Align(
                                                              //                                                   alignment: Alignment.centerLeft,
                                                              //                                                   child: Text(
                                                              //                                                     "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})",
                                                              //                                                     style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.subtitle1.color, fontSize: 17),
                                                              //                                                   ),
                                                              //                                                 ),
                                                              //                                               ),
                                                              //                                             ),
                                                              //                                           ),
                                                              //                                           const Divider(height: 0)
                                                              //                                         ],
                                                              //                                       );
                                                              //                                     } else {
                                                              //                                       return SizedBox();
                                                              //                                     }
                                                              //                                   },
                                                              //                                 );
                                                              //                               },
                                                              //                             ),
                                                              //                           )
                                                              //                         ],
                                                              //                       ),
                                                              //                     ),
                                                              //                   ),
                                                              //                 ),
                                                              //               );
                                                              //             },
                                                              //           ),
                                                              //         );
                                                              //       },
                                                              //     ).then(
                                                              //       (value) async {
                                                              //         stateName =
                                                              //             value;
                                                              //
                                                              //         await getMedicalCenter(
                                                              //             stateName:
                                                              //                 stateName);
                                                              //         setState1(
                                                              //             () {});
                                                              //       },
                                                              //     );
                                                              //   },
                                                              //   child:
                                                              //       commonContainer(
                                                              //     child: Padding(
                                                              //       padding: EdgeInsets
                                                              //           .only(
                                                              //               left: 20,
                                                              //               right:
                                                              //                   12),
                                                              //       child: Row(
                                                              //         children: [
                                                              //           Text(
                                                              //             stateName ==
                                                              //                     ""
                                                              //                 ? 'Select State'
                                                              //                 : '$stateName',
                                                              //             style:
                                                              //                 TextStyle(
                                                              //               fontSize:
                                                              //                   18,
                                                              //               color: stateName !=
                                                              //                       ""
                                                              //                   ? _isDark
                                                              //                       ? Colors.white
                                                              //                       : Colors.black
                                                              //                   : Colors.grey,
                                                              //             ),
                                                              //           ),
                                                              //           const Spacer(),
                                                              //           Icon(
                                                              //             Icons
                                                              //                 .arrow_drop_down,
                                                              //             color: !_isDark
                                                              //                 ? Colors
                                                              //                     .grey
                                                              //                     .shade800
                                                              //                 : Colors
                                                              //                     .white,
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),

                                                              const SizedBox(
                                                                  height: 20),

                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (controller
                                                                      .categoryOfMedicalCenter
                                                                      .isNotEmpty) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return PopScope(
                                                                          canPop:
                                                                              false,
                                                                          child:
                                                                              StatefulBuilder(
                                                                            builder:
                                                                                (context, setState234) {
                                                                              return Dialog(
                                                                                backgroundColor: Colors.transparent,
                                                                                child: ConstrainedBox(
                                                                                  constraints: BoxConstraints(maxHeight: h * 0.6, maxWidth: 550),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.white, borderRadius: BorderRadius.circular(5)),
                                                                                    // height: h * 0.6,
                                                                                    // width: w * 0.85,
                                                                                    padding: EdgeInsets.symmetric(horizontal: h * 0.015).copyWith(top: h * 0.015),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  color: isDark ? Colors.grey.shade800 : Colors.white,
                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                  border: Border.all(color: Colors.grey),
                                                                                                ),
                                                                                                height: 48,
                                                                                                child: Center(
                                                                                                  child: TextField(
                                                                                                    controller: searchController,
                                                                                                    onChanged: (value) {
                                                                                                      setState234(() {});
                                                                                                    },
                                                                                                    decoration: const InputDecoration(
                                                                                                      contentPadding: EdgeInsets.only(top: 10, left: 16),
                                                                                                      suffixIcon: Icon(Icons.search),
                                                                                                      enabledBorder: InputBorder.none,
                                                                                                      focusedBorder: InputBorder.none,
                                                                                                      hintText: 'Search...',
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(width: 15),
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                Navigator.pop(context, controller.medicalName);
                                                                                                searchController.clear();
                                                                                              },
                                                                                              child: const Icon(
                                                                                                Icons.clear,
                                                                                                color: Colors.black,
                                                                                                size: 28,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: h * 0.01),
                                                                                        Expanded(
                                                                                          child: Builder(
                                                                                            builder: (context) {
                                                                                              int index = controller.categoryOfMedicalCenter.indexWhere((element) => element['post_title'].toString().toLowerCase().contains(searchController.text.toString().toLowerCase()));
                                                                                              if (index < 0) {
                                                                                                return const Center(
                                                                                                  child: Text(
                                                                                                    'No Medical Center !',
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 18,
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }

                                                                                              return ListView.builder(
                                                                                                padding: EdgeInsets.zero,
                                                                                                physics: const BouncingScrollPhysics(),
                                                                                                shrinkWrap: true,
                                                                                                itemCount: controller.categoryOfMedicalCenter.length,
                                                                                                itemBuilder: (context, index) {
                                                                                                  if (controller.categoryOfMedicalCenter[index]['post_title'].toString().toLowerCase().contains(searchController.text.toString().toLowerCase())) {
                                                                                                    return Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        ListTile(
                                                                                                          contentPadding: EdgeInsets.zero,
                                                                                                          onTap: () async {
                                                                                                            Navigator.pop(context);
                                                                                                            controller.setMedicalCenterId(
                                                                                                              controller.categoryOfMedicalCenter[index]['ID'].toString(),
                                                                                                              controller.categoryOfMedicalCenter[index]['post_title'].toString(),
                                                                                                              controller.categoryOfMedicalCenter[index]['google_form_url'].toString(),
                                                                                                            );
                                                                                                            // await _bookAppointmentController.getSpecialities(false.obs, stateId: chooseStateId ?? "", medicalCenterId: controller.chooseMedicalCenter ?? '');
                                                                                                            await _bookAppointmentController.getDoctorSpecialities("", context, stateId: chooseStateId ?? "", medicalCenterId: controller.chooseMedicalCenter ?? '');
                                                                                                          },
                                                                                                          title: Text(
                                                                                                            controller.categoryOfMedicalCenter[index]['post_title'].toString(),
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 20,
                                                                                                              color: Theme.of(context).textTheme.titleMedium?.color,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        const Divider(height: 0)
                                                                                                      ],
                                                                                                    );
                                                                                                  } else {
                                                                                                    return const SizedBox();
                                                                                                  }
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  } else if (_bookAppointmentController
                                                                          .medicalLoader
                                                                          .value ==
                                                                      true) {
                                                                    Get.showSnackbar(
                                                                      const GetSnackBar(
                                                                        backgroundColor:
                                                                            Colors.blue,
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                        messageText:
                                                                            Text(
                                                                          'Please wait...',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    Get.showSnackbar(
                                                                      const GetSnackBar(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                        messageText:
                                                                            Text(
                                                                          'No medical centers available',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    commonContainer(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            controller.medicalName == ""
                                                                                ? 'Select Medical Center'
                                                                                : controller.medicalName,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: controller.medicalName != ""
                                                                                  ? isDark
                                                                                      ? Colors.white
                                                                                      : Colors.black
                                                                                  : Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .arrow_drop_down,
                                                                          color: controller.categoryOfMedicalCenter.isEmpty
                                                                              ? Colors.grey
                                                                              : isDark
                                                                                  ? Colors.white
                                                                                  : Colors.black,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              // RadioListTile(
                                                              //   title: Text(
                                                              //       'Indigenous Health'),
                                                              //   groupValue:
                                                              //       controller
                                                              //           .ihOrNatives,
                                                              //   value: 0,
                                                              //   onChanged:
                                                              //       (value) {
                                                              //     controller
                                                              //         .changeValue(
                                                              //             value);
                                                              //     setState1(
                                                              //         () {});
                                                              //   },
                                                              // ),
                                                              // RadioListTile(
                                                              //   title: Text(
                                                              //       'United Natives'),
                                                              //   groupValue:
                                                              //       controller
                                                              //           .ihOrNatives,
                                                              //   value: 1,
                                                              //   onChanged:
                                                              //       (value) {
                                                              //     controller
                                                              //         .changeValue(
                                                              //             value);
                                                              //     setState1(
                                                              //         () {});
                                                              //   },
                                                              // ),

                                                              const SizedBox(
                                                                  height: 10),

                                                              // Obx(
                                                              //   () => Container(
                                                              //     height: 500,
                                                              //     width:
                                                              //         Get.width,
                                                              //     child: StaggeredGridView
                                                              //         .countBuilder(
                                                              //       padding: EdgeInsets
                                                              //           .symmetric(
                                                              //               horizontal:
                                                              //                   10),
                                                              //       crossAxisCount:
                                                              //           1,
                                                              //       physics:
                                                              //           NeverScrollableScrollPhysics(),
                                                              //       shrinkWrap:
                                                              //           true,
                                                              //       itemCount: _bookAppointmentController
                                                              //               .specialitiesModelData
                                                              //               .value
                                                              //               .specialities
                                                              //               ?.length ??
                                                              //           0,
                                                              //       staggeredTileBuilder: (int
                                                              //               index) =>
                                                              //           StaggeredTile
                                                              //               .fit(
                                                              //                   2),
                                                              //       mainAxisSpacing:
                                                              //           10,
                                                              //       crossAxisSpacing:
                                                              //           10,
                                                              //       itemBuilder:
                                                              //           (context,
                                                              //               index) {
                                                              //         // return HealthConcernItem(
                                                              //         //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
                                                              //         //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
                                                              //         //   onTap: () {
                                                              //         //     Navigator.of(context).pushNamed(Routes.bookingStep2);
                                                              //         //   },
                                                              //         // );
                                                              //         return Card(
                                                              //           child:
                                                              //               InkWell(
                                                              //             onTap:
                                                              //                 () {
                                                              //               print(
                                                              //                   'demo....');
                                                              //               // Navigator.of(context)
                                                              //               //     .pushNamed(Routes.bookingStep2);
                                                              //
                                                              //               Get.toNamed(
                                                              //                   Routes.bookingStep2,
                                                              //                   arguments: '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}');
                                                              //             },
                                                              //             borderRadius:
                                                              //                 BorderRadius.circular(4),
                                                              //             child:
                                                              //                 Padding(
                                                              //               padding: EdgeInsets.symmetric(
                                                              //                   horizontal: 10,
                                                              //                   vertical: 15),
                                                              //               child:
                                                              //                   Row(
                                                              //                 children: <Widget>[
                                                              //                   CircleAvatar(
                                                              //                     backgroundColor: Colors.grey[300],
                                                              //                     backgroundImage: NetworkImage("${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ?? AssetImage('assets/images/medicine.png'),
                                                              //                     radius: 25,
                                                              //                   ),
                                                              //                   SizedBox(
                                                              //                     width: 10,
                                                              //                   ),
                                                              //                   Expanded(
                                                              //                     child: Text(
                                                              //                       "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName} (${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.doctorsCount})" ?? Translate.of(context).translate('Women\'s Health') + '\n',
                                                              //                       maxLines: 2,
                                                              //                       overflow: TextOverflow.ellipsis,
                                                              //                       style: TextStyle(
                                                              //                         fontSize: 16,
                                                              //                       ),
                                                              //                     ),
                                                              //                   ),
                                                              //                   GestureDetector(
                                                              //                     onTap: () {
                                                              //                       setState(() {
                                                              //                         selected = index;
                                                              //                       });
                                                              //                     },
                                                              //                     child: Checkbox(
                                                              //                         value: _bookAppointmentController.specialitiesModelData.value.specialities[index]?.isCheckedBox,
                                                              //                         onChanged: (value) {
                                                              //                           setState(() {
                                                              //                             _bookAppointmentController.specialitiesModelData.value.specialities.forEach((element) {
                                                              //                               element.isCheckedBox = false;
                                                              //                             });
                                                              //
                                                              //                             _bookAppointmentController.specialitiesModelData.value.specialities[index]?.isCheckedBox = value;
                                                              //                             setState1(() {});
                                                              //                             print('-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
                                                              //                           });
                                                              //                         }),
                                                              //                   )
                                                              //                 ],
                                                              //               ),
                                                              //             ),
                                                              //           ),
                                                              //         );
                                                              //       },
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Card(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                        Routes
                                                                            .bookingStep2,
                                                                        arguments:
                                                                            ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}');
                                                                  },
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            15),
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.grey[300],
                                                                            backgroundImage: const AssetImage('assets/images/medicine.png'),
                                                                            radius: 25),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            '${Translate.of(context)?.translate('Provider')}(${_bookAppointmentController.doctorCount.toString()})',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontSize: 16),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    fixedSize: Size(
                                                                        Get.width,
                                                                        40),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    // int index = _bookAppointmentController
                                                                    //     .specialitiesModelData
                                                                    //     .value
                                                                    //     .specialities
                                                                    //     .indexWhere((element) =>
                                                                    //         element
                                                                    //             .isCheckedBox ==
                                                                    //         true);

                                                                    Get.toNamed(
                                                                      Routes
                                                                          .bookingStep2,
                                                                      arguments: /*index <
                                                                                  0
                                                                              ?*/
                                                                          ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ''}' /* : '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}'*/,
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Apply',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                    // Navigator.push(context,
                                    //     NavSlideFromBottom(page: HealthConcernPage()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kColorBlue),
                                    child: const Icon(Icons.search,
                                        size: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: BottomAppBar(
                    elevation: 5,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: NavBarItemWidget(
                              onTap: () {
                                controller.selectPage(0);
                                // TimerChange.timer.cancel();
                              },
                              iconData: Icons.home,
                              text: Translate.of(context)!.translate('home'),
                              color: controller.selectedIndex == 0
                                  ? kColorBlue
                                  : Colors.grey),
                        ),
                        Expanded(
                          flex: 1,
                          child: NavBarItemWidget(
                            onTap: () {
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
                          child: SizedBox(height: 1),
                        ),
                        Expanded(
                          flex: 1,
                          child: NavBarItemWidget(
                              onTap: () async {
                                controller.selectPage(3);
                                String url =
                                    '${Constants.baseUrl + Constants.patientRating}/${userController.user.value.id}';

                                Map<String, String> header1 = {
                                  "Authorization":
                                      'Bearer ${Prefs.getString(Prefs.BEARER)}',
                                };
                                http.Response response1 = await http
                                    .get(Uri.parse(url), headers: header1);
                                log('RESPONSE MEET ENDED${response1.body}');
                                var data = jsonDecode(response1.body);

                                if (data["status"] == 'Fail') {
                                  rateContactUsController.setRate(rate1: '0');
                                } else {
                                  log('rating ${data["data"]['rating']}');
                                  rateContactUsController.setRate(
                                      rate1: '${data["data"]['rating']}');
                                }
                              },
                              iconData: Icons.settings,
                              text:
                                  Translate.of(context)!.translate('settings'),
                              color: controller.selectedIndex == 3
                                  ? kColorBlue
                                  : Colors.grey),
                        ),
                        Expanded(
                          flex: 1,
                          child: NavBarItemWidget(
                              onTap: () {
                                controller.selectPage(1);
                              },
                              iconData: Icons.person,
                              text: Translate.of(context)!.translate('profile'),
                              color: controller.selectedIndex == 1
                                  ? kColorBlue
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  static Container commonContainer({required Widget child}) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'categoryOfStatesDropDowns', categoryOfStatesDropDowns));
  }

  // _onAlertWithCustomContentPress(context) {
  //   bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  //   Alert(
  //       context: context,
  //       style: AlertStyle(
  //         alertBorder: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(5),
  //           side: BorderSide(color: Colors.transparent),
  //         ),
  //       ),
  //       closeIcon: Padding(
  //         padding: const EdgeInsets.all(5).copyWith(bottom: 10),
  //         child: Icon(
  //           Icons.close,
  //           size: h * 0.032,
  //           color: !_isDark ? Colors.black : Colors.white,
  //         ),
  //       ),
  //       image: Container(
  //         height: h * 0.13,
  //         width: w * 0.4,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage('assets/images/Coming soon.gif'),
  //               fit: BoxFit.cover),
  //         ),
  //       ),
  //       title: "Coming soon ... !",
  //       content: Column(
  //         children: <Widget>[],
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text(
  //             "Okay",
  //             style: TextStyle(color: Colors.white, fontSize: 22),
  //           ),
  //         )
  //       ]).show();
  // }
}
