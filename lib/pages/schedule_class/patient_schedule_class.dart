import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/book_withdraw_req_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_class_list_patient_data_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/schedule_class/coursedetail%20screen.dart';
import 'package:doctor_appointment_booking/utils/common_snackbar.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class ScheduleClass extends StatefulWidget {
  @override
  _ScheduleClassState createState() => _ScheduleClassState();
}

class _ScheduleClassState extends State<ScheduleClass> {
  DateTime selectedDate = DateTime.now();
  String mySelectDate;
  bool isSelected = true;
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final UserController userController = Get.find();
  PatientScheduledClassController patientScheduledClassController = Get.find();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    ).then((value) {
      if (value != null && value != selectedDate)
        setState(() {
          selectedDate = value;
        });
      mySelectDate = "${value.toLocal()}".split(' ')[0];
      patientScheduledClassController.getClassListPatient(
          id: userController.user.value.id, date: mySelectDate);
      print("IS FILTER $mySelectDate");

      return;
    });
    log('picked==========>>>>>$picked');
  }

  @override
  void initState() {
    // TODO: implement initState
    // patientScheduledClassController.getClassListPatient(
    //     id: Prefs.getString(Prefs.SOCIALID), date: '');
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
          title: Text(
            'Scheduled class',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: Get.width * 1.5,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.calendar_today_outlined,
                          size: 18, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: mySelectDate != null && mySelectDate != ""
                          ? Text("${selectedDate.toLocal()}".split(' ')[0])
                          : Text(
                              "Choose date",
                              style: TextStyle(
                                fontSize: Get.height * 0.027,
                              ),
                            ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color:
                        _isDark ? Colors.grey.withOpacity(0.2) : Colors.black26,
                  ),
                ),
              ),
            ),
            GetBuilder<PatientScheduledClassController>(
              builder: (controller) {
                if (controller.getClassPatientApiResponse.status ==
                    Status.LOADING) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Utils.circular(),
                    ),
                  );
                }
                /* if (controller.getClassPatientApiResponse.status ==
                        Status.ERROR) {
                      return Text("Server error");
                    }*/
                ClassListPatientResponseModel response =
                    controller.getClassPatientApiResponse.data;
                if (response.data == null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                        child: Text(
                      "No data found",
                      style: TextStyle(fontSize: 21),
                    )),
                  );
                } else if (response.data.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                        child: Text(
                      "No data found",
                      style: TextStyle(fontSize: 21),
                    )),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: response.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              CourseDetailScreen(
                                classId: response.data[index].id,
                                isBooked: response.data[index].isBooked,
                                mySelectedDate: mySelectDate,
                              ),
                            );
                          },
                          child: Container(
                            // height: Get.height * 0.2,
                            decoration: BoxDecoration(
                              color: _isDark
                                  ? Colors.grey.withOpacity(0.2)
                                  : Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0.5, 0.5),
                                )
                              ],
                              // border: Border.all(color: Colors.grey, width: 1)
                            ),
                            // width: Get.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        // width: Get.width,
                                        height: Get.height * 0.2,
                                        margin: EdgeInsets.only(bottom: 30),
                                        decoration: BoxDecoration(
                                          /* image: DecorationImage(
                                                    image: NetworkImage(response
                                                                    .data[index]
                                                                    .classFeaturedImage ==
                                                                null ||
                                                            response.data[index]
                                                                    .classFeaturedImage ==
                                                                ''
                                                        ? 'https://www.safefood.net/getmedia/8b0483a1-ea59-4a74-857d-675a9cfecc80/medical-conditions.jpg?w=2048&h=1152&ext=.jpg&width=1360&resizemode=force'
                                                        : response.data[index]
                                                            .classFeaturedImage),
                                                    fit: BoxFit.fill),*/
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: OctoImage(
                                            image: CachedNetworkImageProvider(
                                              response.data[index]
                                                              .classFeaturedImage ==
                                                          null ||
                                                      response.data[index]
                                                              .classFeaturedImage ==
                                                          ''
                                                  ? 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'
                                                  : response.data[index]
                                                      .classFeaturedImage,
                                            ),
                                            // placeholderBuilder:
                                            //     OctoPlaceholder.blurHash(
                                            //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                            //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                                            // ),
                                            progressIndicatorBuilder:
                                                (context, progress) {
                                              double? value;
                                              var expectedBytes =
                                                  progress?.expectedTotalBytes;
                                              if (progress != null &&
                                                  expectedBytes != null) {
                                                value = progress
                                                        .cumulativeBytesLoaded /
                                                    expectedBytes;
                                              }
                                              return CircularProgressIndicator(
                                                  value: value);
                                            },
                                            errorBuilder: OctoError.icon(
                                              color: Colors.red,
                                            ),
                                            fit: BoxFit.cover,
                                            height: Get.height,
                                            width: Get.width,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 15,
                                        right: 15,
                                        child: Container(
                                          width: Get.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: buildContainer(
                                                  title:
                                                      "Dr. ${response.data[index].doctorFullName ?? ''}",
                                                  colorName: Colors.white,
                                                  colorText: Colors.black,
                                                ),
                                              ),
                                              Expanded(
                                                child: buildContainer(
                                                  title: "Live",
                                                  colorName: Colors.white,
                                                  colorText: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 0,
                                      //   right: 25,
                                      //   child: buildContainer(
                                      //       title: "Live/Running",
                                      //       colorName: Colors.white,
                                      //       colorText: Colors.black),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.height * 0.012),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          response.data[index].title
                                                  .toUpperCase() ??
                                              '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width * 2,
                                  height: 2,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.black12,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.height * 0.012),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date',
                                              style: TextStyle(
                                                color: _isDark
                                                    ? Colors.white
                                                        .withOpacity(0.6)
                                                    : Colors.grey,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "${response.data[index].classDate}" ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: Get.height * 0.060,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.040),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Time',
                                                  style: TextStyle(
                                                    color: _isDark
                                                        ? Colors.white
                                                            .withOpacity(0.6)
                                                        : Colors.grey,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${response.data[index].classStartTime} to ${response.data[index].classEndTime}',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width * 2,
                                  height: 2,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.black12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setState1) {
                                            return SimpleDialog(
                                              contentPadding: EdgeInsets.zero,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.black,
                                                          size: 28,
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(height: 20),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: Text(
                                                              response.data[index]
                                                                          .isBooked ==
                                                                      false
                                                                  ? "Book Now"
                                                                  : "Withdraw",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              width: Get.width *
                                                                  0.04,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  fixedSize: Size(
                                                                      Get.width,
                                                                      40),
                                                                ),
                                                                child: Text(
                                                                  "Cancel",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  BookWithdrawReqModel
                                                                      model =
                                                                      BookWithdrawReqModel();
                                                                  model.action =
                                                                      response.data[index].isBooked ==
                                                                              false
                                                                          ? '1'
                                                                          : '2';
                                                                  await patientScheduledClassController
                                                                      .bookWithdrawClass(
                                                                          model:
                                                                              model,
                                                                          classId: response
                                                                              .data[
                                                                                  index]
                                                                              .id,
                                                                          id: Prefs.getString(Prefs
                                                                              .SOCIALID))
                                                                      .then(
                                                                          (value) {
                                                                    if (patientScheduledClassController
                                                                            .bookWithdrawClassApiResponse
                                                                            .status ==
                                                                        Status
                                                                            .COMPLETE) {
                                                                      MessageStatusResponseModel
                                                                          response =
                                                                          patientScheduledClassController
                                                                              .bookWithdrawClassApiResponse
                                                                              .data;
                                                                      if (response
                                                                              .status ==
                                                                          'Success') {
                                                                        CommonSnackBar.snackBar(
                                                                            message:
                                                                                response.message);
                                                                        Future.delayed(
                                                                            Duration(seconds: 2),
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          patientScheduledClassController.getClassListPatient(
                                                                              id: userController.user.value.id,
                                                                              date: mySelectDate ?? '');
                                                                        });
                                                                      } else {
                                                                        CommonSnackBar.snackBar(
                                                                            message:
                                                                                response.message);
                                                                        Future.delayed(
                                                                            Duration(seconds: 2),
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      }
                                                                    } else {
                                                                      CommonSnackBar.snackBar(
                                                                          message:
                                                                              "Server error");
                                                                    }
                                                                  });
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  fixedSize: Size(
                                                                      Get.width,
                                                                      40),
                                                                ),
                                                                child: Text(
                                                                  "Confirm",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Get.width *
                                                                  0.04,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    GetBuilder<
                                                        PatientScheduledClassController>(
                                                      builder: (controller) {
                                                        if (controller
                                                                .bookWithdrawClassApiResponse
                                                                .status ==
                                                            Status.LOADING) {
                                                          return Container(
                                                            height: Get.height *
                                                                0.205,
                                                            width: Get.width,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            child: Center(
                                                              child: Utils
                                                                  .circular(),
                                                            ),
                                                          );
                                                        }
                                                        return SizedBox();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );

                                    /*  showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Container(
                                            height: Get.height * 0.165,
                                            width: Get.width * 0.42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        response.data[index]
                                                                    .isBooked ==
                                                                false
                                                            ? "Book Now"
                                                            : "Withdraw",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              Get.height * 0.029,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: Get.height * 0.02,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          Get.height *
                                                                              0.008),
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            onPressed: () async {
                                                              BookWithdrawReqModel
                                                                  model =
                                                                  BookWithdrawReqModel();
                                                              model
                                                                  .action = response
                                                                          .data[
                                                                              index]
                                                                          .isBooked ==
                                                                      false
                                                                  ? '1'
                                                                  : '2';
                                                              await patientScheduledClassController
                                                                  .bookWithdrawClass(
                                                                      model: model,
                                                                      classId: response
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                      id: Prefs
                                                                          .getString(
                                                                              Prefs
                                                                                  .SOCIALID))
                                                                  .then((value) {
                                                                if (patientScheduledClassController
                                                                        .bookWithdrawClassApiResponse
                                                                        .status ==
                                                                    Status
                                                                        .COMPLETE) {
                                                                  MessageStatusResponseModel
                                                                      response =
                                                                      patientScheduledClassController
                                                                          .bookWithdrawClassApiResponse
                                                                          .data;
                                                                  if (response
                                                                          .status ==
                                                                      'Success') {
                                                                    CommonSnackBar.snackBar(
                                                                        message:
                                                                            response
                                                                                .message);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      patientScheduledClassController.getClassListPatient(
                                                                          id: Prefs.getString(
                                                                              Prefs
                                                                                  .SOCIALID),
                                                                          date: mySelectDate ??
                                                                              '');
                                                                    });
                                                                  } else {
                                                                    CommonSnackBar.snackBar(
                                                                        message:
                                                                            response
                                                                                .message);
                                                                    Future.delayed(
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  }
                                                                } else {
                                                                  CommonSnackBar
                                                                      .snackBar(
                                                                          message:
                                                                              "Server error");
                                                                }
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          Get.height *
                                                                              0.008),
                                                              child: Text(
                                                                "Confirm",
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                GetBuilder<
                                                    PatientScheduledClassController>(
                                                  builder: (controller) {
                                                    if (controller
                                                            .bookWithdrawClassApiResponse
                                                            .status ==
                                                        Status.LOADING) {
                                                      return Container(
                                                        height: Get.height,
                                                        width: Get.width,
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );*/
                                  },
                                  child: response.data[index].isBooked == false
                                      ? buildContainerButton(
                                          title: "Book Now",
                                          colorText: Colors.white,
                                          colorName: Colors.blueAccent,
                                        )
                                      : buildContainerButton(
                                          title: "Withdraw",
                                          colorText: Colors.white,
                                          colorName: Colors.red,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  Container buildContainer({
    String title,
    Color colorName,
    Color colorText,
  }) {
    return Container(
      height: 40,
      // width: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        "$title",
        style: TextStyle(
          color: colorText == null ? Colors.black : colorText,
          fontSize: Get.height * 0.025,
        ),
      ),

      decoration: BoxDecoration(
        color: colorName,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0.5, 0.5),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Container buildContainerButton({
    String title,
    Color colorName,
    Color colorText,
  }) {
    return Container(
      height: 50,
      // width: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Text(
        "$title",
        style: TextStyle(
          color: colorText,
          fontSize: 20,
        ),
      ),

      decoration: BoxDecoration(
        color: colorName,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0.5, 0.5),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

/*Widget col(){
    return    Column(
  children: [
  headingContainer(index: index),
  Padding(
  padding: EdgeInsets.symmetric(
  horizontal: Get.width * 0.1,
  vertical: Get.height * 0.012),
  child: Row(
  mainAxisAlignment:
  MainAxisAlignment.spaceBetween,
  children: [
  Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [
  Text(
  'Date',
  style: TextStyle(
  color: Colors.grey,
  fontSize: Get.width * 0.037,
  fontWeight: FontWeight.w500),
  ),
  Text(
  '25-11-2021',
  style: TextStyle(
  color: Colors.black,
  fontSize: Get.width * 0.045,
  fontWeight: FontWeight.w600),
  ),
  ],
  ),
  Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [
  Text(
  'Start Time',
  style: TextStyle(
  color: Colors.grey,
  fontSize: Get.width * 0.037,
  fontWeight: FontWeight.w500),
  ),
  Text(
  '1:05 PM',
  style: TextStyle(
  color: Colors.black,
  fontSize: Get.width * 0.045,
  fontWeight: FontWeight.w600),
  ),
  ],
  ),
  ],
  ),
  ),
  Padding(
  padding: EdgeInsets.symmetric(
  horizontal: Get.width * 0.1,
  vertical: Get.height * 0.012),
  child: Row(
  mainAxisAlignment:
  MainAxisAlignment.spaceBetween,
  children: [
  Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [
  Text(
  'Status',
  style: TextStyle(
  color: Colors.grey,
  fontSize: Get.width * 0.037,
  fontWeight: FontWeight.w500),
  ),
  Text(
  '4',
  style: TextStyle(
  color: Colors.black,
  fontSize: Get.width * 0.045,
  fontWeight: FontWeight.w600),
  ),
  ],
  ),
  Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [
  Text(
  'End Time',
  style: TextStyle(
  color: Colors.grey,
  fontSize: Get.width * 0.037,
  fontWeight: FontWeight.w500),
  ),
  Text(
  '6:00 PM',
  style: TextStyle(
  color: Colors.black,
  fontSize: Get.width * 0.045,
  fontWeight: FontWeight.w600),
  ),
  ],
  ),
  ],
  ),
  ),
  Padding(
  padding: EdgeInsets.symmetric(
  horizontal: Get.width * 0.1,
  vertical: Get.height * 0.012),
  child: Row(
  mainAxisAlignment:
  MainAxisAlignment.spaceBetween,
  children: [
  Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [
  Text(
  'Class owner person name ',
  style: TextStyle(
  color: Colors.grey,
  fontSize: Get.width * 0.037,
  fontWeight: FontWeight.w500),
  ),
  Text(
  'Dr. Alex',
  style: TextStyle(
  color: Colors.black,
  fontSize: Get.width * 0.045,
  fontWeight: FontWeight.w600),
  ),
  ],
  ),
  // Spacer(),
  InkWell(
  onTap: () {
  // Get.to(CourseDetailScreen(),
  //     arguments: courses[index]);
  },
  child: Padding(
  padding:
  EdgeInsets.all(Get.width * 0.025),
  child: Center(
  child: Text(
  'Attend 5',
  style: TextStyle(
  color: Colors.blueAccent,
  fontSize: Get.width * 0.05,
  fontWeight: FontWeight.bold,
  decoration:
  TextDecoration.underline),
  )),
  ),
  )
  ],
  ),
  ),
  ],
  );
}*/
}
