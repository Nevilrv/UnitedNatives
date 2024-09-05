import 'dart:async';

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/requestModel/book_withdraw_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_patient_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailScreen extends StatefulWidget {
  final String? classId;
  final String? mySelectedDate;
  final bool? isBooked;

  const CourseDetailScreen({
    super.key,
    this.classId,
    this.isBooked,
    this.mySelectedDate,
  });
  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  PatientScheduledClassController patientScheduledClassController = Get.find();
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final UserController userController = Get.find();
  var data = Get.arguments;
  @override
  void initState() {
    patientScheduledClassController.classDetailDoctor(
        id: userController.user.value.id!, classId: widget.classId!);
    super.initState();
    controller = TabController(length: 1, vsync: this);
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: GetBuilder<PatientScheduledClassController>(
              builder: (controller) {
                if (controller.classDetailPatientApiResponse.status ==
                    Status.LOADING) {
                  return Center(
                    child: Utils.circular(),
                  );
                }
                if (controller.classDetailPatientApiResponse.status ==
                    Status.ERROR) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text("Server error"),
                    ),
                  );
                }
                ClassDetailPatientResponseModel responseModel =
                    controller.classDetailPatientApiResponse.data;
                return Stack(
                  children: [
                    ListView(
                      children: [
                        headerView(
                          image: responseModel.data?.classFeaturedImage ?? "",
                          startTime: responseModel.data?.classStartTime ?? "",
                          endTime: responseModel.data?.classEndTime ?? "",
                          date: DateFormat('yyyy-MM-dd')
                              .format(
                                DateTime.parse(
                                    responseModel.data!.classDate.toString()),
                              )
                              .toString(),
                          title: responseModel.data?.title ?? "",
                          drName: responseModel.data?.doctorFullName ?? "",
                        ),
                        // Get.width * 0.05
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02,
                              vertical: Get.height * 0.012),
                          child: Text(
                            'Description :',
                            style: TextStyle(
                              color: _isDark ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          child: tab1(
                            desc: responseModel.data!.description!,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
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
                                                Navigator.pop(context);
                                              },
                                              child: const Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 20),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    responseModel.data
                                                                ?.isBooked ==
                                                            false
                                                        ? "Book Now"
                                                        : "Withdraw",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: Get.width * 0.04,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        fixedSize:
                                                            Size(Get.width, 40),
                                                      ),
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        BookWithdrawReqModel
                                                            model =
                                                            BookWithdrawReqModel();
                                                        model
                                                            .action = responseModel
                                                                    .data
                                                                    ?.isBooked ==
                                                                false
                                                            ? '1'
                                                            : '2';
                                                        await patientScheduledClassController
                                                            .bookWithdrawClass(
                                                          model: model,
                                                          classId:
                                                              widget.classId!,
                                                          id: userController
                                                              .user.value.id!,
                                                        )
                                                            .then((value) {
                                                          if (patientScheduledClassController
                                                                  .bookWithdrawClassApiResponse
                                                                  .status ==
                                                              Status.COMPLETE) {
                                                            MessageStatusResponseModel
                                                                response =
                                                                patientScheduledClassController
                                                                    .bookWithdrawClassApiResponse
                                                                    .data;
                                                            if (response
                                                                    .status ==
                                                                'Success') {
                                                              CommonSnackBar.snackBar(
                                                                  message: response
                                                                      .message!);
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                                await patientScheduledClassController.classDetailDoctor(
                                                                    id: Prefs.getString(Prefs
                                                                            .SOCIALID) ??
                                                                        "",
                                                                    classId: widget
                                                                        .classId!);
                                                                await patientScheduledClassController.getClassListPatient(
                                                                    id: Prefs.getString(Prefs
                                                                            .SOCIALID) ??
                                                                        "",
                                                                    date: widget
                                                                            .mySelectedDate ??
                                                                        '');
                                                              });
                                                            } else {
                                                              CommonSnackBar.snackBar(
                                                                  message: response
                                                                          .message ??
                                                                      "");
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                                  () async {
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
                                                        fixedSize:
                                                            Size(Get.width, 40),
                                                      ),
                                                      child: const Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.04,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
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
                                                  height: Get.height * 0.205,
                                                  width: Get.width,
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  child: Center(
                                                    child: Utils.circular(),
                                                  ),
                                                );
                                              }
                                              return const SizedBox();
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

                          /*    showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: Get.height * 0.165,
                                  width: Get.width * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              responseModel.data.isBooked == false
                                                  ? "Confirm"
                                                  : "Withdraw",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Get.height * 0.029,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.02,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            Get.height * 0.008),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
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
                                                    BookWithdrawReqModel model =
                                                        BookWithdrawReqModel();
                                                    model.action = responseModel
                                                                .data.isBooked ==
                                                            false
                                                        ? '1'
                                                        : '2';
                                                    await patientScheduledClassController
                                                        .bookWithdrawClass(
                                                      model: model,
                                                      classId: widget.classId,
                                                      id: Prefs.getString(
                                                          Prefs.SOCIALID),
                                                    )
                                                        .then((value) {
                                                      if (patientScheduledClassController
                                                              .bookWithdrawClassApiResponse
                                                              .status ==
                                                          Status.COMPLETE) {
                                                        MessageStatusResponseModel
                                                            response =
                                                            patientScheduledClassController
                                                                .bookWithdrawClassApiResponse
                                                                .data;
                                                        if (response.status ==
                                                            'Success') {
                                                          CommonSnackBar.snackBar(
                                                              message:
                                                                  response.message);
                                                          Future.delayed(
                                                              Duration(seconds: 2),
                                                              () async {
                                                            Navigator.pop(context);
                                                            await patientScheduledClassController
                                                                .classDetailDoctor(
                                                                    id: Prefs.getString(
                                                                        Prefs
                                                                            .SOCIALID),
                                                                    classId: widget
                                                                        .classId);
                                                            await patientScheduledClassController
                                                                .getClassListPatient(
                                                                    id: Prefs.getString(
                                                                        Prefs
                                                                            .SOCIALID),
                                                                    date: widget
                                                                            .mySelectedDate ??
                                                                        '');
                                                          });
                                                        } else {
                                                          CommonSnackBar.snackBar(
                                                              message:
                                                                  response.message);
                                                          Future.delayed(
                                                              Duration(seconds: 2),
                                                              () async {
                                                            Navigator.pop(context);
                                                          });
                                                        }
                                                      } else {
                                                        CommonSnackBar.snackBar(
                                                            message:
                                                                "Server error");
                                                      }
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            Get.height * 0.008),
                                                    child: Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
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
                                      GetBuilder<PatientScheduledClassController>(
                                        builder: (controller) {
                                          if (controller
                                                  .bookWithdrawClassApiResponse
                                                  .status ==
                                              Status.LOADING) {
                                            return Container(
                                              height: Get.height,
                                              width: Get.width,
                                              color: Colors.grey.withOpacity(0.3),
                                              child: Center(
                                                child: CircularProgressIndicator(),
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
                        child: responseModel.data!.isBooked == false
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
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Column tab1({required String desc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          desc,
          style: TextStyle(
            fontSize: 20,
            color: _isDark ? Colors.white.withOpacity(0.8) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget headerView(
      {String? image,
      String? drName,
      String? title,
      String? date,
      String? startTime,
      String? endTime}) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Container(
                    // width: Get.width,
                    height: Get.height * 0.30,
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image == null || image == ''
                            ? 'https://www.safefood.net/getmedia/8b0483a1-ea59-4a74-857d-675a9cfecc80/medical-conditions.jpg?w=2048&h=1152&ext=.jpg&width=1360&resizemode=force'
                            : image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 15,
                    right: 15,
                    child: Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildContainer(
                            title: "Dr. ${drName ?? ""}  ",
                            colorName: Colors.white,
                            colorText: Colors.black,
                          ),
                          const SizedBox(width: 10),
                          // Spacer(),
                          buildContainer(
                            title: "Live",
                            colorName: Colors.white,
                            colorText: Colors.black,
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
                  horizontal: Get.height * 0.02, vertical: Get.height * 0.012),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      title?.toUpperCase() ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _isDark ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Container(
              width: Get.width * 2,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.height * 0.02, vertical: Get.height * 0.012),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            color: _isDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          date ?? "",
                          style: TextStyle(
                            color: _isDark ? Colors.white : Colors.black,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Time',
                              style: TextStyle(
                                color: _isDark
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '$startTime to $endTime',
                            style: TextStyle(
                              color: _isDark ? Colors.white : Colors.black,
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.black12,
            ),
            // index.isEven
            //     ?

            // : buildContainerButton(title: "Withdraw",colorText: Colors.white,colorName: Colors.red),
          ],
        ),
        Positioned(
          top: Get.height * 0.02,
          left: Get.width * 0.04,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              radius: Get.height * 0.023,
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildContainer({
    String? title,
    Color? colorName,
    Color? colorText,
  }) {
    return Container(
      height: 40,
      // width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),

      decoration: BoxDecoration(
        color: colorName,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0.5, 0.5),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title",
        maxLines: 1,
        style: TextStyle(
          color: colorText ?? Colors.black,
          fontSize: Get.height * 0.025,
        ),
      ),
    );
  }

  Container buildContainerButton({
    String? title,
    Color? colorName,
    Color? colorText,
  }) {
    return Container(
      height: 50,
      width: Get.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(bottom: 25, right: 25, left: 25, top: 10),
      decoration: BoxDecoration(
        color: colorName,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0.5, 0.5),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title",
        style: TextStyle(
          color: colorText,
          fontSize: 20,
        ),
      ),
    );
  }
}
