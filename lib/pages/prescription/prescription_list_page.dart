import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/doctor_prescription_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/utils/utils.dart';
import '../../components/custom_recipe_item.dart';

class PrescriptionPage extends StatefulWidget {
  final String? appointmentId;

  const PrescriptionPage({super.key, this.appointmentId});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final PrescriptionController _prescriptionController =
      Get.put(PrescriptionController());

  @override
  initState() {
    _prescriptionController.getAppointmentPrescriptions(
        appointmentId: widget.appointmentId.toString());

    super.initState();
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          actions: const <Widget>[],
          title: Text(
            Translate.of(context)!.translate('prescription_detail'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Obx(() {
            if (_prescriptionController.appointmentApiState.value ==
                APIState.COMPLETE) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount:
                    _prescriptionController.appointmentPrescriptionList.length,
                itemBuilder: (BuildContext context, int index) {
                  var prescriptionsDoctor = _prescriptionController
                      .appointmentPrescriptionList[index];

                  return Column(
                    children: [
                      Column(
                        children: [
                          CustomRecipeItem(
                            purpose: prescriptionsDoctor.purposeOfVisit ?? "",
                            title: prescriptionsDoctor.medicineName ?? "",
                            subTitle: prescriptionsDoctor.additionalNotes ?? "",
                            days:
                                '${prescriptionsDoctor.treatmentDays ?? ""} ${Translate.of(context)?.translate('days')}',
                            pills:
                                '${prescriptionsDoctor.pillsPerDay ?? ""} ${Translate.of(context)?.translate('pills')}',
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else if (_prescriptionController.appointmentApiState.value ==
                APIState.COMPLETE_WITH_NO_DATA) {
              return Center(
                child: Text(
                  'Nothing to Show!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (_prescriptionController.appointmentApiState.value ==
                APIState.ERROR) {
              return const Center(child: Text("Error"));
            } else if (_prescriptionController.appointmentApiState.value ==
                APIState.PROCESSING) {
              return Center(
                child: Utils.circular(),
              );
            } else {
              return const Center(
                child: Text(
                  "No Data to show !",
                  style: TextStyle(fontSize: 21),
                ),
              );
            }
          }),
          // child: Obx(
          //   () => _doctorHomeScreenController.doctorHomePageModelData.value?.data
          //               ?.prescriptions?.isNotEmpty ??
          //           false
          //       ? Obx(
          //           () => ListView.builder(
          //             itemCount: _doctorHomeScreenController
          //                     .doctorHomePageModelData
          //                     .value
          //                     ?.data
          //                     ?.prescriptions
          //                     ?.length ??
          //                 0,
          //             scrollDirection: Axis.vertical,
          //             shrinkWrap: true,
          //             itemBuilder: (BuildContext context, int index) {
          //               Prescription _prescriptionsDoctor =
          //                   _doctorHomeScreenController.doctorHomePageModelData
          //                       .value?.data?.prescriptions[index];
          //               return Column(
          //                 children: [
          //                   CustomRecipeItem(
          //                     title: "${_prescriptionsDoctor.medicineName ?? ""}",
          //                     subTitle:
          //                         "${_prescriptionsDoctor.additionalNotes ?? ""}",
          //                     days:
          //                         '${_prescriptionsDoctor.treatmentDays ?? ""} ${'days'.tr()}',
          //                     pills:
          //                         '${_prescriptionsDoctor.pillsPerDay ?? ""} ${'pills'.tr()}',
          //                   ),
          //                   SizedBox(
          //                     height: 20,
          //                   ),
          //                 ],
          //               );
          //             },
          //           ),
          //         )
          //       : Center(
          //           child: Text('Nothing to Show!'),
          //         ),
          // ),
        ),
      );
    });
  }
}
