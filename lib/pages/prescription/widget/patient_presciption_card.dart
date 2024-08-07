import 'package:doctor_appointment_booking/components/custom_profile_item.dart';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientPrescriptionCard extends StatefulWidget {
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
                    padding: EdgeInsets.only(bottom: 15),
                    child: TextField(
                      controller:
                          _patientHomeScreenController.prescriptionController,
                      autofillHints: [AutofillHints.name],
                      onChanged: (value) {
                        _patientHomeScreenController.searchPrescription(value);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: kColorBlue, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide:
                              BorderSide(color: Colors.grey[300], width: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[250],
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                        hintText:
                            Translate.of(context).translate('search_messages'),
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
                                  .headline6
                                  .copyWith(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                _patientHomeScreenController.preData.length ??
                                    0,
                            itemBuilder: (BuildContext context, int index) {
                              var _prescription =
                                  _patientHomeScreenController.preData[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.prescriptionpage,
                                      arguments: _prescription.appointmentId);
                                },
                                child: Column(
                                  children: [
                                    CustomProfileItem(
                                      onTap: () {
                                        Get.toNamed(Routes.prescriptionpage,
                                            arguments:
                                                _prescription.appointmentId);
                                      },
                                      title: userController.user.value.userType
                                                  .toString() ==
                                              "1"
                                          ? "Doctor name : ${_prescription?.doctorName} "
                                          : "Patient name : ${_prescription?.patientFullName} ",
                                      subTitle:
                                          "Purpose of visit : ${_prescription?.purposeOfVisit}",
                                      appointmentDate:
                                          _prescription?.appointmentDate,
                                      subTitle2:
                                          'Given at ${_prescription?.modified}' ??
                                              "",
                                      buttonTitle: 'See Prescription',
                                      imagePath:
                                          '${_prescription.doctorProfilePic}',
                                    ),
                                    SizedBox(
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
            child: Container(
              child: Text(
                'You Don\'t have any Prescription',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
            APIState.ERROR) {
          return Center(
            child: Text("Error"),
          );
        } else if (_patientHomeScreenController
                .patientPrescriptionsModelData.value.apiState ==
            APIState.PROCESSING) {
          return Container(
              // child: Center(
              //   child: CircularProgressIndicator(),
              // ),
              child: Center(
            child: Utils.circular(),
          ));
        } else {
          return Center(
            child: Text(""),
          );
        }
      },
    );
  }
}
