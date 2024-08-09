import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/appointment/book_appointment_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../utils/constants.dart';
import 'past_appointments_page.dart';
import 'upcoming_appointments_page.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  static const _kTabTextStyle = TextStyle(
      color: kColorPrimaryDark,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal);

  AdsController adsController = Get.find();
  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );
  String? categoryOfStatesDropDowns;
  String? categoryOfMedicalCenterDropDowns;
  List categoryOfStatess = [];
  String? chooseStateId;
  final BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());
  PatientHomeScreenController patientHomeScreenController =
      Get.put(PatientHomeScreenController());
  int selected = 0;

  final searchController = TextEditingController();

  String stateName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // getStates();
      _bookAppointmentController.getMedicalCenter();
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   _patientHomeScreenController.appointmentList = [];
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            title: Text(Translate.of(context)!.translate('my_appointments'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
            elevation: 0,
          ),
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                TabBar(
                  indicatorColor: kColorPrimary,
                  labelStyle: _kTabTextStyle,
                  unselectedLabelStyle: _kUnselectedTabTextStyle,
                  labelColor: kColorPrimary,
                  unselectedLabelColor: Colors.grey,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      text: Translate.of(context)?.translate('upcoming'),
                    ),
                    Tab(
                      text: Translate.of(context)?.translate('past'),
                    ),
                    Tab(
                      text:
                          Translate.of(context)?.translate('book_appointment'),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      /// (1) UPCOMING APPOINTMENT  ----------------------------------------------------------

                      UpcomingAppointmentsPage(),

                      /*/// TEMP ========== COMING SOON FOR UPCOMING APPOINTMENT

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 0.1,
                            width: w * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Coming soon.gif'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Coming soon ... !",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                                fontSize: 20),
                          ),
                          SizedBox(
                              height: h * 0.075)
                        ],
                      ),*/

                      /// (2) PAST APPOINTMENT  ----------------------------------------------------------

                      PastAppointmentsPage(),

                      /*/// TEMP ========== COMING SOON FOR PAST APPOINTMENT

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 0.1,
                            width: w * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Coming soon.gif'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Coming soon ... !",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.subtitle1.color,
                                fontSize: 20),
                          ),
                          SizedBox(
                              height: h * 0.075)
                        ],
                      ),*/

                      /// (3) BOOK APPOINTMENT ----------------------------------------------------------

                      const BookAppointmentTab(),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       GetBuilder<BookAppointmentController>(
                      //           builder: (controller) {
                      //         return Column(
                      //           children: [
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.symmetric(vertical: 25),
                      //               child: Align(
                      //                 alignment: Alignment.topCenter,
                      //                 child: Text(
                      //                   Translate.of(context)
                      //                       .translate('choose_health_center'),
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .headline6
                      //                       .copyWith(
                      //                           fontWeight: FontWeight.w700,
                      //                           fontSize: 22),
                      //                 ),
                      //               ),
                      //             ),
                      //
                      //             /// SELECT STATES - DON'T _ DELETE
                      //             // GestureDetector(
                      //             //   onTap: () {
                      //             //     showDialog(
                      //             //       context: context,
                      //             //       builder: (context) {
                      //             //         return StatefulBuilder(
                      //             //           builder: (context, setState234) {
                      //             //             return WillPopScope(
                      //             //               onWillPop: () async {
                      //             //                 return false;
                      //             //               },
                      //             //               child: Dialog(
                      //             //                 backgroundColor: Colors.transparent,
                      //             //                 child: ConstrainedBox(
                      //             //                   constraints: BoxConstraints(
                      //             //                     maxHeight:
                      //             //                         MediaQuery.of(context)
                      //             //                                 .size
                      //             //                                 .height *
                      //             //                             0.55,
                      //             //                   ),
                      //             //                   child: Container(
                      //             //                     decoration: BoxDecoration(
                      //             //                       color: _isDark
                      //             //                           ? Colors.grey.shade800
                      //             //                           : Colors.white,
                      //             //                       borderRadius:
                      //             //                           BorderRadius.circular(5),
                      //             //                     ),
                      //             //                     height: MediaQuery.of(context)
                      //             //                             .size
                      //             //                             .height *
                      //             //                         0.55,
                      //             //                     width: MediaQuery.of(context)
                      //             //                             .size
                      //             //                             .width *
                      //             //                         0.85,
                      //             //                     child: Padding(
                      //             //                       padding: EdgeInsets.only(
                      //             //                         top: MediaQuery.of(context)
                      //             //                                 .size
                      //             //                                 .height *
                      //             //                             0.015,
                      //             //                         left: MediaQuery.of(context)
                      //             //                                 .size
                      //             //                                 .height *
                      //             //                             0.015,
                      //             //                         right:
                      //             //                             MediaQuery.of(context)
                      //             //                                     .size
                      //             //                                     .height *
                      //             //                                 0.015,
                      //             //                         bottom: 0,
                      //             //                       ),
                      //             //                       child: Column(
                      //             //                         children: [
                      //             //                           Row(
                      //             //                             mainAxisAlignment:
                      //             //                                 MainAxisAlignment
                      //             //                                     .spaceBetween,
                      //             //                             children: [
                      //             //                               Expanded(
                      //             //                                 child: Container(
                      //             //                                   decoration:
                      //             //                                       BoxDecoration(
                      //             //                                     color: _isDark
                      //             //                                         ? Colors
                      //             //                                             .grey
                      //             //                                             .shade800
                      //             //                                         : Colors
                      //             //                                             .white,
                      //             //                                     borderRadius:
                      //             //                                         BorderRadius
                      //             //                                             .circular(
                      //             //                                                 25),
                      //             //                                     border: Border.all(
                      //             //                                         color: Colors
                      //             //                                             .grey),
                      //             //                                   ),
                      //             //                                   height: MediaQuery.of(
                      //             //                                               context)
                      //             //                                           .size
                      //             //                                           .height *
                      //             //                                       0.045,
                      //             //                                   child: Center(
                      //             //                                     child:
                      //             //                                         TextField(
                      //             //                                       controller:
                      //             //                                           searchController,
                      //             //                                       onChanged:
                      //             //                                           (value) {
                      //             //                                         setState234(
                      //             //                                             () {});
                      //             //                                       },
                      //             //                                       decoration:
                      //             //                                           InputDecoration(
                      //             //                                         contentPadding: EdgeInsets.only(
                      //             //                                             top: h *
                      //             //                                                 0.004,
                      //             //                                             left: w *
                      //             //                                                 0.04),
                      //             //                                         suffixIcon:
                      //             //                                             Icon(Icons
                      //             //                                                 .search),
                      //             //                                         enabledBorder:
                      //             //                                             InputBorder
                      //             //                                                 .none,
                      //             //                                         focusedBorder:
                      //             //                                             InputBorder
                      //             //                                                 .none,
                      //             //                                         hintText:
                      //             //                                             'Search...',
                      //             //                                       ),
                      //             //                                     ),
                      //             //                                   ),
                      //             //                                 ),
                      //             //                               ),
                      //             //                               SizedBox(
                      //             //                                 width: 15,
                      //             //                               ),
                      //             //                               GestureDetector(
                      //             //                                 onTap: () {
                      //             //                                   Navigator.pop(
                      //             //                                       context,
                      //             //                                       stateName);
                      //             //
                      //             //                                   searchController
                      //             //                                       .clear();
                      //             //                                 },
                      //             //                                 child: Icon(
                      //             //                                   Icons.clear,
                      //             //                                   color:
                      //             //                                       Colors.black,
                      //             //                                   size: 28,
                      //             //                                 ),
                      //             //                               ),
                      //             //                             ],
                      //             //                           ),
                      //             //                           SizedBox(
                      //             //                             height: MediaQuery.of(
                      //             //                                         context)
                      //             //                                     .size
                      //             //                                     .height *
                      //             //                                 0.01,
                      //             //                           ),
                      //             //                           Expanded(
                      //             //                             child: Builder(
                      //             //                               builder: (context) {
                      //             //                                 int index = categoryOfStatess.indexWhere(
                      //             //                                     (element) => element[
                      //             //                                             'name']
                      //             //                                         .toString()
                      //             //                                         .toLowerCase()
                      //             //                                         .contains(searchController
                      //             //                                             .text
                      //             //                                             .toString()
                      //             //                                             .toLowerCase()));
                      //             //                                 if (index < 0) {
                      //             //                                   return Center(
                      //             //                                     child: Text(
                      //             //                                       'No States !',
                      //             //                                       style:
                      //             //                                           TextStyle(
                      //             //                                         color: _isDark
                      //             //                                             ? Colors
                      //             //                                                 .grey
                      //             //                                                 .shade800
                      //             //                                             : Colors
                      //             //                                                 .white,
                      //             //                                         fontSize:
                      //             //                                             16,
                      //             //                                         fontWeight:
                      //             //                                             FontWeight
                      //             //                                                 .w400,
                      //             //                                       ),
                      //             //                                     ),
                      //             //                                   );
                      //             //                                 }
                      //             //
                      //             //                                 return ListView
                      //             //                                     .builder(
                      //             //                                   padding:
                      //             //                                       EdgeInsets
                      //             //                                           .zero,
                      //             //                                   physics:
                      //             //                                       const BouncingScrollPhysics(),
                      //             //                                   shrinkWrap: true,
                      //             //                                   itemCount:
                      //             //                                       categoryOfStatess
                      //             //                                           .length,
                      //             //                                   itemBuilder:
                      //             //                                       (context,
                      //             //                                           index) {
                      //             //                                     if (categoryOfStatess[
                      //             //                                                 index]
                      //             //                                             ['name']
                      //             //                                         .toString()
                      //             //                                         .toLowerCase()
                      //             //                                         .contains(searchController
                      //             //                                             .text
                      //             //                                             .toString()
                      //             //                                             .toLowerCase())) {
                      //             //                                       return Column(
                      //             //                                         crossAxisAlignment:
                      //             //                                             CrossAxisAlignment
                      //             //                                                 .start,
                      //             //                                         children: [
                      //             //                                           InkWell(
                      //             //                                             onTap:
                      //             //                                                 () async {
                      //             //                                               Navigator.pop(
                      //             //                                                   context,
                      //             //                                                   "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})" ?? "");
                      //             //                                               chooseStateId =
                      //             //                                                   categoryOfStatess[index]['id'];
                      //             //
                      //             //                                               medicalName =
                      //             //                                                   '';
                      //             //                                               chooseMedicalCenter =
                      //             //                                                   null;
                      //             //                                               categoryOfMedicalCenterDropDowns =
                      //             //                                                   null;
                      //             //                                               print(
                      //             //                                                   'drop');
                      //             //                                               categoryOfMedicalCenter =
                      //             //                                                   [];
                      //             //
                      //             //                                               await _bookAppointmentController.getSpecialities(
                      //             //                                                   false.obs,
                      //             //                                                   stateId: chooseStateId == '0' ? '' : chooseStateId ?? '');
                      //             //                                             },
                      //             //                                             child:
                      //             //                                                 Padding(
                      //             //                                               padding:
                      //             //                                                   const EdgeInsets.symmetric(vertical: 5),
                      //             //                                               child:
                      //             //                                                   SizedBox(
                      //             //                                                 width:
                      //             //                                                     double.infinity,
                      //             //                                                 height:
                      //             //                                                     50,
                      //             //                                                 child:
                      //             //                                                     Align(
                      //             //                                                   alignment: Alignment.centerLeft,
                      //             //                                                   child: Text(
                      //             //                                                     "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})",
                      //             //                                                     style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.subtitle1.color, fontSize: 17),
                      //             //                                                   ),
                      //             //                                                 ),
                      //             //                                               ),
                      //             //                                             ),
                      //             //                                           ),
                      //             //                                           const Divider(
                      //             //                                               height:
                      //             //                                                   0)
                      //             //                                         ],
                      //             //                                       );
                      //             //                                     } else {
                      //             //                                       return SizedBox();
                      //             //                                     }
                      //             //                                   },
                      //             //                                 );
                      //             //                               },
                      //             //                             ),
                      //             //                           )
                      //             //                         ],
                      //             //                       ),
                      //             //                     ),
                      //             //                   ),
                      //             //                 ),
                      //             //               ),
                      //             //             );
                      //             //           },
                      //             //         );
                      //             //       },
                      //             //     ).then(
                      //             //       (value) async {
                      //             //         stateName = value;
                      //             //         await getMedicalCenter(
                      //             //             stateName: stateName);
                      //             //         setState(() {});
                      //             //       },
                      //             //     );
                      //             //   },
                      //             //   child: commonContainer(
                      //             //     child: Padding(
                      //             //       padding: EdgeInsets.only(left: 20, right: 12),
                      //             //       child: Row(
                      //             //         children: [
                      //             //           Text(
                      //             //             stateName == ""
                      //             //                 ? 'Select State'
                      //             //                 : '$stateName',
                      //             //             style: TextStyle(
                      //             //               fontSize: 18,
                      //             //             ),
                      //             //           ),
                      //             //           const Spacer(),
                      //             //           Icon(
                      //             //             Icons.arrow_drop_down,
                      //             //             color: !_isDark
                      //             //                 ? Colors.grey.shade800
                      //             //                 : Colors.white,
                      //             //           )
                      //             //         ],
                      //             //       ),
                      //             //     ),
                      //             //   ),
                      //             // ),
                      //             // SizedBox(
                      //             //   height: 20,
                      //             // ),
                      //
                      //             SizedBox(height: 10),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 if (controller
                      //                     .categoryOfMedicalCenter.isNotEmpty) {
                      //                   return showDialog(
                      //                     context: context,
                      //                     builder: (context) {
                      //                       return WillPopScope(
                      //                         onWillPop: () async {
                      //                           return false;
                      //                         },
                      //                         child: StatefulBuilder(
                      //                           builder: (context, setState234) {
                      //                             return Dialog(
                      //                               backgroundColor:
                      //                                   Colors.transparent,
                      //                               child: ConstrainedBox(
                      //                                 constraints: BoxConstraints(
                      //                                   maxHeight: h * 0.55,
                      //                                 ),
                      //                                 child: Container(
                      //                                   decoration: BoxDecoration(
                      //                                       color: _isDark
                      //                                           ? Colors
                      //                                               .grey.shade800
                      //                                           : Colors.white,
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(5)),
                      //                                   height: h * 0.55,
                      //                                   width: w * 0.85,
                      //                                   child: Padding(
                      //                                     padding: EdgeInsets.only(
                      //                                       top: h * 0.015,
                      //                                       left: h * 0.015,
                      //                                       right: h * 0.015,
                      //                                       bottom: 0,
                      //                                     ),
                      //                                     child: Column(
                      //                                       children: [
                      //                                         Row(
                      //                                           mainAxisAlignment:
                      //                                               MainAxisAlignment
                      //                                                   .spaceBetween,
                      //                                           children: [
                      //                                             Expanded(
                      //                                               child:
                      //                                                   Container(
                      //                                                 decoration:
                      //                                                     BoxDecoration(
                      //                                                   color: _isDark
                      //                                                       ? Colors
                      //                                                           .grey
                      //                                                           .shade800
                      //                                                       : Colors
                      //                                                           .white,
                      //                                                   borderRadius:
                      //                                                       BorderRadius.circular(
                      //                                                           25),
                      //                                                   border: Border.all(
                      //                                                       color: Colors
                      //                                                           .grey),
                      //                                                 ),
                      //                                                    height: 48,
                      //
                      //                                                 child: Center(
                      //                                                   child:
                      //                                                       TextField(
                      //                                                     controller:
                      //                                                         searchController,
                      //                                                     onChanged:
                      //                                                         (value) {
                      //                                                       setState234(
                      //                                                           () {});
                      //                                                     },
                      //                                                     decoration: InputDecoration(
                      //                                                             contentPadding: EdgeInsets.only(
                      //                                               top: 10, left: 16),
                      //                                                         suffixIcon: Icon(Icons
                      //                                                             .search),
                      //                                                         enabledBorder: InputBorder
                      //                                                             .none,
                      //                                                         focusedBorder: InputBorder
                      //                                                             .none,
                      //                                                         hintText:
                      //                                                             'Search...'),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                             SizedBox(
                      //                                               width: 15,
                      //                                             ),
                      //                                             GestureDetector(
                      //                                               onTap: () {
                      //                                                 Navigator.pop(
                      //                                                     context,
                      //                                                     controller
                      //                                                         .medicalName);
                      //                                                 searchController
                      //                                                     .clear();
                      //                                               },
                      //                                               child: Icon(
                      //                                                 Icons.clear,
                      //                                                 color: Colors
                      //                                                     .black,
                      //                                                 size: 28,
                      //                                               ),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                         SizedBox(
                      //                                           height: h * 0.01,
                      //                                         ),
                      //                                         Expanded(
                      //                                           child: Builder(
                      //                                             builder:
                      //                                                 (context) {
                      //                                               int index = controller.categoryOfMedicalCenter.indexWhere((element) => element[
                      //                                                       'post_title']
                      //                                                   .toString()
                      //                                                   .toLowerCase()
                      //                                                   .contains(searchController
                      //                                                       .text
                      //                                                       .toString()
                      //                                                       .toLowerCase()));
                      //                                               if (index < 0) {
                      //                                                 return Center(
                      //                                                   child: Text(
                      //                                                     'No Medical Center !',
                      //                                                     style: TextStyle(
                      //                                                         fontSize:
                      //                                                             16,
                      //                                                         fontWeight:
                      //                                                             FontWeight.w400),
                      //                                                   ),
                      //                                                 );
                      //                                               }
                      //
                      //                                               return ListView
                      //                                                   .builder(
                      //                                                 padding:
                      //                                                     EdgeInsets
                      //                                                         .zero,
                      //                                                 physics:
                      //                                                     const BouncingScrollPhysics(),
                      //                                                 shrinkWrap:
                      //                                                     true,
                      //                                                 itemCount:
                      //                                                     controller
                      //                                                         .categoryOfMedicalCenter
                      //                                                         .length,
                      //                                                 itemBuilder:
                      //                                                     (context,
                      //                                                         index) {
                      //                                                   return controller
                      //                                                           .categoryOfMedicalCenter[index]['post_title']
                      //                                                           .toString()
                      //                                                           .toLowerCase()
                      //                                                           .contains(searchController.text.toString().toLowerCase())
                      //                                                       ? Column(
                      //                                                           crossAxisAlignment:
                      //                                                               CrossAxisAlignment.start,
                      //                                                           children: [
                      //                                                             InkWell(
                      //                                                               onTap: () async {
                      //                                                                 Navigator.pop(context);
                      //                                                                 controller.setMedicalCenterId(
                      //                                                                   controller.categoryOfMedicalCenter[index]['ID'].toString(),
                      //                                                                   controller.categoryOfMedicalCenter[index]['post_title'].toString(),
                      //                                                                   controller.categoryOfMedicalCenter[index]['google_form_url'].toString(),
                      //                                                                 );
                      //                                                                 // await _bookAppointmentController.getSpecialities(false.obs,stateId: chooseStateId ?? "",medicalCenterId: controller.chooseMedicalCenter ?? '');
                      //                                                                 await _bookAppointmentController.getDoctorSpecialities("", context, stateId: chooseStateId ?? "", medicalCenterId: controller.chooseMedicalCenter ?? '');
                      //                                                               },
                      //                                                               child: Padding(
                      //                                                                 padding: const EdgeInsets.symmetric(vertical: 4.5),
                      //                                                                 child: SizedBox(
                      //                                                                   width: double.infinity,
                      //                                                                   height: 50,
                      //                                                                   child: Align(
                      //                                                                     alignment: Alignment.centerLeft,
                      //                                                                     child: Text(
                      //                                                                       "${controller.categoryOfMedicalCenter[index]['post_title'].toString()}",
                      //                                                                       style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.subtitle1.color, fontSize: 17),
                      //                                                                     ),
                      //                                                                   ),
                      //                                                                 ),
                      //                                                               ),
                      //                                                             ),
                      //                                                             Divider(height: 0),
                      //                                                           ],
                      //                                                         )
                      //                                                       : SizedBox();
                      //                                                 },
                      //                                               );
                      //                                             },
                      //                                           ),
                      //                                         )
                      //                                       ],
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           },
                      //                         ),
                      //                       );
                      //                     },
                      //                   );
                      //                 } else if (_bookAppointmentController
                      //                         .medicalLoader.value ==
                      //                     true) {
                      //                   Get.showSnackbar(
                      //                     GetSnackBar(
                      //                       backgroundColor: Colors.blue,
                      //                       duration: Duration(seconds: 2),
                      //                       messageText: Text(
                      //                         'Please wait...',
                      //                         style: TextStyle(color: Colors.white),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 } else {
                      //                   Get.showSnackbar(
                      //                     GetSnackBar(
                      //                       backgroundColor: Colors.red,
                      //                       duration: Duration(seconds: 2),
                      //                       messageText: Text(
                      //                         'No medical centers available',
                      //                         style: TextStyle(color: Colors.white),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 }
                      //               },
                      //               child: commonContainer(
                      //                 child: Padding(
                      //                   padding:
                      //                       EdgeInsets.only(left: 20, right: 12),
                      //                   child: Row(
                      //                     children: [
                      //                       Expanded(
                      //                         child: Text(
                      //                           controller.medicalName == ""
                      //                               ? 'Select Medical Center'
                      //                               : '${controller.medicalName}',
                      //                           overflow: TextOverflow.ellipsis,
                      //                           style: TextStyle(
                      //                               fontSize: 18,
                      //                               color: controller.medicalName !=
                      //                                       ""
                      //                                   ? !_isDark
                      //                                       ? Colors.grey.shade800
                      //                                       : Colors.white
                      //                                   : Colors.grey),
                      //                         ),
                      //                       ),
                      //                       Icon(Icons.arrow_drop_down,
                      //                           color: controller
                      //                                   .categoryOfMedicalCenter
                      //                                   .isEmpty
                      //                               ? Colors.grey
                      //                               : !_isDark
                      //                                   ? Colors.grey.shade800
                      //                                   : Colors.white)
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             SizedBox(height: 10),
                      //             RadioListTile(
                      //               title: Text('Indigenous Health'),
                      //               groupValue: controller.ihOrNatives,
                      //               value: 0,
                      //               onChanged: (value) {
                      //                 controller.changeValue(value);
                      //                 setState(() {});
                      //               },
                      //             ),
                      //             RadioListTile(
                      //               title: Text('United Natives'),
                      //               groupValue: controller.ihOrNatives,
                      //               value: 1,
                      //               onChanged: (value) {
                      //                 controller.changeValue(value);
                      //                 setState(() {});
                      //               },
                      //             ),
                      //
                      //             SizedBox(height: 10),
                      //
                      //             // Obx(
                      //             //   () => Container(
                      //             //     height: 500,
                      //             //     width: Get.width,
                      //             //     child: StaggeredGridView
                      //             //         .countBuilder(
                      //             //       padding: EdgeInsets.symmetric(
                      //             //           horizontal: 10),
                      //             //       crossAxisCount: 1,
                      //             //       physics:
                      //             //           NeverScrollableScrollPhysics(),
                      //             //       shrinkWrap: true,
                      //             //       itemCount:
                      //             //           _bookAppointmentController
                      //             //                   .specialitiesModelData
                      //             //                   .value
                      //             //                   .specialities
                      //             //                   ?.length ??
                      //             //               0,
                      //             //       staggeredTileBuilder:
                      //             //           (int index) =>
                      //             //               StaggeredTile.fit(2),
                      //             //       mainAxisSpacing: 10,
                      //             //       crossAxisSpacing: 10,
                      //             //       itemBuilder:
                      //             //           (context, index) {
                      //             //         // return HealthConcernItem(
                      //             //         //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
                      //             //         //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
                      //             //         //   onTap: () {
                      //             //         //     Navigator.of(context).pushNamed(Routes.bookingStep2);
                      //             //         //   },
                      //             //         // );
                      //             //         return Card(
                      //             //           child: InkWell(
                      //             //             onTap: () {
                      //             //               print('demo....');
                      //             //               // Navigator.of(context)
                      //             //               //     .pushNamed(Routes.bookingStep2);
                      //             //
                      //             //               Get.toNamed(
                      //             //                   Routes
                      //             //                       .bookingStep2,
                      //             //                   arguments:
                      //             //                       '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}');
                      //             //             },
                      //             //             borderRadius:
                      //             //                 BorderRadius
                      //             //                     .circular(4),
                      //             //             child: Padding(
                      //             //               padding: EdgeInsets
                      //             //                   .symmetric(
                      //             //                       horizontal:
                      //             //                           10,
                      //             //                       vertical: 15),
                      //             //               child: Row(
                      //             //                 children: <Widget>[
                      //             //                   CircleAvatar(
                      //             //                     backgroundColor:
                      //             //                         Colors.grey[
                      //             //                             300],
                      //             //                     backgroundImage:
                      //             //                         NetworkImage(
                      //             //                                 "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
                      //             //                             AssetImage(
                      //             //                                 'assets/images/medicine.png'),
                      //             //                     radius: 25,
                      //             //                   ),
                      //             //                   SizedBox(
                      //             //                     width: 10,
                      //             //                   ),
                      //             //                   Expanded(
                      //             //                     child: Text(
                      //             //                       "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName} (${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.doctorsCount})" ??
                      //             //                           Translate.of(context)
                      //             //                                   .translate('Women\'s Health') +
                      //             //                               '\n',
                      //             //                       maxLines: 2,
                      //             //                       overflow:
                      //             //                           TextOverflow
                      //             //                               .ellipsis,
                      //             //                       style:
                      //             //                           TextStyle(
                      //             //                         fontSize:
                      //             //                             16,
                      //             //                       ),
                      //             //                     ),
                      //             //                   ),
                      //             //                   GestureDetector(
                      //             //                     onTap: () {
                      //             //                       setState(() {
                      //             //                         selected =
                      //             //                             index;
                      //             //                       });
                      //             //                     },
                      //             //                     child: Checkbox(
                      //             //                         value: _bookAppointmentController
                      //             //                             .specialitiesModelData
                      //             //                             .value
                      //             //                             .specialities[
                      //             //                                 index]
                      //             //                             ?.isCheckedBox,
                      //             //                         onChanged:
                      //             //                             (value) {
                      //             //                           setState(
                      //             //                               () {
                      //             //                             _bookAppointmentController
                      //             //                                 .specialitiesModelData
                      //             //                                 .value
                      //             //                                 .specialities
                      //             //                                 .forEach((element) {
                      //             //                               element.isCheckedBox =
                      //             //                                   false;
                      //             //                             });
                      //             //
                      //             //                             _bookAppointmentController
                      //             //                                 .specialitiesModelData
                      //             //                                 .value
                      //             //                                 .specialities[index]
                      //             //                                 ?.isCheckedBox = value;
                      //             //                             setState1(
                      //             //                                 () {});
                      //             //                             print(
                      //             //                                 '-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
                      //             //                           });
                      //             //                         }),
                      //             //                   )
                      //             //                 ],
                      //             //               ),
                      //             //             ),
                      //             //           ),
                      //             //         );
                      //             //       },
                      //             //     ),
                      //             //   ),
                      //             // ),
                      //             Card(
                      //               child: InkWell(
                      //                 onTap: () {
                      //                   Get.toNamed(Routes.bookingStep2,
                      //                       arguments:
                      //                           ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}');
                      //                 },
                      //                 borderRadius: BorderRadius.circular(4),
                      //                 child: Padding(
                      //                   padding: EdgeInsets.symmetric(
                      //                       horizontal: 10, vertical: 15),
                      //                   child: Row(
                      //                     children: <Widget>[
                      //                       CircleAvatar(
                      //                         backgroundColor: Colors.grey[300],
                      //                         backgroundImage: AssetImage(
                      //                             'assets/images/medicine.png'),
                      //                         radius: 25,
                      //                       ),
                      //                       SizedBox(
                      //                         width: 10,
                      //                       ),
                      //                       Expanded(
                      //                         child: Text(
                      //                           Translate.of(context)
                      //                                   .translate('Doctor') +
                      //                               '(${_bookAppointmentController.doctorCount.toString()})',
                      //                           maxLines: 2,
                      //                           overflow: TextOverflow.ellipsis,
                      //                           style: TextStyle(
                      //                             fontSize: 16,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             SizedBox(height: 30),
                      //             ElevatedButton(
                      //               style: ElevatedButton.styleFrom(
                      //                 fixedSize:
                      //                     Size(Get.width * 0.8, Get.height * 0.057),
                      //               ),
                      //               onPressed: () async {
                      //                 int index = _bookAppointmentController
                      //                     .specialitiesModelData.value.specialities
                      //                     .indexWhere((element) =>
                      //                         element.isCheckedBox == true);
                      //
                      //                 Get.toNamed(
                      //                   Routes.bookingStep2,
                      //                   arguments: index < 0
                      //                       ? ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ''}'
                      //                       : '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}',
                      //                 );
                      //                 print('===CHOOSING DOCTOR===>');
                      //                 // Navigator.pop(context);
                      //               },
                      //               child: Text(
                      //                 'Apply',
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       }),
                      //
                      //       /*/// TEMP ========== COMING SOON BOOK APPOINTMENT
                      //
                      //       Container(
                      //         height: h * 0.1,
                      //         width: w * 0.4,
                      //         decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //               image:
                      //                   AssetImage('assets/images/Coming soon.gif'),
                      //               fit: BoxFit.cover),
                      //         ),
                      //       ),
                      //       SizedBox(height: 5),
                      //       Text(
                      //         "Coming soon ... !",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color:
                      //                 Theme.of(context).textTheme.subtitle1.color,
                      //             fontSize: 20),
                      //       ),
                      //       SizedBox(
                      //           height: h * 0.075)*/
                      //     ],
                      //   ),
                      // ),

                      ///

                      /*  Center(
                        child: RaisedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                print('--------------------$categoryOfStatess');
                                print(
                                    '--------------------$categoryOfMedicalCenter');
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function()) setState1) {
                                    return SimpleDialog(
                                      contentPadding: EdgeInsets.zero,
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Colors.black,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Text(
                                                      Translate.of(context).translate(
                                                          'choose_health_center'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  child: DropdownButtonFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Select State',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    // Initial Value
                                                    value:
                                                        categoryOfStatesDropDowns,

                                                    // Down Arrow Icon
                                                    icon: const Icon(Icons
                                                        .arrow_drop_down_outlined),

                                                    // Array list of items
                                                    items: categoryOfStatess
                                                        .map((item) {
                                                      return DropdownMenuItem(
                                                        enabled: true,
                                                        onTap: () async {
                                                          chooseStateId =
                                                              item['id'];
                                                          chooseMedicalCenter =
                                                              null;
                                                          categoryOfMedicalCenterDropDowns =
                                                              null;
                                                          print('drop');
                                                          await getMedicalCenter(
                                                              location:
                                                                  item['name']);

                                                          await _bookAppointmentController
                                                              .getSpecialities(
                                                                  false.obs,
                                                                  stateId:
                                                                      chooseStateId ==
                                                                              '0'
                                                                          ? ''
                                                                          : chooseStateId ??
                                                                              '');

                                                          setState1(() {});
                                                          print(
                                                              '=ff===iddddddddd$chooseStateId');
                                                        },
                                                        value:
                                                            item['name'].toString(),
                                                        child: Text(
                                                            '${item['name'].toString()} (${item['doctors_count'].toString()})'),
                                                      );
                                                    }).toList(),
                                                    // After selecting the desired option,it will
                                                    // change button value to selected value
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        categoryOfStatesDropDowns =
                                                            newValue;
                                                      });
                                                      print(
                                                          categoryOfStatesDropDowns);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  child: DropdownButtonFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Select Medical Center',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    // Initial Value
                                                    value:
                                                        categoryOfMedicalCenterDropDowns,

                                                    // Down Arrow Icon
                                                    icon: const Icon(Icons
                                                        .arrow_drop_down_outlined),

                                                    // Array list of items
                                                    items: categoryOfMedicalCenter
                                                        .map((item) {
                                                      return DropdownMenuItem(
                                                        enabled: true,
                                                        onTap: () async {
                                                          chooseMedicalCenter =
                                                              item['ID'].toString();
                                                          await _bookAppointmentController
                                                              .getSpecialities(
                                                                  false.obs,
                                                                  stateId:
                                                                      chooseStateId ??
                                                                          "",
                                                                  medicalCenterId:
                                                                      chooseMedicalCenter ??
                                                                          '');
                                                          setState1(() {});
                                                          print('drop');
                                                          print(
                                                              '=ff===iddddddddd$chooseMedicalCenter');
                                                        },
                                                        value: item['post_title']
                                                            .toString(),
                                                        child: Text(
                                                            '${item['post_title'].toString()} (${item['doctors_count'].toString()})'),
                                                      );
                                                    }).toList(),
                                                    // After selecting the desired option,it will
                                                    // change button value to selected value
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        categoryOfMedicalCenterDropDowns =
                                                            newValue;
                                                      });
                                                      print(
                                                          categoryOfMedicalCenterDropDowns);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                // Obx(
                                                //   () => Container(
                                                //     height: 500,
                                                //     width: Get.width,
                                                //     child: StaggeredGridView
                                                //         .countBuilder(
                                                //       padding: EdgeInsets.symmetric(
                                                //           horizontal: 10),
                                                //       crossAxisCount: 1,
                                                //       physics:
                                                //           NeverScrollableScrollPhysics(),
                                                //       shrinkWrap: true,
                                                //       itemCount:
                                                //           _bookAppointmentController
                                                //                   .specialitiesModelData
                                                //                   .value
                                                //                   .specialities
                                                //                   ?.length ??
                                                //               0,
                                                //       staggeredTileBuilder:
                                                //           (int index) =>
                                                //               StaggeredTile.fit(2),
                                                //       mainAxisSpacing: 10,
                                                //       crossAxisSpacing: 10,
                                                //       itemBuilder:
                                                //           (context, index) {
                                                //         // return HealthConcernItem(
                                                //         //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
                                                //         //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
                                                //         //   onTap: () {
                                                //         //     Navigator.of(context).pushNamed(Routes.bookingStep2);
                                                //         //   },
                                                //         // );
                                                //         return Card(
                                                //           child: InkWell(
                                                //             onTap: () {
                                                //               print('demo....');
                                                //               // Navigator.of(context)
                                                //               //     .pushNamed(Routes.bookingStep2);
                                                //
                                                //               Get.toNamed(
                                                //                   Routes
                                                //                       .bookingStep2,
                                                //                   arguments:
                                                //                       '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}');
                                                //             },
                                                //             borderRadius:
                                                //                 BorderRadius
                                                //                     .circular(4),
                                                //             child: Padding(
                                                //               padding: EdgeInsets
                                                //                   .symmetric(
                                                //                       horizontal:
                                                //                           10,
                                                //                       vertical: 15),
                                                //               child: Row(
                                                //                 children: <Widget>[
                                                //                   CircleAvatar(
                                                //                     backgroundColor:
                                                //                         Colors.grey[
                                                //                             300],
                                                //                     backgroundImage:
                                                //                         NetworkImage(
                                                //                                 "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
                                                //                             AssetImage(
                                                //                                 'assets/images/medicine.png'),
                                                //                     radius: 25,
                                                //                   ),
                                                //                   SizedBox(
                                                //                     width: 10,
                                                //                   ),
                                                //                   Expanded(
                                                //                     child: Text(
                                                //                       "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName} (${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.doctorsCount})" ??
                                                //                           Translate.of(context)
                                                //                                   .translate('Women\'s Health') +
                                                //                               '\n',
                                                //                       maxLines: 2,
                                                //                       overflow:
                                                //                           TextOverflow
                                                //                               .ellipsis,
                                                //                       style:
                                                //                           TextStyle(
                                                //                         fontSize:
                                                //                             16,
                                                //                       ),
                                                //                     ),
                                                //                   ),
                                                //                   GestureDetector(
                                                //                     onTap: () {
                                                //                       setState(() {
                                                //                         selected =
                                                //                             index;
                                                //                       });
                                                //                     },
                                                //                     child: Checkbox(
                                                //                         value: _bookAppointmentController
                                                //                             .specialitiesModelData
                                                //                             .value
                                                //                             .specialities[
                                                //                                 index]
                                                //                             ?.isCheckedBox,
                                                //                         onChanged:
                                                //                             (value) {
                                                //                           setState(
                                                //                               () {
                                                //                             _bookAppointmentController
                                                //                                 .specialitiesModelData
                                                //                                 .value
                                                //                                 .specialities
                                                //                                 .forEach((element) {
                                                //                               element.isCheckedBox =
                                                //                                   false;
                                                //                             });
                                                //
                                                //                             _bookAppointmentController
                                                //                                 .specialitiesModelData
                                                //                                 .value
                                                //                                 .specialities[index]
                                                //                                 ?.isCheckedBox = value;
                                                //                             setState1(
                                                //                                 () {});
                                                //                             print(
                                                //                                 '-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
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
                                                      print('demo....');
                                                      // Navigator.of(context)
                                                      //     .pushNamed(Routes.bookingStep2);

                                                      Get.toNamed(
                                                          Routes.bookingStep2,
                                                          arguments:
                                                              ',${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}');
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                      child: Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.grey[300],
                                                            backgroundImage: AssetImage(
                                                                'assets/images/medicine.png'),
                                                            radius: 25,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              Translate.of(context)
                                                                      .translate(
                                                                          'Doctor') +
                                                                  '(${_bookAppointmentController.allDoctorCount.toString()})',
                                                              maxLines: 2,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          // GestureDetector(
                                                          //
                                                          //   child: Checkbox(
                                                          //       value: _bookAppointmentController.specialitiesModelData.value.specialities[index]?.isCheckedBox,
                                                          //       onChanged: (value) {
                                                          //         setState(() {
                                                          //           _bookAppointmentController.specialitiesModelData.value.specialities.forEach((element) {
                                                          //             element.isCheckedBox = false;
                                                          //           });
                                                          //
                                                          //           _bookAppointmentController.specialitiesModelData.value.specialities[index]?.isCheckedBox = value;
                                                          //           setState1(() {});
                                                          //           print('-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
                                                          //         });
                                                          //       }),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      fixedSize:
                                                          Size(Get.width, 40),
                                                    ),
                                                    onPressed: () async {
                                                      print(
                                                          '===CHOOSING DOCTOR===>');
                                                      // docFilter(
                                                      //     city: 3306,
                                                      //     state: chooseStateId,
                                                      //     userId: _userController.user.value.id,
                                                      //     specialityId: 5);

                                                      int index =
                                                          _bookAppointmentController
                                                              .specialitiesModelData
                                                              .value
                                                              .specialities
                                                              .indexWhere((element) =>
                                                                  element
                                                                      .isCheckedBox ==
                                                                  true);

                                                      Get.toNamed(
                                                        Routes.bookingStep2,
                                                        arguments: index < 0
                                                            ? ',${chooseStateId ?? ""},${chooseMedicalCenter ?? ''}'
                                                            : '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}',
                                                      );
                                                      // Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'Apply',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            // FocusScope.of(context)
                            //     .requestFocus(FocusNode());
                            // Navigator.push(
                            //     context,
                            //     NavSlideFromBottom(
                            //         page:
                            //             HealthConcernPage()));
                          },
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          color: kColorBlue,
                        ),
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
