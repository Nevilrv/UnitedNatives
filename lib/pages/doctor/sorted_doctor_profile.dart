// import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// import 'package:doctor_appointment_booking/model/getSorted_patient_chatList_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart' hide Trans;
// import 'package:url_launcher/url_launcher.dart';
// import '../../components/round_icon_button.dart';
// import '../../routes/routes.dart';
// import '../../utils/constants.dart';
//
// class SortedDoctorProfilePage extends StatelessWidget {
//   final SortedPatientChat sortedPatientChat;
//
//   SortedDoctorProfilePage({Key key, this.sortedPatientChat}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     void _launchCaller(String number) async {
//       var url = "tel:${number.toString()}";
//       if (await canLaunchUrl(Uri.parse(url))) {
//         // await launch(url);
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not place call';
//       }
//     }
//
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 280,
//               floating: false,
//               pinned: true,
//               //backgroundColor: Colors.white,
//               elevation: 1,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Image.network(
//                   "${sortedPatientChat?.doctorProfilePic}" ?? "",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ];
//         },
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           // Text(
//                           //   'available_now'.tr().toUpperCase(),
//                           //   style: TextStyle(
//                           //     color: Color(0xff40E58C),
//                           //     fontSize: 8,
//                           //     fontWeight: FontWeight.w700,
//                           //   ),
//                           // ),
//                           Text(
//                             '${sortedPatientChat?.doctorFirstName}'
//                                     ' '
//                                     '${sortedPatientChat?.doctorLastName}' ??
//                                 'Name not Found',
//                             style:
//                                 Theme.of(context).textTheme.subtitle1.copyWith(
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                           ),
//                           Text(
//                             "",
//                             // "${sortedPatientChat?.education}",
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     RatingBar.builder(
//                       itemSize: 20,
//                       initialRating: 0,
//                       // doctor?.rating?.toDouble() ?? 0,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       ignoreGestures: true,
//                       itemBuilder: (context, _) => Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                       ),
//                       onRatingUpdate: (rating) {
//                         print(rating);
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 1,
//                   color: Colors.grey[350],
//                 ),
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 // Text(
//                 //   'about'.tr(),
//                 //   style: Theme.of(context).textTheme.headline6.copyWith(
//                 //         fontWeight: FontWeight.w700,
//                 //       ),
//                 // ),
//                 // SizedBox(
//                 //   height: 20,
//                 // ),
//                 // Text(
//                 //   'Doctor Tawfiq Bahri, is a Doctor primarily located in New York, with another office in Atlantic City, New Jersey. He has 16 years of experience. His specialities include Family Medicine and Cardiology.',
//                 //   style: TextStyle(
//                 //     color: Colors.grey,
//                 //     fontSize: 14,
//                 //     fontWeight: FontWeight.w500,
//                 //   ),
//                 // ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: <Widget>[
//                     RoundIconButton(
//                       onPressed: () {
//                         Navigator.of(context)
//                             .popAndPushNamed(Routes.chatDetail);
//                       },
//                       icon: Icons.message,
//                       elevation: 1,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     RoundIconButton(
//                       onPressed: () {
//                         // _launchCaller(sortedPatientChat?.contactNumber);
//                       },
//                       icon: Icons.phone,
//                       elevation: 1,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: RawMaterialButton(
//                         onPressed: () {
//                           Get.toNamed(Routes.bookingStep1);
//                         },
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         fillColor: kColorBlue,
//                         child: Container(
//                           height: 48,
//                           child: Center(
//                             child: Text(
//                               Translate.of(context)
//                                   .translate('book_an_appointment')
//                                   .toUpperCase(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
