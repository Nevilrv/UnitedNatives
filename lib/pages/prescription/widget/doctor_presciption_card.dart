import 'package:united_natives/components/custom_profile_item.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/ResponseModel/visited_patient_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorPrescriptionCard extends StatefulWidget {
  final VisitedPatient? patientData;

  const DoctorPrescriptionCard({super.key, this.patientData});
  @override
  State<DoctorPrescriptionCard> createState() => _DoctorPrescriptionCardState();
}

class _DoctorPrescriptionCardState extends State<DoctorPrescriptionCard> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  @override
  void initState() {
    _doctorHomeScreenController.getDoctorPrescriptions(
        patientId: widget.patientData?.patientId ?? '',
        appointmentId: widget.patientData?.appointmentId ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _doctorHomeScreenController.prescriptionController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorHomeScreenController>(
      builder: (controller) {
        if (controller.doctorPrescriptionsModelData.apiState ==
            APIState.COMPLETE) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: controller.prescriptionController,
                  autofillHints: const [AutofillHints.name],
                  onChanged: (value) {
                    controller.searchPrescription(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: kColorBlue, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Colors.grey[300]!, width: 0.5),
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 30,
                    ),
                    hintText:
                        Translate.of(context)?.translate('search_messages'),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
                  ),
                  cursorWidth: 1,
                  maxLines: 1,
                ),
              ),
              controller.doctorPrescription.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'You Don\'t have any Prescription',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.doctorPrescription.length,
                        itemBuilder: (BuildContext context, int index) {
                          var prescriptionsDoctor =
                              controller.doctorPrescription[index];
                          DateTime appointmentDate = Utils.formattedDate(
                              '${DateTime.parse('${prescriptionsDoctor.appointmentDate} ${prescriptionsDoctor.appointmentTime}')}');
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.prescriptionpage,
                                  arguments: prescriptionsDoctor.appointmentId);
                            },
                            child: Column(
                              children: [
                                CustomProfileItem(
                                  onTap: () {
                                    Get.toNamed(Routes.prescriptionpage,
                                        arguments:
                                            prescriptionsDoctor.appointmentId);
                                  },
                                  title:
                                      "Patient name : ${prescriptionsDoctor.patientFirstName}",
                                  subTitle:
                                      "Purpose of visit : ${prescriptionsDoctor.purposeOfVisit}",
                                  subTitle2:
                                      'Give ${prescriptionsDoctor.modified}',
                                  appointmentDate:
                                      DateFormat('EE, d MMM, yyyy, hh:mm a')
                                          .format(appointmentDate),
                                  buttonTitle: 'See Prescription',
                                  imagePath:
                                      '${prescriptionsDoctor.pationtImage}',
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        } else if (controller.doctorPrescriptionsModelData.apiState ==
            APIState.COMPLETE_WITH_NO_DATA) {
          return Center(
            child: Text(
              'You Don\'t have any Prescription',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        } else if (controller.doctorPrescriptionsModelData.apiState ==
            APIState.ERROR) {
          return const Center(
            child: Text("Error"),
          );
        } else if (controller.doctorPrescriptionsModelData.apiState ==
            APIState.PROCESSING) {
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
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
      },
    );
  }
}
