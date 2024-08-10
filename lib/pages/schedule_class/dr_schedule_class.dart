import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_class_doctor_data_reponse_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/schedule_class/dr_edit_scheduled_form.dart';
import 'package:united_natives/pages/schedule_class/dr_schedule_form.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/scheduled_class_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

import 'dr_course_detail_screen.dart';

class DrScheduleClass extends StatefulWidget {
  const DrScheduleClass({super.key});

  @override
  State<DrScheduleClass> createState() => _DrScheduleClassState();
}

class _DrScheduleClassState extends State<DrScheduleClass> {
  DateTime selectedDate = DateTime.now();
  String? mySelectDate;
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final UserController userController = Get.find();
  ScheduledClassController scheduledClassController =
      Get.put(ScheduledClassController());

  AdsController adsController = Get.find();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    ).then((value) {
      if (value != null && value != selectedDate) {
        setState(() {
          selectedDate = value;
          mySelectDate = mySelectDate = "${value.toLocal()}".split(' ')[0];
          scheduledClassController.getClassDoctor(
              id: userController.user.value.id!, date: mySelectDate!);
        });
      }
      mySelectDate = "${value?.toLocal()}".split(' ')[0];
      return selectedDate;
    });
    debugPrint('picked==========>>>>>$picked');
  }

  @override
  void initState() {
    scheduledClassController.getClassDoctor(
        id: userController.user.value.id!, date: '');
    // TODO: implement initState
    super.initState();
  }

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
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: Get.width * 1.5,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2,
                            color: _isDark
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.black26)),

                    // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.calendar_today_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 2,
                          child: mySelectDate != null && mySelectDate != ""
                              ? Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  "Choose date",
                                  style: TextStyle(
                                    fontSize: Get.height * 0.07,
                                  ),
                                ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                        )
                      ],
                    ),
                  ),
                ),
                GetBuilder<ScheduledClassController>(
                  builder: (controller) {
                    if (controller.getClassDoctorApiResponse.status ==
                        Status.LOADING) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Utils.circular(),
                        ),
                      );
                    }
                    if (controller.getClassDoctorApiResponse.status ==
                        Status.ERROR) {
                      return const Text("Server error");
                    }
                    GetClassDoctorDataResponseModel response =
                        controller.getClassDoctorApiResponse.data;
                    if (response.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            "No data found",
                            style: TextStyle(fontSize: 21),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: response.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  DrCourseDetailScreen(
                                    classId: response.data?[index].id,
                                  ),
                                );
                                // Get.to(CourseDetailScreen(), arguments: courses[index]);
                              },
                              child: Container(
                                // height: Get.height * 0.2,
                                decoration: BoxDecoration(
                                  color: _isDark
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: const [
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
                                            margin: const EdgeInsets.only(
                                                bottom: 30),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: OctoImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  response.data?[index]
                                                                  .classFeaturedImage ==
                                                              null ||
                                                          response.data?[index]
                                                                  .classFeaturedImage ==
                                                              ''
                                                      ? 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'
                                                      : response.data![index]
                                                          .classFeaturedImage!,
                                                ),
                                                // placeholderBuilder:
                                                //     OctoPlaceholder.blurHash(
                                                //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                                                // ),
                                                progressIndicatorBuilder:
                                                    (context, progress) {
                                                  double? value;
                                                  var expectedBytes = progress
                                                      ?.expectedTotalBytes;
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
                                                height: Get.height * 0.2,
                                                width: Get.width,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: Get.width / 1.6,
                                            right: 10,
                                            child: buildContainer(
                                              title: "Live",
                                              colorName: Colors.white,
                                              colorText: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05,
                                        vertical: Get.height * 0.012,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            response.data?[index].title
                                                    ?.toUpperCase() ??
                                                "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Attendance ${response.data?[index].classAttendees ?? ""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _isDark
                                                  ? Colors.white
                                                      .withOpacity(0.6)
                                                  : Colors.grey,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * 2,
                                      height: 2,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.black12,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05,
                                        vertical: Get.height * 0.012,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                  response.data?[index]
                                                          .classDate ??
                                                      "",
                                                  style: const TextStyle(
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
                                                  horizontal:
                                                      Get.width * 0.040),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Time',
                                                      style: TextStyle(
                                                        color: _isDark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.6)
                                                            : Colors.grey,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${response.data?[index].classStartTime ?? ""} to ${response.data?[index].classEndTime ?? ""}',
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      color: Colors.black12,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(EditScheduledForm(
                                                title:
                                                    response.data?[index].title,
                                                description: response
                                                    .data?[index].description,
                                                classId:
                                                    response.data?[index].id,
                                                image: response.data?[index]
                                                    .classFeaturedImage,
                                                startDate: response
                                                    .data?[index].classDate,
                                                endTime: response
                                                    .data?[index].classEndTime,
                                                startTime: response.data?[index]
                                                    .classStartTime,
                                                urlSelectebDate: mySelectDate,
                                              ));
                                            },
                                            child: buildContainerButton(
                                              title: "Edit",
                                              colorText: Colors.white,
                                              colorName: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await scheduledClassController
                                                  .deleteClassDoctor(
                                                classId:
                                                    response.data![index].id!,
                                                id: userController
                                                    .user.value.id!,
                                              );
                                              if (scheduledClassController
                                                      .deleteClassApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                MessageStatusResponseModel
                                                    response =
                                                    scheduledClassController
                                                        .deleteClassApiResponse
                                                        .data;
                                                if (response.status ==
                                                    'Success') {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          response.message ??
                                                              "");
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2),
                                                      () async {
                                                    await scheduledClassController
                                                        .getClassDoctor(
                                                            id: userController
                                                                .user.value.id!,
                                                            date:
                                                                mySelectDate ??
                                                                    '');
                                                  });
                                                } else {
                                                  CommonSnackBar.snackBar(
                                                      message:
                                                          "Please try again");
                                                }
                                              } else {
                                                CommonSnackBar.snackBar(
                                                    message: "Server error");
                                              }
                                            },
                                            child: buildContainerButton(
                                              title: "Delete",
                                              colorText: Colors.white,
                                              colorName: Colors.red,
                                            ),
                                          ),
                                        )
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
                  },
                )
              ],
            ),
            GetBuilder<ScheduledClassController>(
              builder: (controller) {
                if (controller.deleteClassApiResponse.status ==
                    Status.LOADING) {
                  return Center(
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.grey.withOpacity(0.3),
                      child: Center(
                        child: Utils.circular(),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Get.to(ScheduleForm(
              urlSelectedTime: mySelectDate!,
            ));
          },
          child: const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 45,
            ),
          ),
        ),
      );
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

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
        title!,
        style: TextStyle(
          color: colorText ?? Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Container buildContainerButton({
    required String title,
    required Color colorName,
    required Color colorText,
  }) {
    return Container(
      height: 50,
      width: Get.width,
      // width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

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
        title,
        style: TextStyle(
          color: colorText,
          fontSize: 20,
        ),
      ),
    );
  }
}
