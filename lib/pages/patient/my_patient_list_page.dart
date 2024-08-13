import 'dart:async';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/my_patient_list_item.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class MyPatientListPage extends StatefulWidget {
  const MyPatientListPage({super.key});

  @override
  State<MyPatientListPage> createState() => _MyPatientListPageState();
}

class _MyPatientListPageState extends State<MyPatientListPage> {
  final DoctorHomeScreenController doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();
  @override
  void initState() {
    doctorHomeScreenController.getPatientDetails();
    super.initState();
  }

  Timer? _debounce;
  TextEditingController searchController = TextEditingController();

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
            title: Text(
              Translate.of(context)!.translate('My Client list'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          body: GetBuilder<DoctorHomeScreenController>(
            builder: (controller) {
              if (controller.patientDetailsResponseModel.apiState ==
                  APIState.COMPLETE) {
                int? indexFind = controller
                    .patientDetailsResponseModel.patientData
                    ?.indexWhere((element) =>
                        ('${element.patientFirstName}${element.patientLastName}')
                            .toLowerCase()
                            .contains(searchController.text
                                .toLowerCase()
                                .replaceAll(" ", "")));

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 8),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  Translate.of(context)?.translate('search'),
                            ),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(const Duration(milliseconds: 100), () {
                                setState(() {});
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    if (indexFind! < 0)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No Patient Data',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (indexFind >= 0)
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            if (!('${controller.patientDetailsResponseModel.patientData?[index].patientFirstName} ${controller.patientDetailsResponseModel.patientData?[index].patientLastName}')
                                .toLowerCase()
                                .contains(
                                  searchController.text
                                      .toLowerCase()
                                      .replaceAll(" ", ""),
                                )) {
                              return const SizedBox();
                            }

                            return const SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: controller.patientDetailsResponseModel
                                  .patientData?.length ??
                              0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          itemBuilder: (context, index) {
                            if (!('${controller.patientDetailsResponseModel.patientData?[index].patientFirstName} ${controller.patientDetailsResponseModel.patientData?[index].patientLastName}')
                                .toLowerCase()
                                .contains(searchController.text
                                    .toLowerCase()
                                    .replaceAll(" ", ""))) {
                              return const SizedBox();
                            }

                            return MyPatientListItem(
                              patient: controller.patientDetailsResponseModel
                                  .patientData?[index],
                            );
                          },
                        ),
                      ),
                  ],
                );
              } else if (controller.patientDetailsResponseModel.apiState ==
                  APIState.COMPLETE_WITH_NO_DATA) {
                return Center(
                  child: Text(
                    "No data!",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (controller.patientDetailsResponseModel.apiState ==
                  APIState.ERROR) {
                return const Center(
                  child: Text("Error"),
                );
              } else if (controller.patientDetailsResponseModel.apiState ==
                  APIState.PROCESSING) {
                // return Center(
                //   child: CircularProgressIndicator(),
                // );
                return Center(
                  child: Utils.circular(),
                );
              } else {
                return const Center(
                  child: Text(""),
                );
              }
            },
          )
          // body: ListView.separated(
          //   separatorBuilder: (context, index) => SizedBox(
          //     height: 15,
          //   ),
          //   itemCount: _doctorHomeScreenController?.doctorHomePageModelData?.value
          //           ?.data?.pastAppointments?.length ??
          //       0,
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          //   itemBuilder: (context, index) {
          //     return MyPatientListItem(
          //       patient: _doctorHomeScreenController
          //           .doctorHomePageModelData.value.data.pastAppointments[index],
          //     );
          //   },
          // ),
          );
    });
  }
}
