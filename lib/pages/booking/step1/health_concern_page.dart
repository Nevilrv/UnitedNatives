// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
// import 'package:doctor_appointment_booking/controller/ads_controller.dart';
// import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
// import 'package:doctor_appointment_booking/controller/user_controller.dart';
// import 'package:doctor_appointment_booking/data/pref_manager.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// import 'package:doctor_appointment_booking/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart' hide Trans;
// import 'package:http/http.dart' as http;
//
// import '../../../routes/routes.dart';
// import '../../splash_page.dart';
//
// bool isSelected = false;
//
// class HealthConcernPage extends StatefulWidget {
//   @override
//   State<HealthConcernPage> createState() => _HealthConcernPageState();
// }
//
// class _HealthConcernPageState extends State<HealthConcernPage> {
//   BookAppointmentController _bookAppointmentController =
//       Get.put(BookAppointmentController());
//
//   RxBool _isLoading = false.obs;
//   var categoryOfStatesDropDowns;
//   List categoryOfStatess = [];
//   var chooseStateId;
//
//   // bool isCheckedBox=false;
//
//   Future getStates() async {
//     http.Response response = await http.get(
//       Uri.parse('${Constants.baseUrl + Constants.getAllStates}'),
//     );
//
//     if (response.statusCode == 200) {
//       var result = json.decode(response.body);
//
//       setState(() {
//         categoryOfStatess = result;
//       });
//
//       print('=======states========$result');
//
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           print('--------------------$categoryOfStatess');
//           return StatefulBuilder(
//             builder: (BuildContext context,
//                 void Function(void Function()) setState) {
//               return SimpleDialog(
//                 contentPadding: EdgeInsets.zero,
//                 children: [
//                   Column(
//                     children: [
//                       SizedBox(height: 40),
//                       Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             Translate.of(context)
//                                 .translate('choose_health_concern'),
//                             style:
//                                 Theme.of(context).textTheme.headline6.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: DropdownButton(
//                           isExpanded: true,
//                           hint: Text(
//                             'Select State',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           // Initial Value
//                           value: categoryOfStatesDropDowns,
//
//                           // Down Arrow Icon
//                           icon: const Icon(Icons.arrow_drop_down_outlined),
//
//                           // Array list of items
//                           items: categoryOfStatess.map((item) {
//                             return DropdownMenuItem(
//                               onTap: () {
//                                 chooseStateId = item['id'];
//                                 print('drop');
//                                 print('====iddddddddd$chooseStateId');
//                               },
//                               value: item['name'].toString(),
//                               child: Text(item['name'].toString()),
//                             );
//                           }).toList(),
//                           // After selecting the desired option,it will
//                           // change button value to selected value
//                           onChanged: (newValue) {
//                             setState(() {
//                               categoryOfStatesDropDowns = newValue;
//                             });
//                             print(categoryOfStatesDropDowns);
//                           },
//                         ),
//                       ),
//                       Obx(
//                         () => GestureDetector(
//                           onLongPress: () {
//                             // setState(() {
//                             //   isSelected =isSelected? false:true;//this line
//                             // });
//                           },
//                           child: Container(
//                             height: 500,
//                             width: Get.width,
//                             child: StaggeredGridView.countBuilder(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               crossAxisCount: 1,
//                               // physics: NeverScrollableScrollPhysics(),
//                               //shrinkWrap: true,
//                               itemCount: _bookAppointmentController
//                                       .specialitiesModelData
//                                       .value
//                                       .specialities
//                                       ?.length ??
//                                   0,
//                               staggeredTileBuilder: (int index) =>
//                                   StaggeredTile.fit(2),
//                               mainAxisSpacing: 10,
//                               crossAxisSpacing: 10,
//                               itemBuilder: (context, index) {
//                                 // return HealthConcernItem(
//                                 //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
//                                 //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
//                                 //   onTap: () {
//                                 //     Navigator.of(context).pushNamed(Routes.bookingStep2);
//                                 //   },
//                                 // );
//                                 return Card(
//                                   child: InkWell(
//                                     onTap: () {
//                                       print('demo....');
//                                       // Navigator.of(context)
//                                       //     .pushNamed(Routes.bookingStep2);
//                                       Get.toNamed(Routes.bookingStep2,
//                                           arguments: _bookAppointmentController
//                                               .specialitiesModelData
//                                               .value
//                                               .specialities[index]
//                                               .id);
//                                     },
//                                     borderRadius: BorderRadius.circular(4),
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 15),
//                                       child: Row(
//                                         children: <Widget>[
//                                           CircleAvatar(
//                                             backgroundColor: Colors.grey[300],
//                                             backgroundImage: NetworkImage(
//                                                     "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
//                                                 AssetImage(
//                                                     'assets/images/medicine.png'),
//                                             radius: 25,
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}" ??
//                                                   Translate.of(context).translate(
//                                                           'Women\'s Health') +
//                                                       '\n',
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           Spacer(),
//                                           Checkbox(
//                                               value: _bookAppointmentController
//                                                   .specialitiesModelData
//                                                   .value
//                                                   .specialities[index]
//                                                   ?.isCheckedBox,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   _bookAppointmentController
//                                                       .specialitiesModelData
//                                                       .value
//                                                       .specialities[index]
//                                                       ?.isCheckedBox = value;
//                                                   print(
//                                                       '-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
//                                                 });
//                                               })
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             fixedSize: Size(Get.width, 35),
//                           ),
//                           onPressed: () {
//                             docFilter(
//                                 city: 3306,
//                                 state: chooseStateId,
//                                 userId: _userController.user.value.id,
//                                 specialityId: 5);
//                             Navigator.pop(context);
//                           },
//                           child: Text('Apply Filter '),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//       return result;
//     } else {}
//   }
//
//   getStatesData() async {
//     await getStates();
//   }
//
//   @override
//   void initState() {
//     // getStatesData();
//     // Future.delayed(Duration(seconds: 5),(){
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //     return showDialog(
//     //       context: context,
//     //       builder: (BuildContext context) {
//     //         print('--------------------$categoryOfStatess');
//     //         return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
//     //           return SimpleDialog( contentPadding: EdgeInsets.zero,
//     //             children: [
//     //               Column(
//     //                 children: [
//     //                   DropdownButton(
//     //                     isExpanded: false,
//     //                     hint: Text(
//     //                       'Select State',
//     //                       style: TextStyle(
//     //                         color: Colors.grey,
//     //                         fontWeight: FontWeight.w400,
//     //                       ),
//     //                     ),
//     //                     // Initial Value
//     //                     value: categoryOfStatesDropDowns,
//     //
//     //                     // Down Arrow Icon
//     //                     icon: const Icon(Icons.arrow_drop_down_outlined),
//     //
//     //                     // Array list of items
//     //                     items: categoryOfStatess.map((item) {
//     //                       return DropdownMenuItem(
//     //                         onTap: () {
//     //                           chooseStateId = item['id'];
//     //                           print('drop');
//     //                           print('====iddddddddd${chooseStateId}');
//     //                         },
//     //                         value: item['name'].toString(),
//     //                         child: Text(item['name'].toString()),
//     //                       );
//     //                     }).toList(),
//     //                     // After selecting the desired option,it will
//     //                     // change button value to selected value
//     //                     onChanged: (newValue) {
//     //                       setState(() {
//     //                         categoryOfStatesDropDowns = newValue;
//     //                       });
//     //                       print(categoryOfStatesDropDowns);
//     //                     },
//     //                   ),
//     //                   Obx(
//     //                         () => Container(height: Get.width,color: Colors.red,width: Get.width,
//     //                           child: StaggeredGridView.countBuilder(
//     //                       padding: EdgeInsets.symmetric(horizontal: 10),
//     //                       crossAxisCount: 1,
//     //                      // physics: NeverScrollableScrollPhysics(),
//     //                       //shrinkWrap: true,
//     //                       itemCount: _bookAppointmentController
//     //                             .specialitiesModelData
//     //                             .value
//     //                             .specialities
//     //                             ?.length ??
//     //                             0,
//     //                       staggeredTileBuilder: (int index) =>
//     //                             StaggeredTile.fit(2),
//     //                       mainAxisSpacing: 10,
//     //                       crossAxisSpacing: 10,
//     //                       itemBuilder: (context, index) {
//     //                           // return HealthConcernItem(
//     //                           //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
//     //                           //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
//     //                           //   onTap: () {
//     //                           //     Navigator.of(context).pushNamed(Routes.bookingStep2);
//     //                           //   },
//     //                           // );
//     //                           return Card(
//     //                             child: InkWell(
//     //                               onTap: () {
//     //                                 print('demo....');
//     //                                 // Navigator.of(context)
//     //                                 //     .pushNamed(Routes.bookingStep2);
//     //                                 Get.toNamed(Routes.bookingStep2,
//     //                                     arguments: _bookAppointmentController
//     //                                         .specialitiesModelData
//     //                                         .value
//     //                                         .specialities[index]
//     //                                         .id);
//     //                               },
//     //                               borderRadius: BorderRadius.circular(4),
//     //                               child: Padding(
//     //                                 padding: EdgeInsets.symmetric(
//     //                                     horizontal: 10, vertical: 15),
//     //                                 child: Row(
//     //                                   children: <Widget>[
//     //                                     CircleAvatar(
//     //                                       backgroundColor: Colors.grey[300],
//     //                                       backgroundImage: NetworkImage(
//     //                                           "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
//     //                                           AssetImage(
//     //                                               'assets/images/medicine.png'),
//     //                                       radius: 25,
//     //                                     ),
//     //                                     SizedBox(
//     //                                       width: 10,
//     //                                     ),
//     //                                     Expanded(
//     //                                       child: Text(
//     //                                         "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}" ??
//     //                                             "Women\'s Health".tr() + '\n',
//     //                                         maxLines: 2,
//     //                                         overflow: TextOverflow.ellipsis,
//     //                                       ),
//     //                                     ),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                             ),
//     //                           );
//     //                       },
//     //                     ),
//     //                         ),
//     //                   ),
//     //                 ],
//     //               ),
//     //             ],
//     //           );
//     //         },
//     //
//     //         );
//     //       },
//     //     );
//     //   });
//     // });
//
//     super.initState();
//   }
//
//   Future docFilter(
//       {@required var userId,
//       @required var specialityId,
//       @required var state,
//       @required var city}) async {
//     var header = {
//       "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
//       // "Content-Type": 'application/json',
//     };
//
//     Map<String, dynamic> body = {
//       "user_id": userId,
//       "speciality_id": specialityId,
//       "state": state,
//       "city": city
//     };
//     http.Response response = await http.post(
//       Uri.parse('${Constants.baseUrl + Constants.getAllDoctorByLocation}'),
//       headers: header,
//       body: jsonEncode(body),
//     );
//
//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body);
//       print('+++++++DOC FILTER+++++++$result');
//       return result;
//     } else {}
//   }
//
//   UserController _userController = Get.find<UserController>();
//
//   AdsController adsController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     _bookAppointmentController.getSpecialities(_isLoading);
//     return Stack(
//       children: [
//         GetBuilder<UserController>(
//           builder: (controller) {
//             print('user Id====${_userController.user.value.id}');
//             return GetBuilder<AdsController>(builder: (ads) {
//               return Scaffold(
//                 backgroundColor: Colors.grey.shade100,
//                 bottomNavigationBar: AdsBottomBar(
//                   ads: ads,
//
//                   context: context,
//
//                 ),
//                 appBar: AppBar(surfaceTintColor: Colors.transparent,
//                   centerTitle: true,
//                   title: Text(
//                     Translate.of(context).translate('book_an_appointment'),
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).textTheme.subtitle1.color,
//                         fontSize: 24),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 body: Column(
//                   children: <Widget>[
//                     Expanded(
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(20),
//                               child: Text(
//                                 Translate.of(context)
//                                     .translate('choose_health_concern'),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline6
//                                     .copyWith(
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                               ),
//                             ),
//                             Obx(
//                               () => StaggeredGridView.countBuilder(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 crossAxisCount: 4,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: _bookAppointmentController
//                                         .specialitiesModelData
//                                         .value
//                                         .specialities
//                                         ?.length ??
//                                     0,
//                                 staggeredTileBuilder: (int index) =>
//                                     StaggeredTile.fit(2),
//                                 mainAxisSpacing: 10,
//                                 crossAxisSpacing: 10,
//                                 itemBuilder: (context, index) {
//                                   // return HealthConcernItem(
//                                   //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
//                                   //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
//                                   //   onTap: () {
//                                   //     Navigator.of(context).pushNamed(Routes.bookingStep2);
//                                   //   },
//                                   // );
//                                   return Card(
//                                     child: InkWell(
//                                       onTap: () {
//                                         print('demo....');
//                                         // Navigator.of(context)
//                                         //     .pushNamed(Routes.bookingStep2);
//                                         Get.toNamed(Routes.bookingStep2,
//                                             arguments:
//                                                 _bookAppointmentController
//                                                     .specialitiesModelData
//                                                     .value
//                                                     .specialities[index]
//                                                     .id);
//                                       },
//                                       borderRadius: BorderRadius.circular(4),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 15),
//                                         child: Row(
//                                           children: <Widget>[
//                                             CircleAvatar(
//                                               backgroundColor: Colors.grey[300],
//                                               backgroundImage: NetworkImage(
//                                                       "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
//                                                   AssetImage(
//                                                       'assets/images/medicine.png'),
//                                               radius: 25,
//                                             ),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}" ??
//                                                     Translate.of(context).translate(
//                                                             'Women\'s Health') +
//                                                         '\n',
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             });
//           },
//         ),
//         // Obx(
//         //   () => Container(
//         //       child:
//         //           _isLoading.value ? ProgressIndicatorScreen() : Container()),
//         // ),
//       ],
//     );
//   }
// }
