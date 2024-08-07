// /*
// Name: Akshath Jain
// Date: 3/15/19
// Purpose: example app for the grouped buttons package
// */
//
// import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
// import 'package:doctor_appointment_booking/controller/user_controller.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// import 'package:doctor_appointment_booking/model/doctor_availability_display_model.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide Trans;
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../splash_page.dart';
// import 'checkbox_group.dart';
//
// class AvailabilityPage extends StatefulWidget {
//   @override
//   _AvailabilityPageState createState() => _AvailabilityPageState();
// }
//
// DoctorHomeScreenController _doctorHomeScreenController =
//     Get.find<DoctorHomeScreenController>();
// UserController _userController = Get.find<UserController>();
// bool isLoading = false;
//
// class _AvailabilityPageState extends State<AvailabilityPage> {
//   DateTime dateTime;
//   Duration duration;
//   DateTime currentDate;
//
//   Future<void> _selectDate(BuildContext context) async {
//     selectedItem.clear();
//     final DateTime pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: new DateTime.now().add(new Duration(days: 365)),
//     );
//     if (pickedDate != null && pickedDate != currentDate) filterData(pickedDate);
//     setState(() {
//       currentDate = pickedDate;
//       // _doctorHomeScreenController.getDoctorAvailabilityDisplay(_userController.user.value.id, pickedDate);
//     });
//   }
//
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     dateTime = DateTime.now();
//     duration = Duration(minutes: 10);
//     selectedItem.clear();
//     print("initialing  ==> ");
//     // displayCheckedList();
//     super.initState();
//   }
//
//   int index;
//   List<String> checked;
//   List<String> selectedItemIndex = [];
//   List<String> selectedItem = [];
//
//   // List<dynamic> postedAvailabilityItem = [];
//   RxBool _isSelectedNotifier = true.obs;
//   bool adShow = true;
//   @override
//   Widget build(BuildContext context) {
//
//
//     // filterData(DateTime.now());
//
//     return Scaffold(
//       bottomNavigationBar: tempList.isEmpty || adShow == false
//           ? SizedBox()
//           : Container(
//               height: MediaQuery.of(context).size.height * 0.1,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: GestureDetector(
//                       onTap: () async {
//                         print('data');
//                         // await launch(
//                         //     '${tempList[randomAd]['url'] ?? tempList[0]['url']}');
//
//                         await launchUrl(Uri.parse(
//                             '${tempList[randomAd]['url'] ?? tempList[0]['url']}'));
//                       },
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             '${tempList[randomAd]['image_url'] ?? tempList[0]['image_url']}',
//                         fit: BoxFit.fill,
//                         height: MediaQuery.of(context).size.height * 0.1,
//                         placeholder: (context, url) => Shimmer.fromColors(
//                           baseColor: Colors.grey.shade300,
//                           highlightColor: Colors.grey.shade100,
//                           child: Container(
//                             height: MediaQuery.of(context).size.height * 0.15,
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: IconButton(
//                       onPressed: () {
//                         adShow = false;
//                         setState(() {});
//                       },
//                       icon: CircleAvatar(
//                         maxRadius: 15,
//                         backgroundColor: Colors.grey.shade700,
//                         child: Icon(
//                           Icons.clear,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           Translate.of(context).translate('availability_time_settings'),
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).textTheme.subtitle1.color,
//             fontSize: 24,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.done,
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _body(),
//           ),
//           currentDate == null
//               ? Container()
//               : Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.all(32.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0),
//                     ),
//                     color: Colors.blue,
//                   ),
//                   child: isLoading
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 1,
//                             valueColor:
//                                 new AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : ElevatedButton(
//                           style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                             elevation: MaterialStateProperty.all(0),
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                               Colors.white,
//                             ),
//                             foregroundColor: MaterialStateProperty.all<Color>(
//                               Colors.blue,
//                             ),
//                           ),
//
//                           // padding: const EdgeInsets.symmetric(
//                           //     vertical: 8.0, horizontal: 16.0),
//
//                           onPressed: () async {
//                             // Navigator.pop(context);
//                             // print("date+++>>>$currentDate");
//                             // print("index+++>>>$index");
//                             // print("isChecked+++>>>${checked.length}");
//                             setState(() {
//                               isLoading = true;
//                             });
//                             await _doctorHomeScreenController
//                                 .getDoctorAvailability(
//                               _userController.user.value.id,
//                               currentDate,
//                               // '1','1','1','1','1','1','1','1','1','1','1','1','1','1',
//                               // '0','0','0','0','0','0','0','0','0','0','0','0','0','0',
//                               selectedItem.contains("8 - 9 AM") ? '1' : '0',
//                               selectedItem.contains("9 - 10 AM") ? '1' : '0',
//                               selectedItem.contains("10 - 11 AM") ? '1' : '0',
//                               selectedItem.contains("11 - 12 AM") ? '1' : '0',
//                               selectedItem.contains("12 - 1 PM") ? '1' : '0',
//                               selectedItem.contains("1 - 2 PM") ? '1' : '0',
//                               selectedItem.contains("2 - 3 PM") ? '1' : '0',
//                               selectedItem.contains("3 - 4 PM") ? '1' : '0',
//                               selectedItem.contains("4 - 5 PM") ? '1' : '0',
//                               selectedItem.contains("5 - 6 PM") ? '1' : '0',
//                               selectedItem.contains("6 - 7 PM") ? '1' : '0',
//                               selectedItem.contains("7 - 8 PM") ? '1' : '0',
//                               selectedItem.contains("8 - 9 PM") ? '1' : '0',
//                               selectedItem.contains("9 - 10 PM") ? '1' : '0',
//                             );
//                             setState(() {
//                               isLoading = false;
//                             });
//                             print("selected item--------->$selectedItem");
//                           },
//
//                           child: Text(
//                             "UPDATE",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18.0),
//                           ),
//                         ),
//                 ),
//         ],
//       ),
//     );
//     //
//   }
//
//   // displayCheckedList() {
//   //   postedAvailabilityItem = [];
//   //   return postedAvailabilityItem;
//   // }
//
//   // ignore: missing_return
//   Future<void> filterData(DateTime pickedDate) async {
//     await _doctorHomeScreenController.getDoctorAvailabilityDisplay(
//         _userController.user.value.id, pickedDate.toString().split(' ')[0]);
//     print('items.length:$selectedItem');
//     print(
//         'items.123:${_doctorHomeScreenController?.doctorAvailabilityForDisplayOnlyModelData?.value?.data?.postedDateAvailability}');
//     // selectedItem.clear();
//     PostedDateAvailabilityClass iterable = _doctorHomeScreenController
//         ?.doctorAvailabilityForDisplayOnlyModelData
//         ?.value
//         ?.data
//         ?.postedDateAvailability;
//     // for (DoctorAvailabilityDisplayData element in iterable) {
//     DateTime date = iterable?.availDate;
//     print('date:$date');
//     print('currentDate:$currentDate');
//     PostedDateAvailabilityClass availability = iterable;
//     if (currentDate == date) {
//       if (availability?.avail8 == "1") {
//         print('avail8:${availability?.avail8}');
//         selectedItem.add("8 - 9 AM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail9 == "1") {
//         print('avail9:${availability?.avail9}');
//         selectedItem.add("9 - 10 AM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail10 == "1") {
//         selectedItem.add("10 - 11 AM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail11 == "1") {
//         selectedItem.add("11 - 12 AM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail12 == "1") {
//         selectedItem.add("12 - 1 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail13 == "1") {
//         selectedItem.add("1 - 2 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail14 == "1") {
//         selectedItem.add("2 - 3 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail15 == "1") {
//         selectedItem.add("3 - 4 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail16 == "1") {
//         selectedItem.add("4 - 5 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail17 == "1") {
//         selectedItem.add("5 - 6 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail18 == "1") {
//         selectedItem.add("6 - 7 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail19 == "1") {
//         selectedItem.add("7 - 8 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail20 == "1") {
//         selectedItem.add("8 - 9 PM");
//         print('selectedItem:$selectedItem');
//       }
//       if (availability?.avail21 == "1") {
//         selectedItem.add("9 - 10 PM");
//         print('selectedItem:$selectedItem');
//       }
//     }
//     // }
//     setState(() {
//       // checkedList();
//       // initState();
//     });
//   }
//
//   Widget _body() {
//     return Form(
//       key: _formKey,
//       child:
//
//           //--------------------
//           //SIMPLE USAGE EXAMPLE
//           //--------------------
//
//           //BASIC CHECKBOX-GROUP
//           Container(
//         padding: const EdgeInsets.only(left: 14.0, top: 14.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                     Colors.blue,
//                   ),
//                   foregroundColor: MaterialStateProperty.all<Color>(
//                     Colors.white,
//                   ),
//                 ),
//                 onPressed: () async {
//                   // _isSelectedNotifier.value = true;
//                   _selectDate(context);
//                 },
//                 child: currentDate == null
//                     ? Text(
//                         "Tap to Select Date",
//                         //
//                       )
//                     : Text(
//                         '${DateFormat('EEEE, dd MMMM yyyy').format(currentDate)}',
//                         //
//                       ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               currentDate == null
//                   ? CenterText()
//                   : Obx(
//                       () => CheckboxGroup(
//                           checked:
//                               _isSelectedNotifier.value ? selectedItem : null,
//                           labelStyle: TextStyle(fontSize: 18),
//                           labels: <String>[
//                             "8 - 9 AM",
//                             "9 - 10 AM",
//                             "10 - 11 AM",
//                             "11 - 12 AM",
//                             "12 - 1 PM",
//                             "1 - 2 PM",
//                             "2 - 3 PM",
//                             "3 - 4 PM",
//                             "4 - 5 PM",
//                             "5 - 6 PM",
//                             "6 - 7 PM",
//                             "7 - 8 PM",
//                             "8 - 9 PM",
//                             "9 - 10 PM",
//                           ],
//                           onChange: (bool _isChecked, String label, int index) {
//                             selectedItemIndex.add("$index");
//                             _isSelectedNotifier.value = false;
//                             // selectedItemIndex.insert(0,'$index');
//                             print(
//                                 "isChecked: $_isChecked   label: $label  index: $index");
//                           },
//                           onSelected: (checked) {
//                             selectedItem = checked;
//                             print("index: ${checked.toString()}");
//                             print("selectedItem: $selectedItem");
//                           }
//
//                           // onChange: (bool isChecked, String label, int index)
//                           // {
//                           //   print("isChecked: $isChecked   label: $label  index: $index");
//                           // },
//                           // onSelected: (checked) => print("checked: ${checked.toString()}"),
//
//                           ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ignore: non_constant_identifier_names
//   CenterText() {
//     return Center(
//       child: Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.35,
//           ),
//           Text(
//             'Select Date to Show and Update Your Availability',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/pages/Availability_page/select_multiple_availability.dart';
import 'package:doctor_appointment_booking/pages/Availability_page/update_availability.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class AvailabilityPage extends StatefulWidget {
  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  static const _kTabTextStyle = TextStyle(
    color: kColorPrimaryDark,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  AdsController adsController = Get.find();
  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            Translate.of(context).translate('availability_time_settings'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
        ),
        body: DefaultTabController(
          length: 2,
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
                      text: Translate.of(context)
                          .translate('Update Availability')),
                  Tab(
                      text: Translate.of(context)
                          .translate('Update Multiple\nDay Availability')),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    UpdateAvailability(),
                    SelectMultipleAvailability(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
