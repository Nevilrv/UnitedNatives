import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/notification_list_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/appointment/doctor_appointment.dart';
import 'package:united_natives/pages/doctormessages/messages_detail_page.dart';
import 'package:united_natives/utils/common_snackbar.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:united_natives/viewModel/notification_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:octo_image/octo_image.dart';

class DocNotificationsPage extends StatefulWidget {
  const DocNotificationsPage({super.key});

  @override
  State<DocNotificationsPage> createState() => _DocNotificationsPageState();
}

class _DocNotificationsPageState extends State<DocNotificationsPage> {
  NotificationListController notificationListController =
      Get.put(NotificationListController());
  Timer? timer;
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();
  GetSortedChatListDoctor getSortedChatListDoctor = GetSortedChatListDoctor();
  AddNewChatMessageController addNewChatMessageController = Get.find();

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  String? deleteButton;
  final UserController _userController = Get.find<UserController>();
  getNotification() async {
    deleteButton = null;
    await notificationListController.getNotificationList();
    await addNewChatMessageController.getSortedChatListDoctor(
        doctorId: _userController.user.value.id);
    if (notificationListController.getNotificationListApiResponse.status ==
        Status.COMPLETE) {
      NotificationListResponseModel responseModel =
          notificationListController.getNotificationListApiResponse.data;
      deleteButton = responseModel.status;
      setState(() {});
    }

    if (addNewChatMessageController.getDoctorSortedChatListApiResponse.status ==
        Status.COMPLETE) {
      getSortedChatListDoctor =
          addNewChatMessageController.getDoctorSortedChatListApiResponse.data;
      setState(() {});
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

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME);
    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            title: Text('Notifications',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center),
            actions: [
              deleteButton == 'Fail'
                  ? const SizedBox()
                  : Center(
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
                                    .then((value) async {
                                  getNotification();
                                });
                                MessageStatusResponseModel model =
                                    notificationListController
                                        .deleteAllNotificationApiResponse.data;
                                if (model.status == 'Success') {
                                  CommonSnackBar.snackBar(
                                      message: model.message!);
                                } else {
                                  CommonSnackBar.snackBar(
                                      message: model.message!);
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
                      Status.LOADING ||
                  controller.getNotificationListApiResponse.status ==
                      Status.LOADING) {
                // return Center(child: CircularProgressIndicator());
                return Center(
                  child: Utils.circular(),
                );
              }
              if (controller.getNotificationListApiResponse.status ==
                  Status.ERROR) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('Server error ')),
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
                              : const Divider(indent: 0, endIndent: 0);
                        },
                        itemCount: responseModel.data?.length ?? 0,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return responseModel.data?[index].type == '11'
                              ? const SizedBox()
                              : Builder(
                                  builder: (context) {
                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            // return;
                                            if (responseModel.data?[index]
                                                    .relationType ==
                                                '2') {
                                              Get.to(
                                                  const MyAppointmentsDoctor());
                                            } else if (responseModel
                                                    .data?[index].type ==
                                                '11') {
                                              // await Navigator.of(context)
                                              //     .pushNamed(Routes.doctorchatDetail);
                                              // TimerChange.timer.cancel();
                                              List<ShortedDoctorChat>
                                                  doctorChat =
                                                  <ShortedDoctorChat>[];
                                              await addNewChatMessageController
                                                  .getSortedChatListDoctor(
                                                      doctorId: _userController
                                                          .user.value.id)
                                                  .then((value) {
                                                getSortedChatListDoctor =
                                                    addNewChatMessageController
                                                        .getDoctorSortedChatListApiResponse
                                                        .data;

                                                getSortedChatListDoctor
                                                    .doctorChatList
                                                    ?.forEach((element) {
                                                  if (responseModel.data?[index]
                                                          .fromUserId
                                                          .toString() ==
                                                      element.fromId) {
                                                    doctorChat.add(element);
                                                  }
                                                });
                                              }).then((value) async {
                                                if (doctorChat.isEmpty) {
                                                  return messageDialog(
                                                      title: "Chat deleted",
                                                      message:
                                                          "This chat is deleted by the ${responseModel.data?[index].fromUserData?.firstName}",
                                                      context: context);
                                                }

                                                _doctorHomeScreenController
                                                    .doctorChat
                                                    .value = doctorChat[0];
                                                await Get.to(
                                                    DoctorMessagesDetailPage());
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.height * 0.02,
                                                vertical: Get.height * 0.015),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 28,
                                                  child: ClipOval(
                                                    clipBehavior: Clip.hardEdge,
                                                    child: OctoImage(
                                                      image: CachedNetworkImageProvider(
                                                          responseModel
                                                                  .data?[index]
                                                                  .fromUserData
                                                                  ?.profilePic ??
                                                              'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                                                      // placeholderBuilder:
                                                      //     OctoPlaceholder
                                                      //         .blurHash(
                                                      //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                      //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                                                      // ),

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
                                                      errorBuilder: OctoError
                                                          .circleAvatar(
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
                                                      width: Get.height,
                                                    ),
                                                  ),
                                                ),
                                                /*CircleAvatar(
                                                                                  radius: 40,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  backgroundImage: NetworkImage(
                                                                                    responseModel.data[index].fromUserData.profilePic??'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png' ,
                                                                                  ),
                                                                                ),*/
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        // '${responseModel.data[index].fromUserData.firstName.capitalizeFirst}',
                                                        "${responseModel.data?[index].subject}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                      ),

                                                      Text(
                                                        "${responseModel.data?[index].body}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 17.5),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      // responseModel.data[index].relationData
                                                      //     .meetingId ==
                                                      //     null
                                                      //     ? SizedBox()
                                                      //     : responseModel.data[index]
                                                      //     .relationData ==
                                                      //     'started'
                                                      //     ? Text(
                                                      //   '${responseModel.data[index].body}' +
                                                      //       '\n',
                                                      //   style: Theme.of(context)
                                                      //       .textTheme
                                                      //       .bodyText2
                                                      //       .copyWith(fontSize: 12),
                                                      // )
                                                      //     : Text(
                                                      //   'Zoom Meeting was ended' +
                                                      //       '\n',
                                                      //   style: Theme.of(context)
                                                      //       .textTheme
                                                      //       .bodyText2
                                                      //       .copyWith(fontSize: 12),
                                                      // ),
                                                      // responseModel.data[index].relationData
                                                      //     .meetingStatus ==
                                                      //     'started'
                                                      //     ? SizedBox(
                                                      //   width: Get.width * 0.4,
                                                      //   child: CustomButton(
                                                      //     text: 'Join Meeting',
                                                      //     // text: 'Start'.tr(),
                                                      //     textSize: 14,
                                                      //     onPressed: () async {
                                                      //       joinMeeting(
                                                      //           context: context,
                                                      //           meetingId: responseModel
                                                      //               .data[index]
                                                      //               .relationData
                                                      //               .meetingId,
                                                      //           password: responseModel
                                                      //               .data[index]
                                                      //               .relationData
                                                      //               .meetingPassword);
                                                      //     },
                                                      //     padding: EdgeInsets.symmetric(
                                                      //       vertical: 10,
                                                      //     ),
                                                      //   ),
                                                      // )
                                                      //     : SizedBox()
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  timeAgo(Utils.formattedDate(
                                                      "${responseModel.data?[index].created}")),

                                                  // DateFormat('yyyy-MM-dd hh:mm a').format(
                                                  //     DateTime.parse(responseModel
                                                  //         .data[index].created)),

                                                  // '${responseModel.data[index].created}',
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                            .withOpacity(0.9)
                                                        : Colors.grey
                                                            .withOpacity(0.9),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.042,
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
                                                    message: model.message!);
                                              } else {
                                                CommonSnackBar.snackBar(
                                                    message: model.message!);
                                              }
                                            },
                                            icon: Image.asset(
                                              'assets/images/delete.png',
                                              scale: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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

  _showAlert(BuildContext context, Function()? onPressed) {
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
}
