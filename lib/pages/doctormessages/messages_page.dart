import 'dart:async';
import 'dart:developer' as dev;

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/time.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DoctorMessagesPage extends StatefulWidget {
  const DoctorMessagesPage({super.key});

  @override
  State<DoctorMessagesPage> createState() => _DoctorMessagesPage();
}

class _DoctorMessagesPage extends State<DoctorMessagesPage>
    with WidgetsBindingObserver {
  Timer? timer;
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  final PatientHomeScreenController patientHomeScreenCtlr =
      Get.find<PatientHomeScreenController>();

  final TextEditingController _textController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  AddNewChatMessageController addNewChatMessageController = Get.find();
  GetSortedChatListDoctor? getSortedChatListDoctor;
  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    chatTimer();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      searchFocus.unfocus();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    TimerChange.timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AdsController adsController = Get.find();
  chatTimer() {
    TimerChange().docTimerChange();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   _doctorHomeScreenController.getSortedChatListDoctor();
    // });
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
                  addNewChatMessageController.getSortedChatListDoctor(
                      doctorId: _userController.user.value.id),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  GetBuilder<AddNewChatMessageController>(
                    builder: (controller) {
                      if (controller
                              .getDoctorSortedChatListApiResponse.status ==
                          Status.LOADING) {
                        // return Center(child: CircularProgressIndicator());
                        return Center(
                          child: Utils.circular(),
                        );
                      }
                      if (controller
                              .getDoctorSortedChatListApiResponse.status ==
                          Status.ERROR) {
                        return const Center(child: Text(''));
                      }
                      getSortedChatListDoctor =
                          controller.getDoctorSortedChatListApiResponse.data;

                      if (controller.getDoctorSortedChatListApiResponse.data ==
                          null) {
                        return const Center(child: Text(''));
                      }
                      if (controller
                              .getDoctorSortedChatListApiResponse.status ==
                          Status.COMPLETE) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: getSortedChatListDoctor!
                                      .doctorChatList!.isEmpty ||
                                  controller.getDoctorSortedChatListApiResponse
                                          .data ==
                                      null
                              ? Center(
                                  child: Text(
                                  'You Don\'t have any Messages',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ))
                              : ListView.builder(
                                  padding: const EdgeInsets.only(top: 10),
                                  itemCount: getSortedChatListDoctor
                                          ?.doctorChatList?.length ??
                                      0,
                                  itemBuilder: (context, int index) {
                                    ShortedDoctorChat doctorChat =
                                        getSortedChatListDoctor!
                                            .doctorChatList![index];

                                    return MessageListItem(
                                      longPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete Chat'),
                                              content: Text(
                                                  "Are you sure want to delete ${doctorChat.patientFirstName ?? ""} ${doctorChat.patientLastName ?? ""}'s chat?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("YES"),
                                                  onPressed: () {
                                                    patientHomeScreenCtlr
                                                        .deleteChatUserDoctor(
                                                            doctorId:
                                                                _userController
                                                                    .user
                                                                    .value
                                                                    .id,
                                                            chatKey: doctorChat
                                                                .chatKey)
                                                        .then((value) =>
                                                            Get.back());

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
                                                TextButton(
                                                  child: const Text("NO"),
                                                  onPressed: () {
                                                    //Put your code here which you want to execute on No button click.
                                                    Navigator.of(context).pop();
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
                                        // _doctorHomeScreenController.chatKey.value =
                                        //     _doctorChat?.chatKey ?? "";
                                        // _doctorHomeScreenController.patientName.value =
                                        //     _doctorChat?.patientFirstName ?? "";
                                        // _doctorHomeScreenController.patientLastName.value =
                                        //     _doctorChat?.patientLastName ?? "";
                                        // _doctorHomeScreenController.toId.value =
                                        //     _doctorChat?.patientId ?? "";

                                        TimerChange.timer?.cancel();
                                        _doctorHomeScreenController
                                            .doctorChat.value = doctorChat;
                                        var data = await Navigator.of(context)
                                            .pushNamed(Routes.doctorchatDetail);
                                        if (data == null) {
                                          chatTimer();
                                        }
                                      },
                                      imagePath: doctorChat
                                                  .patientSocialProfilePic !=
                                              null
                                          ? '${doctorChat.patientSocialProfilePic}'
                                          : doctorChat.patientProfilePic ?? "",
                                      name:
                                          '${doctorChat.patientFirstName ?? ""} ${doctorChat.patientLastName ?? ""}',
                                      message: doctorChat.lastMessage ?? "",
                                      date:

                                          //_doctorChat.chatDatetime.isNotEmpty ||
                                          doctorChat.chatDatetime != null
                                              ? DateFormat('dd/MM/yyyy').format(
                                                  Utils.formattedDate(
                                                      "${doctorChat.chatDatetime}"))
                                              : '',
                                      unread: doctorChat.unreadMessagesCount!,
                                      online: false,
                                      index: index,
                                    );
                                  },
                                ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      autofillHints: const [AutofillHints.name],
                      controller: _textController,
                      onChanged: (value) async {
                        dev.log('Value>>>>>>> 1 $value');
                        dev.log('Value>>>>>>> 2 ${_textController.text}');
                        if (value.isEmpty) {
                          chatTimer();
                        } else if (getSortedChatListDoctor!
                            .doctorChatList!.isEmpty) {
                          await addNewChatMessageController
                              .getSortedChatListDoctor(
                                  doctorId: _userController.user.value.id);
                          setState(() {
                            getSortedChatListDoctor?.doctorChatList =
                                getSortedChatListDoctor?.doctorChatList?.where(
                                    (ShortedDoctorChat shortedDoctorChat) {
                              String data =
                                  '${shortedDoctorChat.patientFirstName} ${shortedDoctorChat.patientLastName}';
                              dev.log(
                                  'shortedDoctorChat.patientFirstName $value');
                              return data
                                  .toLowerCase()
                                  .contains(value.toLowerCase().trim());
                            }).toList();
                            dev.log(
                                'getSortedChatListDoctor.doctorChatList ${getSortedChatListDoctor?.doctorChatList}');
                          });
                        } else {
                          dev.log("cancel");
                          TimerChange.timer?.cancel();
                        }
                        setState(() {
                          getSortedChatListDoctor?.doctorChatList =
                              getSortedChatListDoctor?.doctorChatList?.where(
                                  (ShortedDoctorChat shortedDoctorChat) {
                            String data =
                                '${shortedDoctorChat.patientFirstName}';
                            dev.log(
                                'shortedDoctorChat.patientFirstName $value');
                            dev.log('data---------->>>>>>>>$data');
                            return "${shortedDoctorChat.patientFirstName} ${shortedDoctorChat.patientLastName}"
                                .toString()
                                .toLowerCase()
                                .replaceAll(" ", "")
                                .contains(value
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll(" ", ""));
                          }).toList();
                          dev.log(
                              'getSortedChatListDoctor.doctorChatList ${getSortedChatListDoctor?.doctorChatList}');
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
                ],
              ),
            ),
          );
        }));
  }

  bool get wantKeepAlive => true;
}

class MessageListItem extends StatelessWidget {
  final Function() onTap;
  final String imagePath;
  final String name;
  final String message;
  final String date;
  final int? unread;
  final int index;
  final bool? online;
  final Function()? longPress;

  const MessageListItem(
      {super.key,
      required this.onTap,
      required this.imagePath,
      required this.name,
      required this.message,
      required this.date,
      required this.index,
      this.unread,
      this.online,
      this.longPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: longPress,
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
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      imagePath,
                    ),
                    onBackgroundImageError: (context, error) {
                      return Container();
                    },
                  ),*/
                  /*CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: OctoImage(
                        image: CachedNetworkImageProvider(imagePath ??
                            'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                          // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                        ),
                        errorBuilder: OctoError.circleAvatar(
                          backgroundColor: Colors.white,
                          text: Image.asset(defaultProfileImage),
                        ),
                        fit: BoxFit.fill,
                        height: Get.height,
                        width: Get.width,
                      ),
                    ),
                  ),*/

                  Utils().patientProfile(imagePath, "", 25),
                  // CircleAvatar(
                  //   radius: 25,
                  //   backgroundColor: Colors.transparent,
                  //   child: CachedNetworkImage(
                  //     imageUrl: imagePath,
                  //     imageBuilder: (context, imageProvider) {
                  //       return CircleAvatar(
                  //         radius: 25,
                  //         backgroundImage: imageProvider,
                  //       );
                  //     },
                  //     placeholder: (context, url) {
                  //       return Container(
                  //         height: 50,
                  //         width: 50,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: Colors.grey.withOpacity(0.4),
                  //         ),
                  //       );
                  //     },
                  //     errorWidget: (context, url, error) {
                  //       return CircleAvatar(
                  //         radius: 25,
                  //         backgroundImage: AssetImage(
                  //           defaultProfileImage,
                  //         ),
                  //         backgroundColor: Colors.grey.withOpacity(0.2),
                  //       );
                  //     },
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
                Text(
                  date,
                  style: const TextStyle(
                    color: kColorPrimary,
                    fontSize: 16,
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
                        fontSize: 16,
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
