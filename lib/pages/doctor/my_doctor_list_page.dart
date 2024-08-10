import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/my_doctor_list_item.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/pages/doctor/my_doctor_screen.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class MyDoctorListPage extends StatefulWidget {
  const MyDoctorListPage({super.key});

  @override
  State<MyDoctorListPage> createState() => _MyDoctorListPageState();
}

class _MyDoctorListPageState extends State<MyDoctorListPage> {
  static const _kTabTextStyle = TextStyle(
    color: kColorPrimaryDark,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  AdsController adsController = Get.find();

  // bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  Widget build(BuildContext context) {
    PatientHomeScreenController patientHomeScreenController = Get.find()
      ..getVisitedDoctors();
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            Translate.of(context)!.translate('My Providers'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
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
                        ?.translate('United Natives Providers'),
                  ),
                  Tab(
                    text: Translate.of(context)?.translate('Other Providers'),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(
                      () {
                        if (patientHomeScreenController
                                .visitedDoctorUpcomingPastData.value.apiState ==
                            APIState.COMPLETE) {
                          return Obx(
                            () => (patientHomeScreenController
                                        .visitedDoctorUpcomingPastData
                                        .value
                                        .past
                                        ?.isEmpty ??
                                    true)
                                ? Center(
                                    child: Text(
                                      "No data!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: patientHomeScreenController
                                        .getVisitedDoctors,
                                    child: Builder(builder: (context) {
                                      List<Appointment> data = [];

                                      Set doctorId = {};
                                      patientHomeScreenController
                                          .visitedDoctorUpcomingPastData
                                          .value
                                          .past
                                          ?.forEach((element) {
                                        doctorId.add(element.doctorId);
                                      });
                                      doctorId.toList().forEach((element1) {
                                        final tempData =
                                            patientHomeScreenController
                                                .visitedDoctorUpcomingPastData
                                                .value
                                                .past
                                                ?.where((element) =>
                                                    element.doctorId ==
                                                    element1)
                                                .toList();
                                        data.add(tempData!.first);
                                      });

                                      return ListView.separated(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 15,
                                        ),
                                        itemCount: data.length,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 25),
                                        itemBuilder: (context, index) {
                                          return MyDoctorListItem(
                                            doctor: data[index],
                                          );
                                        },
                                      );
                                    }),
                                  ),
                          );
                        } else if (patientHomeScreenController
                                .visitedDoctorUpcomingPastData.value.apiState ==
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
                        } else if (patientHomeScreenController
                                .visitedDoctorUpcomingPastData.value.apiState ==
                            APIState.ERROR) {
                          return const Center(child: Text("Error"));
                        } else if (patientHomeScreenController
                                .visitedDoctorUpcomingPastData.value.apiState ==
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
                    ),
                    const MyDoctorScreen(),
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
