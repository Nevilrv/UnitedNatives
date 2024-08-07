import 'dart:async';

import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/visited_patient_list_item.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/app_placeholder.dart';
import 'package:doctor_appointment_booking/model/visited_patient_model.dart';
import 'package:doctor_appointment_booking/pages/appointment/doctor_appointment.dart';
import 'package:doctor_appointment_booking/pages/home/nav_transition/nav_slide_from_bottom.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'widgets/widgets.dart';

class Home2Page extends StatefulWidget {
  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {
  final UserController _userController = Get.find();

  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.put(DoctorHomeScreenController());

  AdsController adsController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _doctorHomeScreenController.filterData();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _doctorHomeScreenController.getDoctorHomePage();
    _doctorHomeScreenController.filterData();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/hand.png'),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${Translate.of(context).translate('hello')} ${_userController.user.value.firstName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22),
                            ),
                            // Text(
                            //   Translate.of(context)
                            //       .translate('how_are_you_today'),
                            //   // 'how_are_you_today'.tr(),
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontSize: 18,
                            //       fontFamily: 'NunitoSans',
                            //       fontWeight: FontWeight.w400),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GetBuilder<DoctorHomeScreenController>(
                      builder: (dController) {
                    return dController.itemCount == 0 &&
                            dController.filterLoading == false
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SectionHeader2Widget(
                                  title: 'Availability',
                                ),
                                Text(
                                  "You don't have any open time slots. Click here to update your availability.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: MaterialButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.of(context)
                                          .pushNamed(Routes.availability)
                                          .then((value) => refresh());
                                    },
                                    child: Text(
                                      'UPDATE AVAILABILITY',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: kColorBlue,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox();
                  }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => Column(
                            children: <Widget>[
                              SectionHeader2Widget(
                                title: 'Next Appointment',
                              ),
                              _doctorHomeScreenController.isLoading.value
                                  ? /*Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1),
                                    )*/
                                  // Center(
                                  //     child: Utils.circular(),
                                  //   )

                                  Container(
                                      height: 205,
                                      child: AppPlaceholder(
                                        child: Center(
                                          child: Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : _doctorHomeScreenController
                                              ?.doctorHomePageModelData
                                              ?.value
                                              ?.data
                                              ?.upcomingAppointments
                                              ?.isEmpty ??
                                          true
                                      ? Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'You have nothing yet!',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  Navigator.push(
                                                          context,
                                                          NavSlideFromBottom(
                                                              page:
                                                                  MyAppointmentsDoctor()))
                                                      .then(
                                                          (value) => refresh());
                                                },
                                                child: Text(
                                                  'MY APPOINTMENTS',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                color: kColorBlue,
                                              )
                                            ],
                                          ),
                                        )
                                      : NextAppointment2Widget(),
                              SectionHeader2Widget(
                                title: Translate.of(context)
                                    .translate('Clients You have Visited'),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(Routes.mypatient)
                                    .then((value) => refresh()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => _doctorHomeScreenController.isLoading.value
                            ? /*Container(
                                height: h * 0.08,
                                child: Center(
                                    // child:
                                    //     CircularProgressIndicator(strokeWidth: 1),
                                    child: Center(
                                  child: Utils.circular(),
                                )),
                              )*/

                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 200,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Row(
                                    children: List.generate(
                                        3,
                                        (index) => AppPlaceholder(
                                              child: Center(
                                                child: Container(
                                                  width: 140,
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  height: 170,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              )
                            : _doctorHomeScreenController
                                        ?.doctorHomePageModelData
                                        ?.value
                                        ?.data
                                        ?.pastAppointments
                                        ?.isEmpty ??
                                    true
                                ? Container(
                                    height: h * 0.08,
                                    child: Center(
                                      child: Text(
                                        'You have nothing yet!',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: h * 0.2,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 15),
                                      itemCount: _doctorHomeScreenController
                                              ?.doctorHomePageModelData
                                              ?.value
                                              ?.data
                                              ?.pastAppointments
                                              ?.length ??
                                          0,
                                      scrollDirection: Axis.horizontal,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      itemBuilder: (context, index) {
                                        _doctorHomeScreenController
                                            ?.doctorHomePageModelData
                                            ?.value
                                            ?.data
                                            ?.pastAppointments
                                            ?.sort(
                                          (a, b) {
                                            String dateA =
                                                "${b.appointmentDate} ${b.appointmentTime}";
                                            String dateB =
                                                "${a.appointmentDate} ${a.appointmentTime}";
                                            return DateTime.parse(dateA)
                                                .compareTo(
                                                    DateTime.parse(dateB));
                                          },
                                        );

                                        return VisitedPatientListItem(
                                          patient: _doctorHomeScreenController
                                                  ?.doctorHomePageModelData
                                                  ?.value
                                                  ?.data
                                                  ?.pastAppointments[index] ??
                                              "",
                                        );
                                      },
                                    ),
                                  ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SectionHeader2Widget(
                              title: Translate.of(context)
                                  .translate('Clients Prescriptions'),
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(Routes.doctorprescriptionpage)
                                  .then((value) => refresh()),
                            ),
                            Obx(
                              () => _doctorHomeScreenController.isLoading.value
                                  ? /*Center(
                                      // child: CircularProgressIndicator(
                                      //   strokeWidth: 1,
                                      // ),
                                      child: Center(
                                      child: Utils.circular(),
                                    ))*/

                                  Container(
                                      height: 125,
                                      child: AppPlaceholder(
                                        child: Center(
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : _doctorHomeScreenController
                                              ?.doctorHomePageModelData
                                              ?.value
                                              ?.data
                                              ?.prescriptions
                                              ?.isNotEmpty ??
                                          false
                                      ? GestureDetector(
                                          onTap: () {
                                            VisitedPatient patientData = VisitedPatient(
                                                appointmentId:
                                                    _doctorHomeScreenController
                                                        .doctorHomePageModelData
                                                        .value
                                                        .data
                                                        ?.prescriptions
                                                        ?.first
                                                        ?.appointmentId,
                                                patientId:
                                                    _doctorHomeScreenController
                                                        .doctorHomePageModelData
                                                        .value
                                                        .data
                                                        ?.prescriptions
                                                        ?.first
                                                        ?.patientId);
                                            Navigator.of(context)
                                                .pushNamed(
                                                    Routes
                                                        .doctorprescriptionpage,
                                                    arguments: patientData)
                                                .then((value) => refresh());
                                          },
                                          child: TestAndPrescriptionCardWidget(
                                            title:
                                                '${_doctorHomeScreenController.doctorHomePageModelData.value.data?.prescriptions?.first?.medicineName ?? "Cipla X524"} ${'${_doctorHomeScreenController.doctorHomePageModelData.value.data?.prescriptions?.first?.additionalNotes ?? "Pain Killer"}'.tr()}',
                                            subTitle:
                                                '${Translate.of(context).translate('given_by')} Dr. ${_userController.user.value.firstName ?? ""} on ${DateFormat('EEEE, d MMMM yyyy').format(Utils.formattedDate("${_doctorHomeScreenController.doctorHomePageModelData?.value?.data?.prescriptions?.first?.appointmentDate} ${_doctorHomeScreenController.doctorHomePageModelData?.value?.data?.prescriptions?.first?.appointmentTime}"))}',
                                            image: 'icon_medical_recipe.png',
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            'You have nothing yet!',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                            ),

                            //test results
                            // SectionHeader2Widget(
                            //   title: 'Research & Information'.tr(),
                            //   onPressed: () =>
                            //       Navigator.of(context).pushNamed(Routes.blogpage),
                            // ),
                            // Obx(
                            //   () => _doctorHomeScreenController.isLoading.value
                            //       ? Center(
                            //           child:
                            //               CircularProgressIndicator(strokeWidth: 1))
                            //       : _doctorHomeScreenController
                            //                   ?.doctorHomePageModelData
                            //                   ?.value
                            //                   ?.data
                            //                   ?.researchDocs
                            //                   ?.isNotEmpty ??
                            //               false
                            //           ? TestAndPrescriptionCardWidget(
                            //               title:
                            //                   '${_doctorHomeScreenController?.doctorHomePageModelData?.value?.data?.researchDocs?.first?.researchTitle ?? ""} \nUpdate by ${_doctorHomeScreenController?.doctorHomePageModelData?.value?.data?.researchDocs?.first?.researchAuthor ?? ""}',
                            //               subTitle: '${DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse("${_doctorHomeScreenController.doctorHomePageModelData?.value?.data?.researchDocs?.first?.created}"))}',
                            //               image: 'icon_medical_check_up.png',
                            //             )
                            //           : Center(
                            //               child: Text('You have nothing yet!',  style: TextStyle(fontSize: 18),)),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
      );
    });
  }

  bool get wantKeepAlive => true;
}
