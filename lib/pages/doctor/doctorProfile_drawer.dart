import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/set_rating_for_the_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_notes_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/FirstMessagePage.dart';
import 'package:united_natives/pages/booking/step3/time_slot_drawer.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_notes_view_model.dart';
import 'package:united_natives/viewModel/set_rating_for_the_doctor_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/round_icon_button.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DoctorProfilePage2 extends StatefulWidget {
  final Appointment? doctor;

  const DoctorProfilePage2({super.key, this.doctor});

  @override
  State<DoctorProfilePage2> createState() => _DoctorProfilePage2State();
}

class _DoctorProfilePage2State extends State<DoctorProfilePage2> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final BookAppointmentController _bookAppointmentController =
      Get.find<BookAppointmentController>();
  TextEditingController text = TextEditingController();
  var info;
  GetAllNotesModel? getData;
  final UserController userController = Get.find();
  PatientHomeScreenController patientHomeScreenController = Get.find();
  var chatListItem;
  bool isAvailable = true;
  GetSortedPatientChatListModel getSortedPatientChatListModel =
      GetSortedPatientChatListModel();
  AddNotesController addNotesController = Get.put(AddNotesController());
  final UserController _userController = Get.find<UserController>();

  Appointment appointment = Appointment();

  String? docId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      assignData();
      data();
    });
    super.initState();
  }

  assignData() {
    appointment = widget.doctor!;
    docId = widget.doctor?.doctorId ?? "";
    setState(() {});
  }

  setNewData() async {
    await patientHomeScreenController.getVisitedDoctors().then((value) {
      if (patientHomeScreenController
              .visitedDoctorUpcomingPastData.value.apiState ==
          APIState.COMPLETE) {
        List<Appointment> data = [];

        Set doctorId = {};
        patientHomeScreenController.visitedDoctorUpcomingPastData.value.past
            ?.forEach((element) {
          doctorId.add(element.doctorId);
        });
        doctorId.toList().forEach((element1) {
          final tempData = patientHomeScreenController
              .visitedDoctorUpcomingPastData.value.past
              ?.where((element) => element.doctorId == element1)
              .toList();
          data.add(tempData!.first);
        });

        for (var element in data) {
          if (element.doctorId == docId) {
            appointment = element;
          }
        }
        setState(() {});
      }
    });
  }

  Future<void> data() async {
    await patientHomeScreenController.getSortedPatientChatList();
    patientHomeScreenController.newDataList =
        patientHomeScreenController.getSortedPatientChatListModel.value.data!;
    for (var i = 0; i < patientHomeScreenController.newDataList.length; i++) {
      if (patientHomeScreenController.newDataList[i].doctorId ==
          appointment.doctorId) {
        if (patientHomeScreenController.newDataList[i].chatKey != null &&
            patientHomeScreenController.newDataList[i].chatKey!.isNotEmpty &&
            patientHomeScreenController.newDataList[i].chatKey != "") {
          chatListItem = patientHomeScreenController.newDataList[i];
          setState(() {
            isAvailable = false;
          });
          break;
        }
      } else {}
    }
    await addNotesController.addNotesControllers(
        dId: appointment.doctorId, pId: '${userController.user.value.id}');
  }

  SetRatingForTheDoctorViewModel setRatingForTheDoctorViewModel =
      Get.put(SetRatingForTheDoctorViewModel());

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    void launchCaller(String number) async {
      var url = "tel:${number.toString()}";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not place call';
      }
    }

    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(ads: ads, context: context),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 300,
                  floating: false,
                  pinned: true,
                  elevation: 1,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Utils().patientProfile(
                          appointment.doctorProfilePic ?? '',
                          appointment.doctorSocialProfilePic ?? '',
                          130,
                          fit: BoxFit.contain),
                    ),
                  ).paddingOnly(top: 25),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${appointment.doctorFirstName}'
                                ' '
                                '${appointment.doctorLastName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                              ),
                              Text(
                                "${appointment.doctorSpeciality}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => showRatingDialog(context),
                          child: RatingBar.builder(
                            itemSize: 20,
                            initialRating:
                                appointment.doctorRating?.toDouble() ?? 0,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[350],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        RoundIconButton(
                          onPressed: () async {
                            if (isAvailable == true) {
                              Get.to(FirstMessagePage(
                                patientId: _userController.user.value.id,
                                docId: appointment.doctorId,
                                docFName: appointment.doctorFirstName,
                                docLName: appointment.doctorLastName,
                                docImage: appointment.doctorProfilePic,
                                docSocialImage:
                                    appointment.doctorSocialProfilePic,
                              ));

                              setState(() {
                                isAvailable = true;
                              });
                            } else {
                              patientHomeScreenController.onTapDoctorDetail(
                                  context, chatListItem, appointment);
                            }
                          },
                          icon: Icons.message,
                          elevation: 1,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        RoundIconButton(
                          onPressed: () {
                            launchCaller(appointment.doctorMobileNumber!);
                          },
                          icon: Icons.phone,
                          elevation: 1,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () async {
                              if (appointment == null) {
                                Get.toNamed(Routes.bookingStep2,
                                    arguments: _bookAppointmentController
                                        .specialitiesModelData
                                        .value
                                        .specialities?[0]
                                        .id);
                              } else {
                                _bookAppointmentController
                                  ..selectedIndex.value = (-1)
                                  ..items = <Map<String, dynamic>>[].obs
                                  ..getPatientAppointment(
                                      appointment.doctorId!, context);

                                await _bookAppointmentController
                                    .getDoctorSpecialities(
                                        appointment.doctorSpecialityID!,
                                        context);
                                DoctorSpecialities? doctorSpecialities;
                                _bookAppointmentController
                                    .doctorBySpecialitiesModelData
                                    .value
                                    .doctorSpecialities
                                    ?.forEach((element) {
                                  if (element.userId == appointment.doctorId) {
                                    doctorSpecialities = element;
                                  }
                                });

                                Get.to(TimeSlotPage2(
                                  doctorSpecialities: doctorSpecialities,
                                  doctorDetails: appointment,
                                ));
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            fillColor: kColorBlue,
                            child: SizedBox(
                              height: 48,
                              child: Center(
                                child: Text(
                                  Translate.of(context)!
                                      .translate('book_an_appointment')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: Get.width * 0.38,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.addIHNotes,
                                  arguments: appointment.doctorId)
                              .then((value) {
                            if (value == true) {
                              data();
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 48,
                              child: Center(
                                child: Text(
                                  'ADD NOTES',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GetBuilder<AddNotesController>(
                      builder: (controller) {
                        if (controller.apiResponse.status == Status.LOADING) {
                          return SizedBox(
                            height: Get.height * 0.35,
                            child: Center(
                              child: Utils.circular(),
                            ),
                          );
                        } else if (controller.apiResponse.status ==
                            Status.COMPLETE) {
                          GetAllNotesModel data = controller.apiResponse.data;

                          return SizedBox(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: data.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                data.data?.sort((a, b) =>
                                    (b.created)!.compareTo(a.created!));
                                return /*Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 15)
                                            .copyWith(top: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Date',
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${DateFormat('yyyy-MM-dd').format(DateTime.parse('${data.data[index].created}'))}',
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Time',
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${DateFormat('hh:mm a').format(DateTime.parse('${data.data[index].created}'))}',
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Text(
                                                'Note :  ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${data.data[index].notes}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )*/

                                    Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Date :  ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(
                                                        '${data.data?[index].created}')),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ).paddingSymmetric(vertical: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Note :  ',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${data.data?[index].notes}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showRatingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        if (appointment.ratingByPatient != 0) {
          return Center(
            child: IntrinsicHeight(
              child: Container(
                // height: Get.height * 0.35,
                width: Get.width > 550 ? Get.width * 0.5 : Get.width * 0.75,
                decoration: BoxDecoration(
                  color: _isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.22,
                          height: Get.width * 0.22,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Utils().patientProfile(
                              appointment.doctorProfilePic ?? '',
                              appointment.doctorSocialProfilePic ?? '',
                              100,
                              fit: BoxFit.contain),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Text(
                          '${appointment.doctorFirstName?.capitalizeFirst} ${appointment.doctorLastName?.capitalizeFirst}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.w400,
                            color: _isDark ? Colors.white : Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.015),
                        Text(
                          'Your rating',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Merriweather',
                            color: _isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.015),
                        RatingBarIndicator(
                          rating: appointment.ratingByPatient ?? 0.0,
                          itemCount: 5,
                          itemSize: Get.height * 0.05,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                          unratedColor: Colors.blue.withOpacity(0.3),
                          direction: Axis.horizontal,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 0.25),
                        ),
                        SizedBox(height: Get.height * 0.045),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return RatingDialog(
          initialRating: 0,
          image: Container(
            width: Get.width * 0.5,
            height: Get.width * 0.25,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: SizedBox(
                width: Get.width * 0.25,
                height: Get.width * 0.25,
                child: Center(
                  child: Utils().patientProfile(
                      appointment.doctorProfilePic ?? '',
                      appointment.doctorSocialProfilePic ?? '',
                      100,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          title: Text(
            '${appointment.doctorFirstName?.capitalizeFirst} ${appointment.doctorLastName?.capitalizeFirst}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          message: const Text(
            'Tap a star to set your rating',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          enableComment: false,
          submitButtonText: 'Submit',
          onCancelled: () => log('cancelled'),
          starColor: Colors.blue,
          onSubmitted: (response) async {
            String rate = response.rating.toString();
            var rate1 = rate.split('.');
            SetRatingForTheDoctorRequestModel requestModel =
                SetRatingForTheDoctorRequestModel(
              patientId: '${userController.user.value.id}',
              doctorId: appointment.doctorId,
              rating: rate1.first,
              review: '',
            );
            await setRatingForTheDoctorViewModel.setRatingForTheDoctorViewModel(
                requestModel: requestModel);
            if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.COMPLETE) {
            } else if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.LOADING) {
            } else if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.ERROR) {}

            await setNewData();
          },
        );
      },
    );
  }
}

/*import 'dart:async';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/set_rating_for_the_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_notes_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/FirstMessagePage.dart';
import 'package:united_natives/pages/booking/step3/time_slot_drawer.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_notes_view_model.dart';
import 'package:united_natives/viewModel/set_rating_for_the_doctor_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/round_icon_button.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DoctorProfilePage2 extends StatefulWidget {
  final Appointment doctor;

  DoctorProfilePage2({Key key, this.doctor}) : super(key: key);

  @override
  State<DoctorProfilePage2> createState() => _DoctorProfilePage2State();
}

class _DoctorProfilePage2State extends State<DoctorProfilePage2> {
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final BookAppointmentController _bookAppointmentController =
      Get.find<BookAppointmentController>();
  TextEditingController text = TextEditingController();
  var info;
  GetAllNotesModel getData;
  final UserController userController = Get.find();
  PatientHomeScreenController patientHomeScreenController = Get.find();
  var chatListItem;
  bool isAvailable = true;
  GetSortedPatientChatListModel getSortedPatientChatListModel =
      GetSortedPatientChatListModel();
  AddNotesController addNotesController = Get.put(AddNotesController());
  final UserController _userController = Get.find<UserController>();

  Appointment appointment = Appointment();

  String docId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      assignData();
      data();
    });
    super.initState();
  }

  assignData() {
    appointment = widget.doctor;
    docId = widget.doctor.doctorId ?? "";
    setState(() {});
  }

  setNewData() async {
    await patientHomeScreenController.getVisitedDoctors().then((value) {
      if (patientHomeScreenController
              .visitedDoctorUpcomingPastData.value.apiState ==
          APIState.COMPLETE) {
        List<Appointment> data = [];

        Set doctorId = {};
        patientHomeScreenController.visitedDoctorUpcomingPastData?.value?.past
            ?.forEach((element) {
          doctorId.add(element.doctorId);
        });
        doctorId.toList().forEach((element1) {
          final tempData = patientHomeScreenController
              .visitedDoctorUpcomingPastData?.value?.past
              ?.where((element) => element.doctorId == element1)
              ?.toList();
          data.add(tempData.first);
        });

        data.forEach((element) {
          if (element.doctorId == docId) {
            appointment = element;
          }
        });
        setState(() {});
      }
    });
  }

  Future<void> data() async {
    await patientHomeScreenController.getSortedPatientChatList();
    patientHomeScreenController.newDataList =
        patientHomeScreenController.getSortedPatientChatListModel.value.data;
    for (var i = 0; i < patientHomeScreenController.newDataList.length; i++) {
      if (patientHomeScreenController.newDataList[i].doctorId ==
          appointment.doctorId) {
        if (patientHomeScreenController.newDataList[i].chatKey != null &&
            patientHomeScreenController.newDataList[i].chatKey.isNotEmpty &&
            patientHomeScreenController.newDataList[i].chatKey != "") {
          chatListItem = patientHomeScreenController.newDataList[i];
          setState(() {
            isAvailable = false;
          });
          break;
        }
      } else {
        print('no......');
      }
    }
    await addNotesController.addNotesControllers(
        dId: appointment.doctorId, pId: '${userController.user.value.id}');
  }

  SetRatingForTheDoctorViewModel setRatingForTheDoctorViewModel =
      Get.put(SetRatingForTheDoctorViewModel());

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    void _launchCaller(String number) async {
      var url = "tel:${number.toString()}";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not place call';
      }
    }

    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 280,
                    floating: false,
                    pinned: true,
                    elevation: 1,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Utils().patientProfile(
                          appointment?.doctorProfilePic ?? '',
                          appointment?.doctorSocialProfilePic ?? '',
                          40,
                          fit: BoxFit.contain),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${appointment?.doctorFirstName}'
                                          ' '
                                          '${appointment?.doctorLastName}' ??
                                      'Name not Found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                ),
                                Text(
                                  "${appointment?.doctorSpeciality}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              return showRatingDialog(context);
                            },
                            child: RatingBar.builder(
                              itemSize: 20,
                              initialRating:
                                  appointment?.doctorRating?.toDouble() ?? 0,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[350],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          RoundIconButton(
                            onPressed: () async {
                              print('isAvailable  $isAvailable');
                              if (isAvailable == true) {
                                Get.to(FirstMessagePage(
                                  patientId: _userController.user.value.id,
                                  docId: appointment.doctorId,
                                  docFName: appointment.doctorFirstName,
                                  docLName: appointment.doctorLastName,
                                  docImage: appointment.doctorProfilePic,
                                  docSocialImage:
                                      appointment.doctorSocialProfilePic,
                                ));

                                setState(() {
                                  isAvailable = true;
                                });
                              } else {
                                patientHomeScreenController.onTapDoctorDetail(
                                    context, chatListItem, appointment);
                              }
                            },
                            icon: Icons.message,
                            elevation: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RoundIconButton(
                            onPressed: () {
                              _launchCaller(appointment.doctorMobileNumber);
                            },
                            icon: Icons.phone,
                            elevation: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RawMaterialButton(
                              onPressed: () async {
                                if (appointment == null) {
                                  Get.toNamed(Routes.bookingStep2,
                                      arguments: _bookAppointmentController
                                          .specialitiesModelData
                                          .value
                                          .specialities[0]
                                          .id);
                                } else {
                                  _bookAppointmentController
                                    ..selectedIndex.value = (-1)
                                    ..items = <Map<String, dynamic>>[].obs
                                    ..getPatientAppointment(
                                        appointment.doctorId, context);

                                  await _bookAppointmentController
                                      .getDoctorSpecialities(
                                          appointment.doctorSpecialityID,
                                          context);
                                  DoctorSpecialities doctorSpecialities;
                                  _bookAppointmentController
                                      .doctorBySpecialitiesModelData
                                      .value
                                      .doctorSpecialities
                                      .forEach((element) {
                                    print(
                                        'element.userId===>${element.userId}');
                                    if (element.userId ==
                                        appointment.doctorId) {
                                      doctorSpecialities = element;
                                    }
                                  });

                                  Get.to(TimeSlotPage2(
                                    doctorSpecialities: doctorSpecialities,
                                    doctorDetails: appointment,
                                  ));
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              fillColor: kColorBlue,
                              child: Container(
                                height: 48,
                                child: Center(
                                  child: Text(
                                    Translate.of(context)
                                        .translate('book_an_appointment')
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Get.width * 0.38,
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.addIHNotes,
                                    arguments: appointment.doctorId)
                                .then((value) {
                              if (value == true) {
                                data();
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          fillColor: kColorBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 48,
                                child: Center(
                                  child: Text(
                                    'ADD NOTES',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GetBuilder<AddNotesController>(
                        builder: (controller) {
                          if (controller.apiResponse.status == Status.LOADING) {
                            return SizedBox(
                              height: Get.height * 0.35,
                              child: Center(
                                child: Utils.circular(),
                              ),
                            );
                          } else if (controller.apiResponse.status ==
                              Status.COMPLETE) {
                            GetAllNotesModel data = controller.apiResponse.data;

                            return SizedBox(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: data.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  data.data.sort((a, b) =>
                                      (b.created).compareTo(a.created));
                                  return Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  horizontal: 15)
                                              .copyWith(top: 15),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Date',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '${DateFormat('yyyy-MM-dd').format(DateTime.parse('${data.data[index].created}'))}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Time',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '${DateFormat('hh:mm a').format(DateTime.parse('${data.data[index].created}'))}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 50,
                                                child: Text(
                                                  'Note :  ',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${data.data[index].notes}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showRatingDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        if (appointment?.ratingByPatient != 0) {
          return Center(
            child: Container(
              height: Get.height * 0.3,
              width: Get.height * 0.3,
              decoration: BoxDecoration(
                color: _isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Container(
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Utils().patientProfile(
                        appointment?.doctorProfilePic ?? '',
                        appointment?.doctorSocialProfilePic ?? '',
                        100,
                        fit: BoxFit.contain),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Text(
                    '${appointment?.doctorFirstName?.capitalizeFirst} ${appointment?.doctorLastName?.capitalizeFirst}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Merriweather',
                      fontWeight: FontWeight.w400,
                      color: _isDark ? Colors.white : Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Your rating',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Merriweather',
                      color: _isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  SmoothStarRating(
                    allowHalfRating: false,
                    starCount: 5,
                    rating: appointment?.ratingByPatient ?? 0.0,
                    size: Get.height * 0.05,
                    isReadOnly: true,
                    color: Colors.blue,
                    borderColor: Colors.blue,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    spacing: .5,
                  ),
                ],
              ),
            ),
          );
        }
        return RatingDialog(
          initialRating: 0,
          image: Container(
            width: Get.width * 0.2,
            height: Get.width * 0.2,
            child: Utils().patientProfile(appointment?.doctorProfilePic ?? '',
                appointment?.doctorSocialProfilePic ?? '', 100,
                fit: BoxFit.contain),
          ),
          title: Text(
            '${appointment?.doctorFirstName?.capitalizeFirst} ${appointment?.doctorLastName?.capitalizeFirst}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          message: Text(
            'Tap a star to set your rating',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          enableComment: false,
          submitButtonText: 'Submit',
          onCancelled: () => print('cancelled'),
          starColor: Colors.blue,
          onSubmitted: (response) async {
            String rate = response.rating.toString();
            var rate1 = rate.split('.');
            SetRatingForTheDoctorRequestModel requestModel =
                SetRatingForTheDoctorRequestModel(
              patientId: '${userController.user.value.id}',
              doctorId: appointment.doctorId,
              rating: rate1.first,
              review: '',
            );
            await setRatingForTheDoctorViewModel.setRatingForTheDoctorViewModel(
                requestModel: requestModel);
            if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.COMPLETE) {
            } else if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.LOADING) {
            } else if (setRatingForTheDoctorViewModel
                    .setRatingForTheDoctorApiResponse.status ==
                Status.ERROR) {}

            await setNewData();
          },
        );
      },
    );
  }
}*/
