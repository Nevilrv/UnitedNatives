import 'package:united_natives/components/custom_profile_item.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionPage extends StatefulWidget {
  final String? appointmentId;

  const PrescriptionPage({super.key, this.appointmentId});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () => _patientHomeScreenController.patientHomePageData.value.data
                      ?.prescriptions?.isNotEmpty ??
                  true
              ? Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _patientHomeScreenController.patientHomePageData
                            .value.data?.prescriptions?.length ??
                        0,
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        Column(
                          children: [
                            CustomProfileItem(
                              onTap: () {
                                Get.toNamed(Routes.prescriptionDetail,
                                    arguments: _patientHomeScreenController
                                        .patientHomePageData
                                        .value
                                        .data
                                        ?.prescriptions);
                              },
                              title:
                                  "${_patientHomeScreenController.patientHomePageData.value.data!.prescriptions?[index].patientFullName}",
                              subTitle:
                                  "${_patientHomeScreenController.patientHomePageData.value.data!.prescriptions?[index].purposeOfVisit}",
                              subTitle2:
                                  'Given at ${_patientHomeScreenController.patientHomePageData.value.data!.prescriptions?[index].modified}',
                              buttonTitle: 'See Prescription',
                              imagePath:
                                  'assets/images/icon_medical_recipe.png',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  'Nothing to Show!',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
