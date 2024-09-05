// import 'package:doctor_appointment_booking/components/custom_profile_item.dart';
// import 'package:doctor_appointment_booking/viewModel/doctor_prescription_controller.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// import 'package:doctor_appointment_booking/ResponseModel/api_state_enum.dart';
// import 'package:doctor_appointment_booking/ResponseModel/prescription.dart';
// import 'package:doctor_appointment_booking/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide Trans;
//
// class DoctorPrescriptionPage extends StatefulWidget {
//   @override
//   _DoctorPrescriptionPage createState() => _DoctorPrescriptionPage();
// }
//
// PrescriptionController _prescriptionController =
//     Get.put(PrescriptionController())..getDoctorPrescriptions();
//
// class _DoctorPrescriptionPage extends State<DoctorPrescriptionPage>
//     with AutomaticKeepAliveClientMixin<DoctorPrescriptionPage> {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       appBar: AppBar(surfaceTintColor: Colors.transparent,
//         title: Text(
//           Translate.of(context).translate('Provider Prescriptions'),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _prescriptionController.refreshGetDoctorPrescriptions,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Obx(() {
//             if (_prescriptionController.apiState.value == APIState.COMPLETE) {
//               return ListView.builder(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   itemCount: _prescriptionController.prescriptionList?.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     Prescription _prescriptionsDoctor =
//                         _prescriptionController.prescriptionList[index];
//                     return Column(
//                       children: [
//                         CustomProfileItem(
//                           onTap: () {
//                             Get.toNamed(Routes.prescriptionpage,
//                                 arguments:
//                                     _prescriptionController.prescriptionList);
//                           },
//                           title:
//                               "${_prescriptionsDoctor?.appointmentPatientFullName ?? ""}",
//                           subTitle:
//                               "${_prescriptionsDoctor?.purposeOfVisit ?? ""}",
//                           subTitle2:
//                               'Given at ${_prescriptionsDoctor?.modified ?? ""}' ??
//                                   "",
//                           buttonTitle: 'See Prescription',
//                           imagePath: 'assets/images/icon_medical_recipe.png',
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     );
//                   });
//             } else if (_prescriptionController.apiState.value ==
//                 APIState.COMPLETE_WITH_NO_DATA) {
//               return Center(
//                 child: Container(
//                   child: Text('You Don\'t have any Messages'),
//                 ),
//               );
//             } else if (_prescriptionController.apiState.value ==
//                 APIState.ERROR) {
//               return Center(child: Text("Error"));
//             } else if (_prescriptionController.apiState.value ==
//                 APIState.PROCESSING) {
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             } else {
//               return Center(
//                 child: Text(""),
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
