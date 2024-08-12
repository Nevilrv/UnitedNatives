import 'package:united_natives/components/custom_profile_item.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientPrescriptionCard extends StatefulWidget {
  const PatientPrescriptionCard({super.key});

  @override
  State<PatientPrescriptionCard> createState() =>
      _PatientPrescriptionCardState();
}

class _PatientPrescriptionCardState extends State<PatientPrescriptionCard> {
  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getPatientPrescriptions();

  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
            APIState.COMPLETE) {
          return Obx(
            () => RefreshIndicator(
              onRefresh: _patientHomeScreenController.getPatientPrescriptions,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      controller:
                          _patientHomeScreenController.prescriptionController,
                      autofillHints: const [AutofillHints.name],
                      onChanged: (value) {
                        _patientHomeScreenController.searchPrescription(value);
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
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 22),
                      ),
                      cursorWidth: 1,
                      maxLines: 1,
                    ),
                  ),
                  _patientHomeScreenController.preData.isEmpty
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
                            itemCount:
                                _patientHomeScreenController.preData.length,
                            itemBuilder: (BuildContext context, int index) {
                              var prescription =
                                  _patientHomeScreenController.preData[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.prescriptionpage,
                                      arguments: prescription.appointmentId);
                                },
                                child: Column(
                                  children: [
                                    CustomProfileItem(
                                      onTap: () {
                                        Get.toNamed(Routes.prescriptionpage,
                                            arguments:
                                                prescription.appointmentId);
                                      },
                                      title: userController.user.value.userType
                                                  .toString() ==
                                              "1"
                                          ? "Doctor name : ${prescription.doctorName} "
                                          : "Patient name : ${prescription.patientFullName} ",
                                      subTitle:
                                          "Purpose of visit : ${prescription.purposeOfVisit}",
                                      appointmentDate:
                                          prescription.appointmentDate!,
                                      subTitle2:
                                          'Given at ${prescription.modified}',
                                      buttonTitle: 'See Prescription',
                                      imagePath:
                                          '${prescription.doctorProfilePic}',
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        } else if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
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
        } else if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
            APIState.ERROR) {
          return const Center(
            child: Text("Error"),
          );
        } else if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
            APIState.PROCESSING) {
          return Center(
            child: Utils.circular(),
          );
        } else {
          return const Center(
            child: Text(""),
          );
        }
      },
    );
  }
}
