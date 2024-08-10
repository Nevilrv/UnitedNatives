import 'dart:async';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/visited_doctor_list_item.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/medicle_center/lib/widgets/widget.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  final PatientHomeScreenController _patientHomeScreenController =
      Get.put(PatientHomeScreenController());

  PatientScheduledClassController patientScheduledClassController =
      Get.put(PatientScheduledClassController());
  AgoraController agoraController = Get.put(AgoraController());

  final BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());
  String stateName = '';

  final searchController = TextEditingController();
  var categoryOfStatesDropDowns;
  var categoryOfMedicalCenterDropDowns;
  List categoryOfStatess = [];

  var chooseStateId;

  int selected = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // getStates();
      getUpcomingClassData();
    });

    super.initState();
  }

  final UserController userController = Get.find();
  Future<void> getUpcomingClassData() async {
    await _patientHomeScreenController.getPatientHomePage();
    await _bookAppointmentController.getMedicalCenter();

    if (patientScheduledClassController.getClassPatientApiResponse.status ==
        Status.COMPLETE) {
      if (patientScheduledClassController
              .getClassPatientApiResponse.data.data ==
          null) {
        await patientScheduledClassController.getClassListPatient(
            id: userController.user.value.id!, date: '');
      } else {
        await patientScheduledClassController.getClassListPatient(
            id: userController.user.value.id!, date: '');
      }
    }
  }

  /// GET STATES
  // Future getStates() async {
  //   http.Response response = await http.get(
  //     Uri.parse(
  //         '${Constants.baseUrl}Location/get_all_states'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);
  //     int allStateDoctorCount = 0;
  //     result.forEach((element) {
  //       allStateDoctorCount += int.parse(element['doctors_count'].toString());
  //     });
  //     if (mounted) {
  //       setState(() {
  //         categoryOfStatess = result;
  //         categoryOfStatess.insert(
  //           0,
  //           {
  //             "id": "0",
  //             "name": "All States",
  //             "code": "",
  //             "created_at": "",
  //             "updated_at": "",
  //             "doctors_count": allStateDoctorCount
  //           },
  //         );
  //       });
  //     }
  //
  //     return result;
  //   } else {}
  // }
  /// ALL MEDICAL CENTER
  // Future getMedicalCenter({String location}) async {
  //   String url;
  //   print("location====>$location");
  //   Map<String, String> body;
  //   if (location == 'All States' || location == '' || location == null) {
  //     body = {"state_name": ""};
  //   } else {
  //     body = {"state_name": "$location"};
  //   }
  //   url =
  //       'http://www.unhbackend.com/AppServices/Patient/get_medical_center_detail';
  //   print("url--->$url");
  //   print("body----- --->$body");
  //   Map<String, String> header = {
  //     "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
  //     "Content-Type": "application/json",
  //   };
  //
  //   http.Response response = await http.post(Uri.parse(url),
  //       body: jsonEncode(body), headers: header);
  //   if (response.statusCode == 200) {
  //     print("response.body--->${response.body}");
  //     print("response.statusCode--->${response.statusCode}");
  //
  //     if (response.body != "" || response.body != null) {
  //       var result = jsonDecode(response.body);
  //       print("result--->$result");
  //       if (mounted) {
  //         setState(() {
  //           categoryOfMedicalCenter = result;
  //         });
  //       }
  //
  //       return result;
  //     }
  //   } else {}
  // }

  /// ACTIVE MEDICAL CENTER
  // Future getMedicalCenter({String stateName}) async {
  //   _bookAppointmentController.medicalLoader.value = true;
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
  //
  //   http.Response response = await http.get(Uri.parse(
  //       // stateName != "" ? url1 :
  //       url), headers: header);
  //   d.log("response.body--->${response.body}");
  //   d.log("response.statusCode--->${response.statusCode}");
  //
  //   if (response.statusCode == 200) {
  //     if (response.body != "" || response.body != null) {
  //       var result = jsonDecode(response.body);
  //       d.log("result--->$result");
  //
  //       setState(() {
  //         categoryOfMedicalCenter = result['data']['locations'];
  //         if (categoryOfMedicalCenter.length == 1) {
  //           medicalName =
  //               categoryOfMedicalCenter.first['post_title'].toString();
  //           print('medicalName---------->>>>>>>>${medicalName}');
  //           chooseMedicalCenter =
  //               categoryOfMedicalCenter.first['ID'].toString();
  //           _bookAppointmentController.getSpecialities(false.obs,
  //               stateId: chooseStateId ?? "",
  //               medicalCenterId: chooseMedicalCenter ?? '');
  //         }
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

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    FocusScope.of(context).unfocus();

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getUpcomingClassData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/hand.png'),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${Translate.of(context)?.translate('hello')} ${_userController.user.value.firstName ?? "Client"}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 23,
                                  ),
                            ),
                            Text(
                              Translate.of(context)!
                                  .translate('how_are_you_today'),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 21,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => Column(
                            children: <Widget>[
                              SectionHeaderWidget(
                                title: Translate.of(context)!
                                    .translate('next_appointment'),
                              ),
                              _patientHomeScreenController.isLoading.value
                                  // ? Center(
                                  //     child: CircularProgressIndicator(
                                  //         strokeWidth: 1),
                                  //   )
                                  ? /* Center(
                                      child: Utils.circular(),
                                    )*/

                                  SizedBox(
                                      height: 205,
                                      child: AppPlaceholder(
                                        child: Center(
                                          child: Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : _patientHomeScreenController
                                              .patientHomePageData
                                              .value
                                              .data
                                              ?.upcomingAppointments
                                              ?.isEmpty ??
                                          true
                                      // ? NoAppointmentsWidget()
                                      ? Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                'You have nothing yet!',
                                                style: TextStyle(fontSize: 21),
                                              ),
                                              MaterialButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return GetBuilder<
                                                            BookAppointmentController>(
                                                          builder:
                                                              (controller) {
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setState1) {
                                                                return SimpleDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  children: [
                                                                    ConstrainedBox(
                                                                      constraints:
                                                                          const BoxConstraints(
                                                                              maxWidth: 500),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Positioned(
                                                                            top:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Icon(Icons.clear, color: Colors.black, size: 28),
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              const SizedBox(height: 20),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(20),
                                                                                child: Align(
                                                                                  alignment: Alignment.topCenter,
                                                                                  child: Text(
                                                                                    Translate.of(context)!.translate('choose_health_center'),
                                                                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 20),

                                                                              // GestureDetector(
                                                                              //   onTap: () {
                                                                              //     showDialog(
                                                                              //       context:
                                                                              //           context,
                                                                              //       builder:
                                                                              //           (context) {
                                                                              //         return WillPopScope(
                                                                              //           onWillPop:
                                                                              //               () async {
                                                                              //             return false;
                                                                              //           },
                                                                              //           child:
                                                                              //               StatefulBuilder(
                                                                              //             builder: (context, setState234) {
                                                                              //               return Dialog(
                                                                              //                 backgroundColor: Colors.transparent,
                                                                              //                 child: ConstrainedBox(
                                                                              //                   constraints: BoxConstraints(
                                                                              //                     maxHeight: h * 0.6,
                                                                              //                   ),
                                                                              //                   child: Container(
                                                                              //                     decoration: BoxDecoration(
                                                                              //                       color: _isDark ? Colors.grey.shade800 : Colors.white,
                                                                              //                       borderRadius: BorderRadius.circular(5),
                                                                              //                     ),
                                                                              //                     height: h * 0.6,
                                                                              //                     width: w * 0.85,
                                                                              //                     child: Padding(
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
                                                                              //         await getMedicalCenter(
                                                                              //             stateName: stateName);
                                                                              //         setState1(
                                                                              //             () {});
                                                                              //       },
                                                                              //     );
                                                                              //   },
                                                                              //   child:
                                                                              //       commonContainer(
                                                                              //     child:
                                                                              //         Padding(
                                                                              //       padding: EdgeInsets.only(
                                                                              //           left:
                                                                              //               20,
                                                                              //           right:
                                                                              //               12),
                                                                              //       child:
                                                                              //           Row(
                                                                              //         children: [
                                                                              //           Text(
                                                                              //             stateName == "" ? 'Select State' : '$stateName',
                                                                              //             style: TextStyle(
                                                                              //               fontSize: 18,
                                                                              //               color: stateName != ""
                                                                              //                   ? _isDark
                                                                              //                       ? Colors.white
                                                                              //                       : Colors.black
                                                                              //                   : Colors.grey,
                                                                              //             ),
                                                                              //           ),
                                                                              //           const Spacer(),
                                                                              //           Icon(
                                                                              //             Icons.arrow_drop_down,
                                                                              //             color: !_isDark ? Colors.grey.shade800 : Colors.white,
                                                                              //           )
                                                                              //         ],
                                                                              //       ),
                                                                              //     ),
                                                                              //   ),
                                                                              // ),

                                                                              // Padding(
                                                                              //   padding: const EdgeInsets
                                                                              //           .symmetric(
                                                                              //       horizontal:
                                                                              //           20),
                                                                              //   child:
                                                                              //       DropdownButtonFormField(
                                                                              //     menuMaxHeight:
                                                                              //         h *
                                                                              //             0.85,
                                                                              //     decoration:
                                                                              //         const InputDecoration(
                                                                              //       border:
                                                                              //           OutlineInputBorder(
                                                                              //         borderSide:
                                                                              //             BorderSide(
                                                                              //           color:
                                                                              //               Colors.grey,
                                                                              //         ),
                                                                              //       ),
                                                                              //     ),
                                                                              //     isExpanded:
                                                                              //         true,
                                                                              //     hint:
                                                                              //         Text(
                                                                              //       'Select State',
                                                                              //       style:
                                                                              //           TextStyle(
                                                                              //         color:
                                                                              //             Colors.grey,
                                                                              //         fontWeight:
                                                                              //             FontWeight.w400,
                                                                              //       ),
                                                                              //     ),
                                                                              //     // Initial Value
                                                                              //     value:
                                                                              //         categoryOfStatesDropDowns,
                                                                              //
                                                                              //     // Down Arrow Icon
                                                                              //     icon: const Icon(
                                                                              //         Icons
                                                                              //             .arrow_drop_down_outlined),
                                                                              //
                                                                              //     // Array list of items
                                                                              //     items: categoryOfStatess
                                                                              //         .map(
                                                                              //             (item) {
                                                                              //       return DropdownMenuItem(
                                                                              //         enabled:
                                                                              //             true,
                                                                              //         onTap:
                                                                              //             () async {
                                                                              //           chooseStateId =
                                                                              //               item['id'];
                                                                              //           chooseMedicalCenter =
                                                                              //               null;
                                                                              //           categoryOfMedicalCenterDropDowns =
                                                                              //               null;
                                                                              //           setState1(() {});
                                                                              //           print('drop');
                                                                              //
                                                                              //           print("item[name]--->${item['name']}");
                                                                              //           await getMedicalCenter(location: item['name']);
                                                                              //
                                                                              //           await _bookAppointmentController.getSpecialities(false.obs,
                                                                              //               stateId: chooseStateId == '0' ? '' : chooseStateId ?? '');
                                                                              //
                                                                              //           setState1(() {});
                                                                              //           print('=ff===iddddddddd$chooseStateId');
                                                                              //         },
                                                                              //         value:
                                                                              //             item['name'].toString(),
                                                                              //         child:
                                                                              //             Text('${item['name'].toString()} (${item['doctors_count'].toString()})'),
                                                                              //       );
                                                                              //     }).toList(),
                                                                              //     // After selecting the desired option,it will
                                                                              //     // change button value to selected value
                                                                              //     onChanged:
                                                                              //         (newValue) {
                                                                              //       setState(
                                                                              //           () {
                                                                              //         categoryOfStatesDropDowns =
                                                                              //             newValue;
                                                                              //       });
                                                                              //       print(
                                                                              //           categoryOfStatesDropDowns);
                                                                              //     },
                                                                              //   ),
                                                                              // ),
                                                                              // SizedBox(
                                                                              //     height:
                                                                              //         20),
                                                                              // Padding(
                                                                              //   padding: const EdgeInsets
                                                                              //           .symmetric(
                                                                              //       horizontal:
                                                                              //           20),
                                                                              //   child:
                                                                              //       DropdownButtonFormField(
                                                                              //     menuMaxHeight:
                                                                              //         h *
                                                                              //             0.85,
                                                                              //     decoration:
                                                                              //         const InputDecoration(
                                                                              //       border:
                                                                              //           OutlineInputBorder(
                                                                              //         borderSide:
                                                                              //             BorderSide(
                                                                              //           color:
                                                                              //               Colors.grey,
                                                                              //         ),
                                                                              //       ),
                                                                              //     ),
                                                                              //     isExpanded:
                                                                              //         true,
                                                                              //     hint:
                                                                              //         Text(
                                                                              //       'Select Medical Center',
                                                                              //       style:
                                                                              //           TextStyle(
                                                                              //         color:
                                                                              //             Colors.grey,
                                                                              //         fontWeight:
                                                                              //             FontWeight.w400,
                                                                              //       ),
                                                                              //     ),
                                                                              //     // Initial Value
                                                                              //     value:
                                                                              //         categoryOfMedicalCenterDropDowns,
                                                                              //
                                                                              //     // Down Arrow Icon
                                                                              //     icon: const Icon(
                                                                              //         Icons
                                                                              //             .arrow_drop_down_outlined),
                                                                              //
                                                                              //     // Array list of items
                                                                              //     items: categoryOfMedicalCenter
                                                                              //         .map(
                                                                              //             (item) {
                                                                              //       return DropdownMenuItem(
                                                                              //         // enabled:
                                                                              //         //     true,
                                                                              //         onTap:
                                                                              //             () async {
                                                                              //           chooseMedicalCenter =
                                                                              //               item['ID'].toString();
                                                                              //           await _bookAppointmentController.getSpecialities(false.obs,
                                                                              //               stateId: chooseStateId ?? "",
                                                                              //               medicalCenterId: chooseMedicalCenter ?? '');
                                                                              //           setState1(() {});
                                                                              //           print('drop');
                                                                              //           print('=ff===iddddddddd$chooseMedicalCenter');
                                                                              //         },
                                                                              //         value:
                                                                              //             item['post_title'].toString(),
                                                                              //         child:
                                                                              //             Text('${item['post_title'].toString()} (${item['doctors_count'].toString()})'),
                                                                              //       );
                                                                              //     }).toList(),
                                                                              //     // After selecting the desired option,it will
                                                                              //     // change button value to selected value
                                                                              //     onChanged:
                                                                              //         (newValue) {
                                                                              //       setState(
                                                                              //           () {
                                                                              //         categoryOfMedicalCenterDropDowns =
                                                                              //             newValue;
                                                                              //       });
                                                                              //       print(
                                                                              //           categoryOfMedicalCenterDropDowns);
                                                                              //     },
                                                                              //   ),
                                                                              // ),

                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  if (controller.categoryOfMedicalCenter.isNotEmpty) {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return PopScope(
                                                                                          canPop: false,
                                                                                          child: StatefulBuilder(
                                                                                            builder: (context, setState234) {
                                                                                              return Dialog(
                                                                                                backgroundColor: Colors.transparent,
                                                                                                child: ConstrainedBox(
                                                                                                  constraints: BoxConstraints(maxHeight: h * 0.6, maxWidth: 550),
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: _isDark ? Colors.grey.shade800 : Colors.white,
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    // height: h * 0.6,
                                                                                                    // width: w * 0.85,
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.only(
                                                                                                        top: h * 0.015,
                                                                                                        left: h * 0.015,
                                                                                                        right: h * 0.015,
                                                                                                        bottom: 0,
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                child: Container(
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: _isDark ? Colors.grey.shade800 : Colors.white,
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
                                                                                                                      decoration: const InputDecoration(contentPadding: EdgeInsets.only(top: 10, left: 16), suffixIcon: Icon(Icons.search), enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, hintText: 'Search...'),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              const SizedBox(
                                                                                                                width: 15,
                                                                                                              ),
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
                                                                                                          SizedBox(
                                                                                                            height: h * 0.01,
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: Builder(builder: (context) {
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
                                                                                                                            searchController.clear();
                                                                                                                            controller.setMedicalCenterId(
                                                                                                                              controller.categoryOfMedicalCenter[index]['ID'].toString(),
                                                                                                                              controller.categoryOfMedicalCenter[index]['post_title'].toString(),
                                                                                                                              controller.categoryOfMedicalCenter[index]['google_form_url'].toString(),
                                                                                                                            );

                                                                                                                            // await _bookAppointmentController.getSpecialities(false.obs, stateId: chooseStateId ?? "", medicalCenterId: controller.chooseMedicalCenter ?? '');
                                                                                                                            await _bookAppointmentController.getDoctorSpecialities("", context, stateId: chooseStateId ?? "", medicalCenterId: controller.chooseMedicalCenter ?? '');

                                                                                                                            setState1(() {});
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
                                                                                                            }),
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
                                                                                      },
                                                                                    );
                                                                                  } else if (_bookAppointmentController.medicalLoader.value == true) {
                                                                                    Get.showSnackbar(
                                                                                      const GetSnackBar(
                                                                                        backgroundColor: Colors.blue,
                                                                                        duration: Duration(seconds: 2),
                                                                                        messageText: Text(
                                                                                          'Please wait...',
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    Get.showSnackbar(
                                                                                      const GetSnackBar(
                                                                                        backgroundColor: Colors.red,
                                                                                        duration: Duration(seconds: 2),
                                                                                        messageText: Text(
                                                                                          'No medical centers available',
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: commonContainer(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 20, right: 12),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            controller.medicalName == "" ? 'Select Medical Center' : controller.medicalName,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: TextStyle(
                                                                                              fontSize: 18,
                                                                                              color: controller.medicalName != ""
                                                                                                  ? _isDark
                                                                                                      ? Colors.white
                                                                                                      : Colors.black
                                                                                                  : Colors.grey,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.arrow_drop_down,
                                                                                          color: controller.categoryOfMedicalCenter.isEmpty
                                                                                              ? Colors.grey
                                                                                              : _isDark
                                                                                                  ? Colors.white
                                                                                                  : Colors.black,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              // RadioListTile(
                                                                              //   title:
                                                                              //       Text('Indigenous Health'),
                                                                              //   groupValue:
                                                                              //       controller.ihOrNatives,
                                                                              //   value:
                                                                              //       0,
                                                                              //   onChanged:
                                                                              //       (value) {
                                                                              //     controller.changeValue(value);
                                                                              //     setState1(() {});
                                                                              //   },
                                                                              // ),
                                                                              // RadioListTile(
                                                                              //   title: Text('United Natives'),
                                                                              //   groupValue: controller.ihOrNatives,
                                                                              //   value: 1,
                                                                              //   onChanged: (value) {
                                                                              //     controller.changeValue(value);
                                                                              //     setState1(() {});
                                                                              //   },
                                                                              // ),

                                                                              const SizedBox(height: 10),
                                                                              // Obx(
                                                                              //   () =>
                                                                              //       Container(
                                                                              //     height:
                                                                              //         500,
                                                                              //     width: Get
                                                                              //         .width,
                                                                              //     child: StaggeredGridView
                                                                              //         .countBuilder(
                                                                              //       padding:
                                                                              //           EdgeInsets.symmetric(horizontal: 10),
                                                                              //       crossAxisCount:
                                                                              //           1,
                                                                              //       physics:
                                                                              //           NeverScrollableScrollPhysics(),
                                                                              //       shrinkWrap:
                                                                              //           true,
                                                                              //       itemCount:
                                                                              //           _bookAppointmentController.specialitiesModelData.value.specialities?.length ??
                                                                              //               0,
                                                                              //       staggeredTileBuilder:
                                                                              //           (int index) =>
                                                                              //               StaggeredTile.fit(2),
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
                                                                              //             onTap: () {
                                                                              //               print('demo....');
                                                                              //               // Navigator.of(context)
                                                                              //               //     .pushNamed(Routes.bookingStep2);
                                                                              //
                                                                              //               Get.toNamed(Routes.bookingStep2, arguments: '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}');
                                                                              //             },
                                                                              //             borderRadius: BorderRadius.circular(4),
                                                                              //             child: Padding(
                                                                              //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                              //               child: Row(
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
                                                                                    Get.toNamed(Routes.bookingStep2, arguments: ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}');
                                                                                  },
                                                                                  borderRadius: BorderRadius.circular(4),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        CircleAvatar(backgroundColor: Colors.grey[300], backgroundImage: const AssetImage('assets/images/medicine.png'), radius: 25),
                                                                                        const SizedBox(width: 10),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            '${Translate.of(context)?.translate('Provider')}(${_bookAppointmentController.doctorCount.toString()})',
                                                                                            maxLines: 2,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: const TextStyle(
                                                                                              fontSize: 18,
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
                                                                              const SizedBox(height: 20),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    fixedSize: Size(w, 40),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    // int index = _bookAppointmentController.specialitiesModelData.value.specialities.indexWhere((element) => element.isCheckedBox == true);

                                                                                    Get.toNamed(
                                                                                      Routes.bookingStep2,
                                                                                      arguments: /*index < 0 ?*/ ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ''}' /*: '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}'*/,
                                                                                    );
                                                                                    // Navigator.pop(context);
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Apply',
                                                                                    style: TextStyle(fontSize: 20),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
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
                                                    ).then((value) =>
                                                        _patientHomeScreenController
                                                            .getPatientHomePage());

                                                    /* /// TEMP ========== COMING SOON ++++++++++++++++++++++++++

                                                    _onAlertWithCustomContentPress(
                                                        context);*/

                                                    /// OLD METHOD

                                                    /*FocusScope.of(context)
                                                        .requestFocus(FocusNode());
                                                    Navigator.push(
                                                        context,
                                                        NavSlideFromBottom(
                                                            page:
                                                                HealthConcernPage()));*/
                                                  },
                                                  color: kColorBlue,
                                                  child: const Text(
                                                    'BOOK NOW',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                        )
                                      : const NextAppointmentWidget(),

                              ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                              SectionHeaderWidget(
                                title: Translate.of(context)!
                                    .translate('upcoming_appointments'),
                                onPressed: () {
                                  return Navigator.of(context)
                                      .pushNamed(Routes.myAppointments)
                                      .then((value) =>
                                          _patientHomeScreenController
                                              .getPatientHomePage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => _patientHomeScreenController.isLoading.value
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 200,
                                // child: Center(
                                //     child: CircularProgressIndicator(
                                //         strokeWidth: 1)),
                                // child: Center(
                                //   child: Utils.circular(),
                                // ),

                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Row(
                                    children: List.generate(
                                        3,
                                        (index) => AppPlaceholder(
                                              child: Center(
                                                child: Container(
                                                  width: 140,
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  height: 170,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              )
                            : _patientHomeScreenController
                                        .patientHomePageData
                                        .value
                                        .data
                                        ?.upcomingAppointments
                                        ?.isNotEmpty ??
                                    false
                                ? Builder(builder: (context) {
                                    return Container(
                                      color: Colors.transparent,
                                      height: 200,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 15),
                                        itemCount: _patientHomeScreenController
                                                .patientHomePageData
                                                .value
                                                .data
                                                ?.upcomingAppointments
                                                ?.length ??
                                            0,
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        itemBuilder: (context, index) {
                                          return VisitedDoctorListItem(
                                            isHome: true,
                                            doctor: _patientHomeScreenController
                                                .patientHomePageData
                                                .value
                                                .data!
                                                .upcomingAppointments![index],
                                          );
                                        },
                                      ),
                                    );
                                  })
                                : Container(
                                    color: Colors.transparent,
                                    height: 100,
                                    child: const Center(
                                      child: Text(
                                        'You have nothing yet!',
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ),
                      ),
                      // _isLoading
                      //     ? CircularProgressIndicator()
                      //     : Container(
                      //         height: 200,
                      //         child: Obx(
                      //           () => ListView.separated(
                      //             separatorBuilder: (context, index) =>
                      //                 SizedBox(
                      //               width: 15,
                      //             ),
                      //             itemCount: _patientHomeScreenController
                      //                     .visitedDoctorUpcomingPastData
                      //                     .value
                      //                     .upcomingPast
                      //                     ?.pastDoctor
                      //                     ?.length ??
                      //                 0,
                      //             scrollDirection: Axis.horizontal,
                      //             padding: EdgeInsets.symmetric(horizontal: 20),
                      //             itemBuilder: (context, index) {
                      //               return VisitedDoctorListItem(
                      //                   doctor: _patientHomeScreenController
                      //                           .visitedDoctorUpcomingPastData
                      //                           .value
                      //                           .upcomingPast
                      //                           ?.pastDoctor[index] ??
                      //                       Text('No Visited Doctor'));
                      //             },
                      //           ),
                      //         ),
                      //       ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12)
                            .copyWith(right: 20),
                        child: SectionHeaderWidget(
                          title: Translate.of(context)!
                              .translate('your_prescriptions'),
                          onPressed: () {
                            return Navigator.of(context)
                                .pushNamed(
                                    Routes.patientHomeAllPrescriptionPage)
                                .then((value) => _patientHomeScreenController
                                    .getPatientHomePage());
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Obx(
                              () => _patientHomeScreenController.isLoading.value
                                  ? /*Container(
                                          height: 100,
                                          // child: Center(
                                          //   child: CircularProgressIndicator(
                                          //       strokeWidth: 1),
                                          // ),
                                          child: Center(
                                            child: Utils.circular(),
                                          ),
                                        )*/

                                  SizedBox(
                                      height: 125,
                                      child: AppPlaceholder(
                                        child: Center(
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : _patientHomeScreenController
                                              .patientHomePageData
                                              .value
                                              .data
                                              ?.prescriptions
                                              ?.isNotEmpty ??
                                          false
                                      ? GestureDetector(
                                          onTap: () async {
                                            await Get.toNamed(
                                                    Routes.prescriptionpage,
                                                    arguments:
                                                        _patientHomeScreenController
                                                            .patientHomePageData
                                                            .value
                                                            .data
                                                            ?.prescriptions
                                                            ?.first
                                                            .appointmentId)
                                                ?.then((value) =>
                                                    _patientHomeScreenController
                                                        .getPatientHomePage());
                                          },
                                          child: TestAndPrescriptionCardWidget(
                                              //subTitle: DateFormat('MM').format(DateTime.parse(_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first?.created)) ,
                                              title:
                                                  '${_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first.medicineName ?? "Cipla X524"} ${(_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first.additionalNotes ?? "Pain Killer").tr()}',
                                              subTitle:
                                                  '${Translate.of(context)?.translate('given_by')} Dr. ${_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first.doctorName ?? ""} on ${DateFormat('EEEE, d MMMM yyyy').format(Utils.formattedDate("${_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first.appointmentDate} ${_patientHomeScreenController.patientHomePageData.value.data?.prescriptions?.first.appointmentTime}"))}',
                                              image: 'icon_medical_recipe.png'),
                                        )
                                      : const SizedBox(
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              'You have nothing yet!',
                                              style: TextStyle(fontSize: 21),
                                            ),
                                          ),
                                        ),
                            ),

                            /// TEMP HIDE RESEARCH AND INFORMATION ==== DON"T DELETE

                            /*SectionHeaderWidget(
                              title: 'Research and Information'.tr(),
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.blogpage1),
                            ),
                            Obx(
                              () => _patientHomeScreenController.isLoading.value
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1))
                                  : _patientHomeScreenController
                                              .patientHomePageData
                                              .value
                                              .data
                                              ?.researchDocs
                                              ?.isNotEmpty ??
                                          false
                                      ? TestAndPrescriptionCardWidget(
                                          // subTitle: _patientHomeScreenController.patientHomePageData.value.data?.researchDocs?.first?.modified,
                                          title:
                                              '${_patientHomeScreenController.patientHomePageData.value.data?.researchDocs?.first?.researchTitle ?? ""}',
                                          subTitle:
                                              '${DateFormat('EEEE, dd MMMM yyyy').format(DateFormat("yyyy-MM-dd").parse(_patientHomeScreenController.patientHomePageData.value.data?.researchDocs?.first?.modified))}',

                                          // '${ ?? " "}',
                                          image: 'icon_medical_check_up.png',
                                        )
                                      : Center(
                                          child: Text(
                                          'You have nothing yet!',
                                          style: TextStyle(fontSize: 18),
                                        )),
                            ),*/

                            /// TEMP HIDE UPCOMING CLASSES ==== DON"T DELETE

                            /*Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Upcoming Classes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 23),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      await Navigator.of(context)
                                          .pushNamed(Routes.schedule_class);
                                      patientScheduledClassController
                                          .getClassListPatient(
                                              id: Prefs.getString(
                                                  Prefs.SOCIALID),
                                              date: '');
                                    },
                                    child: Text(
                                      Translate.of(context)
                                          .translate('see_all'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GetBuilder<PatientScheduledClassController>(
                              builder: (controller) {
                                if (controller
                                        .getClassPatientApiResponse.status ==
                                    Status.LOADING) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1)),
                                  );
                                }

                                ClassListPatientResponseModel response =
                                    controller.getClassPatientApiResponse.data;

                                if (response.data == null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Center(
                                      child: Text(
                                        'You have nothing yet!',
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  );
                                } else if (response.data.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Center(
                                      child: Text(
                                        'You have nothing yet!',
                                        style: TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  height: h * 0.3,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: response.data.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              CourseDetailScreen(
                                                  classId:
                                                      response.data[index].id,
                                                  isBooked: response
                                                      .data[index].isBooked,
                                                  mySelectedDate: response
                                                      .data[index].classDate),
                                            );
                                          },
                                          child: Container(
                                            width: w * 0.375,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: _isDark
                                                  ? Colors.grey.withOpacity(0.2)
                                                  : Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0x0c000000),
                                                    offset: Offset(0, 5),
                                                    blurRadius: 5,
                                                    spreadRadius: 0),
                                                BoxShadow(
                                                    color: Color(0x0c000000),
                                                    offset: Offset(0, -5),
                                                    blurRadius: 5,
                                                    spreadRadius: 0),
                                              ],
                                            ),
                                            // width: w,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.all(h * 0.009),
                                                  child: Container(
                                                    width: w,
                                                    height: h * 0.077,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: OctoImage(
                                                          image: CachedNetworkImageProvider(response.data[index].classFeaturedImage ==
                                                                      null ||
                                                                  response
                                                                          .data[
                                                                              index]
                                                                          .classFeaturedImage ==
                                                                      ''
                                                              ? 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'
                                                              : response
                                                                  .data[index]
                                                                  .classFeaturedImage),
                                                          placeholderBuilder:
                                                              OctoPlaceholder
                                                                  .blurHash(
                                                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                            // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                                                          ),
                                                          errorBuilder:
                                                              OctoError
                                                                  .circleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            text: Image.network(
                                                                'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                                                          ),
                                                          fit: BoxFit.fill,
                                                          height: h,
                                                          width: w),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: w * 0.03),
                                                  child: Text(
                                                    'Dr.${response.data[index].doctorFullName ?? ''}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: w * 0.03),
                                                  child: Text(
                                                    response.data[index].title
                                                            .toUpperCase() ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState1) {
                                                            return SimpleDialog(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Icon(
                                                                            Icons
                                                                                .clear,
                                                                            color:
                                                                                Colors.black,
                                                                            size: 28),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(20),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            child:
                                                                                Text(
                                                                              (response.data[index].isBooked ?? false) == false ? "Book Now" : "Withdraw",
                                                                              style: Theme.of(context).textTheme.headline6.copyWith(
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            SizedBox(width: w * 0.04),
                                                                            Expanded(
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  fixedSize: Size(w, 40),
                                                                                ),
                                                                                child: Text(
                                                                                  "Cancel",
                                                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 15),
                                                                            Expanded(
                                                                              child: ElevatedButton(
                                                                                onPressed: () async {
                                                                                  BookWithdrawReqModel model = BookWithdrawReqModel();
                                                                                  model.action = (response.data[index].isBooked ?? false) == false ? '1' : '2';
                                                                                  await patientScheduledClassController.bookWithdrawClass(model: model, classId: response.data[index].id, id: Prefs.getString(Prefs.SOCIALID)).then((value) {
                                                                                    if (patientScheduledClassController.bookWithdrawClassApiResponse.status == Status.COMPLETE) {
                                                                                      MessageStatusResponseModel response = patientScheduledClassController.bookWithdrawClassApiResponse.data;
                                                                                      if (response.status == 'Success') {
                                                                                        CommonSnackBar.snackBar(message: response.message);
                                                                                        Future.delayed(Duration(seconds: 2), () {
                                                                                          Navigator.pop(context);
                                                                                          patientScheduledClassController.getClassListPatient(id: Prefs.getString(Prefs.SOCIALID), date: '');
                                                                                        });
                                                                                      } else {
                                                                                        CommonSnackBar.snackBar(message: response.message);
                                                                                        Future.delayed(Duration(seconds: 2), () {
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                      }
                                                                                    } else {
                                                                                      CommonSnackBar.snackBar(message: "Server error");
                                                                                    }
                                                                                  });
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  fixedSize: Size(w, 40),
                                                                                ),
                                                                                child: Text(
                                                                                  "Confirm",
                                                                                  style: TextStyle(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: w * 0.04),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                      ],
                                                                    ),
                                                                    GetBuilder<
                                                                        PatientScheduledClassController>(
                                                                      builder:
                                                                          (controller) {
                                                                        if (controller.bookWithdrawClassApiResponse.status ==
                                                                            Status.LOADING) {
                                                                          return Container(
                                                                            height:
                                                                                h * 0.205,
                                                                            width:
                                                                                Get.width,
                                                                            color:
                                                                                Colors.grey.withOpacity(0.3),
                                                                            child:
                                                                                Center(
                                                                              child: CircularProgressIndicator(),
                                                                            ),
                                                                          );
                                                                        }
                                                                        return SizedBox();
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );

                                                      //  showDialog(
                                                      //   context: context,
                                                      //   builder: (context) => Dialog(
                                                      //     shape:
                                                      //         RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //           BorderRadius.circular(
                                                      //               20),
                                                      //     ),
                                                      //     child: Container(
                                                      //       height: h * 0.22,
                                                      //       width: w * 0.8,
                                                      //       decoration: BoxDecoration(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(20),
                                                      //       ),
                                                      //       child: Stack(
                                                      //         children: [
                                                      //           Positioned(
                                                      //             right: 15,
                                                      //             top: 15,
                                                      //             child:
                                                      //                 GestureDetector(
                                                      //               onTap: () {
                                                      //                 Navigator.of(
                                                      //                         context)
                                                      //                     .pop();
                                                      //               },
                                                      //               child: Icon(
                                                      //                 Icons.close,
                                                      //                 size: 30,
                                                      //               ),
                                                      //             ),
                                                      //           ),
                                                      //           Column(
                                                      //             mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .center,
                                                      //             children: [
                                                      //               Padding(
                                                      //                 padding:
                                                      //                     const EdgeInsets
                                                      //                             .only(
                                                      //                         top:
                                                      //                             30),
                                                      //                 child: Center(
                                                      //                   child: Text(
                                                      //                     response.data[index].isBooked ==
                                                      //                             false
                                                      //                         ? "Confirm"
                                                      //                         : "Withdraw",
                                                      //                     style:
                                                      //                         TextStyle(
                                                      //                       color: _isDark
                                                      //                           ? Colors
                                                      //                               .white
                                                      //                           : Colors
                                                      //                               .black,
                                                      //                       fontWeight:
                                                      //                           FontWeight
                                                      //                               .bold,
                                                      //                       fontSize:
                                                      //                           25,
                                                      //                     ),
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //               SizedBox(
                                                      //                 height:
                                                      //                     h *
                                                      //                         0.04,
                                                      //               ),
                                                      //               Row(
                                                      //                 mainAxisAlignment:
                                                      //                     MainAxisAlignment
                                                      //                         .spaceEvenly,
                                                      //                 children: [
                                                      //                   SizedBox(
                                                      //                     width:
                                                      //                         w *
                                                      //                             0.04,
                                                      //                   ),
                                                      //                   Expanded(
                                                      //                     child:
                                                      //                         ElevatedButton(
                                                      //                       onPressed:
                                                      //                           () {
                                                      //                         Navigator.of(context)
                                                      //                             .pop();
                                                      //                       },
                                                      //                       child:
                                                      //                           Padding(
                                                      //                         padding: EdgeInsets.symmetric(
                                                      //                             vertical: h *
                                                      //                                 0.008,
                                                      //                             horizontal:
                                                      //                                 15),
                                                      //                         child:
                                                      //                             Text(
                                                      //                           "Cancel",
                                                      //                           style:
                                                      //                               TextStyle(
                                                      //                             fontSize:
                                                      //                                 20,
                                                      //                             fontWeight:
                                                      //                                 FontWeight.bold,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   ),
                                                      //                   SizedBox(
                                                      //                     width: 15,
                                                      //                   ),
                                                      //                   Expanded(
                                                      //                     child:
                                                      //                         ElevatedButton(
                                                      //                       onPressed:
                                                      //                           () async {
                                                      //                         BookWithdrawReqModel
                                                      //                             model =
                                                      //                             BookWithdrawReqModel();
                                                      //                         model
                                                      //                             .action = response.data[index].isBooked ==
                                                      //                                 false
                                                      //                             ? '1'
                                                      //                             : '2';
                                                      //                         await patientScheduledClassController
                                                      //                             .bookWithdrawClass(
                                                      //                                 model: model,
                                                      //                                 classId: response.data[index].id,
                                                      //                                 id: Prefs.getString(Prefs.SOCIALID))
                                                      //                             .then((value) {
                                                      //                           if (patientScheduledClassController.bookWithdrawClassApiResponse.status ==
                                                      //                               Status.COMPLETE) {
                                                      //                             MessageStatusResponseModel
                                                      //                                 response =
                                                      //                                 patientScheduledClassController.bookWithdrawClassApiResponse.data;
                                                      //                             if (response.status ==
                                                      //                                 'Success') {
                                                      //                               CommonSnackBar.snackBar(message: response.message);
                                                      //                               Future.delayed(Duration(seconds: 2), () {
                                                      //                                 Navigator.pop(context);
                                                      //                                 patientScheduledClassController.getClassListPatient(id: Prefs.getString(Prefs.SOCIALID), date: '');
                                                      //                               });
                                                      //                             } else {
                                                      //                               CommonSnackBar.snackBar(message: response.message);
                                                      //                               Future.delayed(Duration(seconds: 2), () {
                                                      //                                 Navigator.pop(context);
                                                      //                               });
                                                      //                             }
                                                      //                           } else {
                                                      //                             CommonSnackBar.snackBar(message: "Server error");
                                                      //                           }
                                                      //                         });
                                                      //                       },
                                                      //                       child:
                                                      //                           Padding(
                                                      //                         padding:
                                                      //                             EdgeInsets.symmetric(vertical: h * 0.008),
                                                      //                         child:
                                                      //                             Text(
                                                      //                           "Confirm",
                                                      //                           style:
                                                      //                               TextStyle(
                                                      //                             fontSize:
                                                      //                                 18,
                                                      //                             fontWeight:
                                                      //                                 FontWeight.bold,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   ),
                                                      //                   SizedBox(
                                                      //                     width:
                                                      //                         w *
                                                      //                             0.04,
                                                      //                   ),
                                                      //                 ],
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //           GetBuilder<
                                                      //               PatientScheduledClassController>(
                                                      //             builder:
                                                      //                 (controller) {
                                                      //               if (controller
                                                      //                       .bookWithdrawClassApiResponse
                                                      //                       .status ==
                                                      //                   Status
                                                      //                       .LOADING) {
                                                      //                 return Container(
                                                      //                   height: Get
                                                      //                       .height,
                                                      //                   width:
                                                      //                       w,
                                                      //                   color: Colors
                                                      //                       .grey
                                                      //                       .withOpacity(
                                                      //                           0.3),
                                                      //                   child: Center(
                                                      //                     child:
                                                      //                         CircularProgressIndicator(),
                                                      //                   ),
                                                      //                 );
                                                      //               }
                                                      //               return SizedBox();
                                                      //             },
                                                      //           )
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // );
                                                  },
                                                  child: (response.data[index]
                                                                  .isBooked ??
                                                              false) ==
                                                          false
                                                      ? buildContainerButton(
                                                          h: h,
                                                          title: "Book Now",
                                                          colorText:
                                                              Colors.white,
                                                          colorName:
                                                              Colors.blueAccent)
                                                      : buildContainerButton(
                                                          h: h,
                                                          title: "Withdraw",
                                                          colorText:
                                                              Colors.white,
                                                          colorName:
                                                              Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),*/

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Container buildContainerButton(
      {required String title,
      required Color colorName,
      required Color colorText,
      required double h}) {
    return Container(
      height: h * 0.044,
      // width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.all(Get.width * 0.02),

      decoration: BoxDecoration(
        color: colorName,
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0.5, 0.5),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title",
        style: TextStyle(color: colorText, fontSize: 18),
      ),
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

  // _onAlertWithCustomContentPress(context) {
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
  //       image: Image(
  //         image: AssetImage('assets/images/Coming soon.gif'),
  //       ),
  //       title: "Coming Soon",
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
