import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/agora_video_call.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/ResponseModel/getSorted_patient_chatList_model.dart';
import 'package:united_natives/ResponseModel/get_all_doctor.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/notification_list_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/appointment/my_appointments_page.dart';
import 'package:united_natives/pages/messages/messages_detail_page.dart';
import 'package:united_natives/pages/prescription/prescription_list_page.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';
import 'package:united_natives/viewModel/notification_list_view_model.dart';

class PatientNotificationPage extends StatefulWidget {
  const PatientNotificationPage({super.key});

  @override
  State<PatientNotificationPage> createState() =>
      _PatientNotificationPageState();
}

class _PatientNotificationPageState extends State<PatientNotificationPage> {
  NotificationListController notificationListController =
      Get.put(NotificationListController());
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getSortedPatientChatList();
  AgoraController agoraController = Get.put(AgoraController());
  Timer? timer;
  int zMeeting = 0;
  int zMeetings = 0;

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  String? deleteButton;

  getNotification() async {
    deleteButton = null;
    await notificationListController.getNotificationList();

    if (notificationListController.getNotificationListApiResponse.status ==
        Status.COMPLETE) {
      NotificationListResponseModel responseModel =
          notificationListController.getNotificationListApiResponse.data;

      deleteButton = responseModel.status;
      setState(() {});
    }
  }

  cameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to provide a Camera Permission'),
      ));
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    PermissionStatus microPhoneStatus = await Permission.microphone.request();

    if (microPhoneStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to provide a MicroPhone Permission'),
      ));
    }
    if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()}${(diff.inDays / 365).floor() == 1 ? "y" : "y"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()}${(diff.inDays / 30).floor() == 1 ? "m" : "m"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? "w" : "w"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays}${diff.inDays == 1 ? "d" : "d"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours}${diff.inHours == 1 ? "h" : "h"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}${diff.inMinutes == 1 ? "min" : "min"} ago";
    }
    return "just now";
  }

  bool isDark = Prefs.isDark();

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text('Notifications',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
            actions: [
              if (deleteButton == 'Fail')
                const SizedBox()
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: TextButton(
                      onPressed: () {
                        _showAlert(
                          context,
                          () async {
                            Navigator.pop(context);
                            await notificationListController
                                .deleteAllNotification()
                                .then(
                              (value) async {
                                getNotification();
                              },
                            );
                            MessageStatusResponseModel model =
                                notificationListController
                                    .deleteAllNotificationApiResponse.data;
                            if (model.status == 'Success') {
                              CommonSnackBar.snackBar(
                                  message: model.message ?? "");
                            } else {
                              CommonSnackBar.snackBar(
                                  message: model.message ?? "");
                            }
                          },
                        );
                      },
                      child: Text(
                        'Delete All',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontSize: 17),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: GetBuilder<NotificationListController>(
            builder: (controller) {
              if (controller.getNotificationListApiResponse.status ==
                  Status.LOADING) {
                return Center(
                  child: Utils.circular(),
                );
              }
              if (controller.getNotificationListApiResponse.status ==
                  Status.ERROR) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('Server error'),
                  ),
                );
              }
              NotificationListResponseModel responseModel =
                  controller.getNotificationListApiResponse.data;
              if (responseModel.status == 'Fail') {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'No Notification !',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20),
                    ),
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    getNotification();
                  },
                  child: Stack(
                    children: [
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return responseModel.data?[index].type == '11'
                              ? const SizedBox()
                              : const Divider(
                                  indent: 0, endIndent: 0, height: 0);
                        },
                        itemCount: responseModel.data!.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return responseModel.data?[index].type == '11'
                              ? const SizedBox()
                              : Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (responseModel
                                                .data?[index].relationType ==
                                            '2') {
                                          Get.to(
                                              () => const MyAppointmentsPage());
                                        } else if (responseModel
                                                .data?[index].relationType ==
                                            '4') {
                                          Get.to(
                                            () => PrescriptionPage(
                                                appointmentId: responseModel
                                                    .data?[index]
                                                    .relationData
                                                    ?.appointmentId),
                                          );
                                        } else if (responseModel
                                                .data?[index].type ==
                                            '11') {
                                          List<SortedPatientChat> patientChat =
                                              <SortedPatientChat>[];
                                          await patientHomeScreenController
                                              .getSortedPatientChatList();
                                          if (patientHomeScreenController
                                                  .getSortedPatientChatListModel
                                                  .value
                                                  .apiState ==
                                              APIState.COMPLETE) {
                                            for (var element
                                                in patientHomeScreenController
                                                    .newDataList) {
                                              if (responseModel
                                                      .data?[index].fromUserId
                                                      .toString() ==
                                                  element.fromId) {
                                                patientChat.add(element);
                                              }
                                            }
                                            if (patientChat.isEmpty) {
                                              return messageDialog(
                                                  title: "Chat deleted",
                                                  message:
                                                      "This chat is deleted by the ${responseModel.data![index].fromUserData?.firstName}",
                                                  context: context);
                                            }

                                            patientHomeScreenController
                                                    .chatKey.value =
                                                patientChat[0].chatKey!;
                                            patientHomeScreenController
                                                    .doctorName.value =
                                                patientChat[0].doctorFirstName!;
                                            patientHomeScreenController
                                                    .doctorLastName.value =
                                                patientChat[0].doctorLastName!;
                                            patientHomeScreenController
                                                    .doctorId.value =
                                                patientChat[0].doctorId!;
                                            patientHomeScreenController
                                                    .toId.value =
                                                patientChat[0].doctorId!;

                                            patientHomeScreenController
                                                    .doctorProfile =
                                                patientChat[0]
                                                    .doctorProfilePic!;
                                            patientHomeScreenController
                                                    .doctorSocialProfile =
                                                patientChat[0]
                                                    .doctorSocialProfilePic!;

                                            patientHomeScreenController
                                                .getAllPatientChatMessages
                                                .value
                                                .patientChatList
                                                ?.clear();

                                            await patientHomeScreenController
                                                .getAllPatientChatMessagesList(
                                                    patientChat[0].chatKey);

                                            Doctor doctor = Doctor(
                                              chatKey: patientChat[0].chatKey,
                                            );
                                            await Get.to(
                                                () => MessagesDetailPage(
                                                      doctor: doctor,
                                                      sortedPatientChat:
                                                          patientChat[0],
                                                    ));
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.032,
                                            vertical: Get.height * 0.02),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 28,
                                              child: ClipOval(
                                                clipBehavior: Clip.hardEdge,
                                                child: OctoImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            responseModel
                                                                .data![index]
                                                                .fromUserData!
                                                                .profilePic!),
                                                    // placeholderBuilder:
                                                    //     OctoPlaceholder.blurHash(
                                                    //         'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                                                    progressIndicatorBuilder:
                                                        (context, progress) {
                                                      double? value;
                                                      var expectedBytes = progress
                                                          ?.expectedTotalBytes;
                                                      if (progress != null &&
                                                          expectedBytes !=
                                                              null) {
                                                        value = progress
                                                                .cumulativeBytesLoaded /
                                                            expectedBytes;
                                                      }
                                                      return CircularProgressIndicator(
                                                          value: value);
                                                    },
                                                    errorBuilder:
                                                        OctoError.circleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      text: Image.network(
                                                        'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                                                        color: const Color(
                                                            0xFF7E7D7D),
                                                      ),
                                                    ),
                                                    fit: BoxFit.fill,
                                                    height: Get.height,
                                                    width: Get.height),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    responseModel
                                                        .data![index].subject!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                  ),
                                                  Text(
                                                    responseModel
                                                        .data![index].body!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 17.5,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  responseModel.data![index]
                                                              .relationData ==
                                                          null
                                                      ? const SizedBox()
                                                      : responseModel
                                                                  .data![index]
                                                                  .relationData!
                                                                  .meetingStatus ==
                                                              'started'
                                                          ? SizedBox(
                                                              width: Get.width *
                                                                  0.4,
                                                              child:
                                                                  CustomButton(
                                                                text:
                                                                    'Join Meeting',
                                                                textSize: 16,
                                                                onPressed:
                                                                    () async {
                                                                  getNotification();
                                                                  await cameraPermission();

                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MyVideoCall(
                                                                        docId: responseModel
                                                                            .data?[index]
                                                                            .fromUserData
                                                                            ?.id,
                                                                        s1: responseModel
                                                                            .data?[index]
                                                                            .relationData
                                                                            ?.id,
                                                                        s2: responseModel
                                                                            .data?[index]
                                                                            .relationData
                                                                            ?.meetingId,
                                                                        channelName: responseModel
                                                                            .data?[index]
                                                                            .relationData
                                                                            ?.meetingId,
                                                                        token: responseModel
                                                                            .data?[index]
                                                                            .relationData
                                                                            ?.meetingPassword,
                                                                      ),
                                                                    ),
                                                                  ).then(
                                                                    (value) async {
                                                                      await Future.delayed(const Duration(
                                                                          milliseconds:
                                                                              500));

                                                                      await showDialog<
                                                                          String>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext c1) =>
                                                                                AlertDialog(
                                                                          title:
                                                                              const Text(
                                                                            "Appointment Ended",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                                                          ),
                                                                          content:
                                                                              const Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text("If you disconnect the call unintentionally please contact with your provider via message and rejoin/reconnect the meeting"),
                                                                            ],
                                                                          ),
                                                                          actions: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                TextButton(
                                                                                  child: const Text(
                                                                                    "Okay",
                                                                                    style: TextStyle(fontSize: 22),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                              ),
                                                            )
                                                          : const SizedBox(),

                                                  // responseModel.data[index]
                                                  //             .relationType ==
                                                  //         '3'
                                                  //     ? responseModel
                                                  //                 .data[index]
                                                  //                 .relationData
                                                  //                 .meetingId ==
                                                  //             null
                                                  //         ? SizedBox()
                                                  //         : responseModel
                                                  //                     .data[index]
                                                  //                     .relationData
                                                  //                     .meetingStatus ==
                                                  //                 'started'
                                                  //             ? Text(
                                                  //                 '${responseModel.data[index].body}' +
                                                  //                     '\n',
                                                  //                 style: Theme.of(
                                                  //                         context)
                                                  //                     .textTheme
                                                  //                     .bodyText2
                                                  //                     .copyWith(
                                                  //                         fontSize:
                                                  //                             12),
                                                  //               )
                                                  //             : Text(
                                                  //                 'Zoom Meeting was ended' +
                                                  //                     '\n',
                                                  //                 style: Theme.of(
                                                  //                         context)
                                                  //                     .textTheme
                                                  //                     .bodyText2
                                                  //                     .copyWith(
                                                  //                         fontSize:
                                                  //                             12),
                                                  //               )
                                                  //     : SizedBox(),
                                                  // responseModel.data[index]
                                                  //             .relationType ==
                                                  //         '3'
                                                  //     ? responseModel
                                                  //                 .data[index]
                                                  //                 .relationData
                                                  //                 .meetingStatus ==
                                                  //             'started'
                                                  //         ? SizedBox(
                                                  //             width: Get.width * 0.4,
                                                  //             child: CustomButton(
                                                  //               text: 'Join Meeting',
                                                  //               // text: 'Start'.tr(),
                                                  //               textSize: 14,
                                                  //               onPressed: () async {
                                                  //                 // joinMeeting(
                                                  //                 //     context:
                                                  //                 //         context,
                                                  //                 //     meetingId: responseModel
                                                  //                 //         .data[index]
                                                  //                 //         .relationData
                                                  //                 //         .meetingId,
                                                  //                 //     password: responseModel
                                                  //                 //         .data[index]
                                                  //                 //         .relationData
                                                  //                 //         .meetingPassword);
                                                  //                 print(
                                                  //                     'metting ID == ${responseModel.data[index].relationData.meetingId}');
                                                  //                 print(
                                                  //                     'metting password == ${responseModel.data[index].relationData.meetingPassword}');
                                                  //                 Get.to(MyApps(
                                                  //                   channelName:
                                                  //                       '${responseModel.data[index].relationData.meetingId}',
                                                  //                   token:
                                                  //                       '${responseModel.data[index].relationData.meetingPassword}',
                                                  //                 ));
                                                  //               },
                                                  //               padding: EdgeInsets
                                                  //                   .symmetric(
                                                  //                 vertical: 10,
                                                  //               ),
                                                  //             ),
                                                  //           )
                                                  //         : SizedBox()
                                                  //     : SizedBox()
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${timeAgo(Utils.formattedDate(responseModel.data![index].created!))} ",
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                          .withOpacity(0.9)
                                                      : Colors.grey
                                                          .withOpacity(0.9),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: MediaQuery.of(context).size.height *
                                          0.05,
                                      child: IconButton(
                                        onPressed: () async {
                                          await notificationListController
                                              .deletNotification(
                                                  id: responseModel
                                                      .data![index].id!)
                                              .then((value) async =>
                                                  getNotification());
                                          MessageStatusResponseModel model =
                                              notificationListController
                                                  .deleteNotificationApiResponse
                                                  .data;
                                          if (model.status == 'Success') {
                                            CommonSnackBar.snackBar(
                                                message: model.message ?? "");
                                          } else {
                                            CommonSnackBar.snackBar(
                                                message: model.message ?? "");
                                          }
                                        },
                                        icon: Image.asset(
                                            'assets/images/delete.png',
                                            scale: 1.5),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                      controller.deleteNotificationApiResponse.status ==
                                  Status.LOADING ||
                              controller.deleteAllNotificationApiResponse
                                      .status ==
                                  Status.LOADING ||
                              controller
                                      .getNotificationListApiResponse.status ==
                                  Status.LOADING
                          ? Container(
                              color: Colors.black.withOpacity(0.1),
                              child: Center(
                                child: Utils.circular(),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  messageDialog(
      {required BuildContext context,
      required String message,
      required String title}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    child:
                        const Icon(Icons.clear, color: Colors.black, size: 28),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(Get.width, 40),
                          ),
                          child: const Text(
                            "Okay",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _showAlert(BuildContext context, void Function()? onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content: const Text("Are you sure want to delete all notifications?"),
          actions: <Widget>[
            TextButton(onPressed: onPressed, child: const Text("YES")),
            TextButton(
              child: const Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
