import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';

import '../../utils/constants.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // with AutomaticKeepAliveClientMixin<MessagesPage> {

  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getSortedPatientChatList();
  final UserController _userController = Get.find<UserController>();
  final PatientHomeScreenController patientHomeScreenCtlr =
      Get.find<PatientHomeScreenController>();

  // Timer timer;
  LogOutController logOutController = Get.put(LogOutController());

  @override
  void initState() {
    chatTimer();
    super.initState();
  }

  @override
  void dispose() {
    TimerChange.timer?.cancel();

    super.dispose();
  }

  AdsController adsController = Get.find();
  chatTimer() {
    TimerChange().patientTimerChange();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   patientHomeScreenController.getSortedPatientChatList();
    // });
  }

  onItemChanged(String value) {
    if (value.isEmpty) {
      chatTimer();
    } else {
      TimerChange.timer?.cancel();
    }
    setState(() {
      patientHomeScreenController.newDataList = patientHomeScreenController
          .getSortedPatientChatListModel.value.data!
          .where((SortedPatientChat sortedPatientChat) => sortedPatientChat
              .doctorFirstName!
              .toLowerCase()
              .contains(value.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        TimerChange.timer?.cancel();
      },

      child: GetBuilder<AdsController>(builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          body: RefreshIndicator(
            onRefresh: () =>
                patientHomeScreenController.getSortedPatientChatList(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(bottom: 5),
                  child: TextField(
                    autofillHints: const [AutofillHints.name],
                    onChanged: (value) {
                      if (value.isEmpty) {
                        chatTimer();
                      } else {
                        TimerChange.timer?.cancel();
                      }

                      setState(() {
                        patientHomeScreenController.newDataList =
                            patientHomeScreenController
                                .getSortedPatientChatListModel.value.data!
                                .where(
                                  (SortedPatientChat sortedPatientChat) =>
                                      "${sortedPatientChat.doctorFirstName?.toLowerCase()}${sortedPatientChat.doctorLastName?.toLowerCase()}"
                                          .toString()
                                          .toLowerCase()
                                          .replaceAll(" ", "")
                                          .contains(
                                            value
                                                .toString()
                                                .toLowerCase()
                                                .replaceAll(" ", ""),
                                          ),
                                )
                                .toList();
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: kColorBlue, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 0.5),
                      ),
                      filled: true,
                      fillColor: Colors.grey[250],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                      hintText:
                          Translate.of(context)?.translate('search_messages'),
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 22),
                    ),
                    cursorWidth: 1,
                    maxLines: 1,
                  ),
                ),
                Obx(() {
                  if (patientHomeScreenController.isChatListFirst.value ==
                      true) {
                    return Expanded(
                        // child: Center(
                        //   child: CircularProgressIndicator(),
                        // ),
                        child: Center(
                      child: Utils.circular(),
                    ));
                  } else if (patientHomeScreenController
                          .getSortedPatientChatListModel.value.apiState ==
                      APIState.COMPLETE_WITH_NO_DATA) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'You Don\'t have any Messages',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else if (patientHomeScreenController
                          .getSortedPatientChatListModel.value.apiState ==
                      APIState.ERROR) {
                    return const Expanded(
                      child: Center(
                        child: Text("Error"),
                      ),
                    );
                  } else {
                    int index1 = 0;

                    index1 = patientHomeScreenController.newDataList
                        .where((element) => element.chatKey == null)
                        .toList()
                        .length;

                    return patientHomeScreenController.newDataList.isEmpty ||
                            (patientHomeScreenController
                                    .newDataList.isNotEmpty &&
                                index1 ==
                                    patientHomeScreenController
                                        .newDataList.length)
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'You Don\'t have any Messages',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: patientHomeScreenController
                                        .newDataList.length,
                                    itemBuilder: (context, int index) {
                                      SortedPatientChat chatListItem;

                                      chatListItem = patientHomeScreenController
                                          .newDataList[index];

                                      if (chatListItem.chatKey == null) {
                                        return const SizedBox();
                                      }

                                      return MessageListItem(
                                        longPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Delete Chat',
                                                    style: TextStyle(
                                                        fontSize: 22)),
                                                content: Text(
                                                    "Are you sure want to delete ${'Dr. ${chatListItem.doctorFirstName ?? ""} ${chatListItem.doctorLastName ?? ""}'}'s chat?",
                                                    style: const TextStyle(
                                                        fontSize: 22)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("No",
                                                        style: TextStyle(
                                                            fontSize: 22)),
                                                    onPressed: () {
                                                      //Put your code here which you want to execute on No button click.
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("Yes",
                                                        style: TextStyle(
                                                            fontSize: 22)),
                                                    onPressed: () {
                                                      patientHomeScreenCtlr
                                                          .deleteChatUserPatient(
                                                              patientId:
                                                                  _userController
                                                                      .user
                                                                      .value
                                                                      .id,
                                                              chatKey:
                                                                  chatListItem
                                                                      .chatKey)
                                                          .then((value) {
                                                        Get.back();
                                                        patientHomeScreenController
                                                            .getSortedPatientChatList();
                                                      });

                                                      if (patientHomeScreenCtlr
                                                              .deletePatientChatUserModel
                                                              .value
                                                              .apiState ==
                                                          APIState.ERROR) {
                                                        Utils.showSnackBar(
                                                            'Chat Delete Failed',
                                                            'Please try again later');
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          /* showModalBottomSheet(
                                              backgroundColor: Colors.transparent,
                                              constraints: BoxConstraints(
                                                  minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  maxHeight: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.285),
                                              context: context,
                                              builder: (context) => Container(
                                                decoration: BoxDecoration(
                                                  color: _isDark
                                                      ? Colors.grey.shade800
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(15),
                                                    topLeft: Radius.circular(15),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.07,
                                                          vertical:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                  0.02),
                                                      child: Text(
                                                        'Dr. ${chatListItem?.doctorFirstName ?? ""} ${chatListItem?.doctorLastName ?? ""}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                              fontSize: 25,
                                                            ),
                                                      ),
                                                    ),
                                                    Divider(height: 0),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.018),
                                                          child: Text(
                                                            "Delete Chat",
                                                            style: TextStyle(
                                                                fontSize: 25),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Are you sure want to delete this chat?",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  patientHomeScreenCtlr
                                                                      .deleteChatUserPatient(
                                                                          patientId:
                                                                              chatListItem
                                                                                  .fromId,
                                                                          chatKey:
                                                                              chatListItem
                                                                                  .chatKey)
                                                                      .then((value) =>
                                                                          Get.back());
                                                                },
                                                                child: Text(
                                                                  "YES",
                                                                ),
                                                              ),
                                                              SizedBox(width: 35),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  "NO",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );*/
                                        },
                                        onTap: () async {
                                          TimerChange.timer?.cancel();
                                          await patientHomeScreenController
                                              .onPatientChatTap(
                                                  index, context, chatListItem);
                                        },
                                        imagePath:
                                            chatListItem.doctorProfilePic ?? "",
                                        name:
                                            'Dr. ${chatListItem.doctorFirstName ?? ""} ${chatListItem.doctorLastName ?? ""}',
                                        message: chatListItem.lastMessage ?? "",
                                        date: chatListItem
                                                .chatDatetime!.isNotEmpty
                                            ? DateFormat('dd/MM/yyyy').format(
                                                Utils.formattedDate(
                                                    "${chatListItem.chatDatetime}"))
                                            : '',
                                        unread:
                                            chatListItem.unreadMessagesCount!,
                                        index: index,
                                        patientHomeScreenController:
                                            patientHomeScreenController,
                                        online: false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                  }
                })
              ],
            ),
          ),
        );
      }),
      // child: Obx(() {
      //   if (patientHomeScreenController
      //           .getSortedPatientChatListModel.value.apiState ==
      //       APIState.COMPLETE) {
      //     return Scaffold(
      //       bottomNavigationBar: tempList.isEmpty || adShow == false
      //           ? SizedBox()
      //           : Container(
      //               height: MediaQuery.of(context).size.height * 0.1,
      //               child: Stack(
      //                 children: [
      //                   Positioned.fill(
      //                     child: GestureDetector(
      //                       onTap: () async {
      //                         print('data');
      //                         // await launch(
      //                         //     '${tempList[randomAd]['url'] ?? tempList[0]['url']}');
      //
      //                         await launchUrl(
      //                           Uri.parse(
      //                               '${tempList[randomAd]['url'] ?? tempList[0]['url']}'),
      //                         );
      //                       },
      //                       child: CachedNetworkImage(
      //                         imageUrl:
      //                             '${tempList[randomAd]['image_url'] ?? tempList[0]['image_url']}',
      //                         fit: BoxFit.fill,
      //                         height: MediaQuery.of(context).size.height * 0.1,
      //                         placeholder: (context, url) => Shimmer.fromColors(
      //                           baseColor: Colors.grey.shade300,
      //                           highlightColor: Colors.grey.shade100,
      //                           child: Container(
      //                             height:
      //                                 MediaQuery.of(context).size.height * 0.15,
      //                             width: MediaQuery.of(context).size.width,
      //                             decoration: BoxDecoration(
      //                               color: Colors.white,
      //                             ),
      //                           ),
      //                         ),
      //                         errorWidget: (context, url, error) =>
      //                             Icon(Icons.error),
      //                       ),
      //                     ),
      //                   ),
      //                   Positioned(
      //                     right: 0,
      //                     top: 0,
      //                     child: IconButton(
      //                       onPressed: () {
      //                         adShow = false;
      //                         setState(() {});
      //                       },
      //                       icon: CircleAvatar(
      //                         maxRadius: 15,
      //                         backgroundColor: Colors.grey.shade700,
      //                         child: Icon(
      //                           Icons.clear,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //       body: Stack(
      //         alignment: Alignment.topCenter,
      //         children: [
      //           patientHomeScreenController.newDataList.isEmpty
      //               ? Center(
      //                   child: Text('No data found'),
      //                 )
      //               : Padding(
      //                   padding: const EdgeInsets.only(top: 75.0),
      //                   child: SingleChildScrollView(
      //                     physics: BouncingScrollPhysics(),
      //                     scrollDirection: Axis.vertical,
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: <Widget>[
      //                         RefreshIndicator(
      //                           onRefresh: patientHomeScreenController
      //                               .getSortedPatientChatList,
      //                           child: ListView.builder(
      //                             physics: NeverScrollableScrollPhysics(),
      //                             shrinkWrap: true,
      //                             itemCount: patientHomeScreenController
      //                                     ?.newDataList?.length ??
      //                                 0,
      //                             itemBuilder: (context, int index) {
      //                               var chatListItem =
      //                                   patientHomeScreenController
      //                                       ?.newDataList[index];
      //
      //                               return MessageListItem(
      //                                 onTap: () async {
      //                                   await patientHomeScreenController
      //                                       .onPatientChatTap(
      //                                           index, context, chatListItem);
      //                                 },
      //                                 imagePath:
      //                                     '${chatListItem?.doctorProfilePic ?? ""}',
      //                                 name:
      //                                     'Dr. ${chatListItem?.doctorFirstName ?? ""} ${chatListItem?.doctorLastName ?? ""}',
      //                                 message:
      //                                     '${chatListItem?.lastMessage ?? ""}',
      //                                 date: chatListItem.chatDatetime.isNotEmpty
      //                                     ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse("${chatListItem?.chatDatetime}"))}'
      //                                     : '',
      //                                 unread: chatListItem?.unreadMessagesCount,
      //                                 index: index,
      //                                 patientHomeScreenController:
      //                                     patientHomeScreenController,
      //                                 online: false,
      //                               );
      //                             },
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //           Padding(
      //             padding: EdgeInsets.all(20),
      //             child: TextField(
      //               autofillHints: [AutofillHints.name],
      //               onChanged: (value) {
      //                 if (value.isEmpty) {
      //                   chatTimer();
      //                 } else {
      //                   print("cancel");
      //                   TimerChange.timer.cancel();
      //                 }
      //                 setState(() {
      //                   patientHomeScreenController.newDataList =
      //                       patientHomeScreenController
      //                           .getSortedPatientChatListModel.value.data
      //                           .where((SortedPatientChat sortedPatientChat) =>
      //                               sortedPatientChat.doctorFirstName
      //                                   .toLowerCase()
      //                                   .contains(value.toLowerCase().trim()))
      //                           .toList();
      //                 });
      //               },
      //               decoration: InputDecoration(
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(50),
      //                   borderSide: BorderSide(color: kColorBlue, width: 0.5),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(50),
      //                   borderSide:
      //                       BorderSide(color: Colors.grey[300], width: 0.5),
      //                 ),
      //                 filled: true,
      //                 fillColor: Colors.grey[250],
      //                 contentPadding: EdgeInsets.symmetric(
      //                   vertical: 10,
      //                   horizontal: 15,
      //                 ),
      //                 prefixIcon: Icon(
      //                   Icons.search,
      //                   color: Colors.grey[400],
      //                   size: 30,
      //                 ),
      //                 hintText:
      //                     Translate.of(context).translate('search_messages'),
      //                 hintStyle:
      //                     TextStyle(color: Colors.grey[400], fontSize: 22),
      //               ),
      //               cursorWidth: 1,
      //               maxLines: 1,
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   } else if (patientHomeScreenController
      //           .getSortedPatientChatListModel.value.apiState ==
      //       APIState.COMPLETE_WITH_NO_DATA) {
      //     return Center(
      //       child: Container(
      //         child: Text('You Don\'t have any Messages'),
      //       ),
      //     );
      //   } else if (patientHomeScreenController
      //           .getSortedPatientChatListModel.value.apiState ==
      //       APIState.ERROR) {
      //     return Center(
      //       child: Text("Error"),
      //     );
      //   } else if (patientHomeScreenController
      //           .getSortedPatientChatListModel.value.apiState ==
      //       APIState.PROCESSING) {
      //     return Container(
      //       child: Center(
      //         child: CircularProgressIndicator(),
      //       ),
      //     );
      //   } else {
      //     return Center(
      //       child: Text(""),
      //     );
      //   }
      // }),
    );
  }

  bool get wantKeepAlive => true;
}

class MessageListItem extends StatelessWidget {
  final Function() onTap;
  final Function()? longPress;
  final String imagePath;
  final String name;
  final String message;
  final String date;
  final int? unread;
  final int index;
  final bool? online;
  final PatientHomeScreenController patientHomeScreenController;

  const MessageListItem(
      {super.key,
      required this.onTap,
      required this.imagePath,
      required this.name,
      required this.message,
      required this.date,
      required this.patientHomeScreenController,
      required this.index,
      this.unread,
      this.online,
      this.longPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: longPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                children: <Widget>[
                  /* CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      imagePath,
                    ),
                    onBackgroundImageError: (context, error) {
                      return Container();
                    },
                  ),*/

                  Utils().patientProfile(imagePath, "", 25),
                  // CircleAvatar(
                  //   radius: 25,
                  //   child: ClipOval(
                  //     child: OctoImage(
                  //       image: CachedNetworkImageProvider(imagePath),
                  //       placeholderBuilder: OctoPlaceholder.blurHash(
                  //         'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //         // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  //       ),
                  //       errorBuilder: OctoError.circleAvatar(
                  //           backgroundColor: Colors.white,
                  //           text: Image.asset(defaultProfileImage)),
                  //       fit: BoxFit.fill,
                  //       height: Get.height * 0.1,
                  //       width: Get.width,
                  //     ),
                  //   ),
                  // ),
                  Visibility(
                    visible: online!,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(1),
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                patientHomeScreenController.getSortedPatientChatListModel.value
                        .data![index].chatDatetime!.isEmpty
                    ? const Text(
                        '',
                        style: TextStyle(
                          color: kColorPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        date,
                        style: const TextStyle(
                          color: kColorPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                Visibility(
                  visible: (unread != 0 && unread != null) ? true : false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kColorPrimary,
                    ),
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
