import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:developer';
import 'dart:io';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/doctor_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/ResponseModel/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/doctormessages/msg_show_screen.dart';
import 'package:united_natives/pages/myPatientMessageList/patient_information_screen.dart';
import 'package:united_natives/pages/myPatientMessageList/upload_screen.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DoctorMessagesDetailPage extends StatefulWidget {
  const DoctorMessagesDetailPage({super.key});

  @override
  State<DoctorMessagesDetailPage> createState() =>
      _DoctorMessagesDetailPageState();
}

class _DoctorMessagesDetailPageState extends State<DoctorMessagesDetailPage> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>()..getAllChatMessagesDoctor();

  final UserController _userController = Get.find<UserController>();
  AddNewChatMessageController addMsgController =
      Get.put(AddNewChatMessageController());
  final TextEditingController messageController = TextEditingController();

  final ScrollController _controller = ScrollController();

  final _formKey = GlobalKey<FormState>();

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  LogOutController logOutController = Get.put(LogOutController());

  final ImagePicker _picker = ImagePicker();
  FilePickerResult? result;
  File? imageW;
  File? pdf;

  Future getImage({ImageSource? imgSource}) async {
    final pickedFile =
        await _picker.pickImage(source: imgSource ?? ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageW = File(pickedFile.path);
        imageW != null
            ? Get.to(ChatUploadScreen(
                image: imageW!,
                type: 'image',
                loginType: 'doctor',
              ))
            : d.log('imageW  $imageW');
        d.log(('imageW  $imageW'));
      } else {
        d.log(('No image selected.'));
      }
    });
  }

  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                   leading: new Icon(Icons.photo_library),
  //                   title: new Text('Photo Library'),
  //                   onTap: () {
  //                     getImage(imgSource: ImageSource.gallery);
  //
  //                     Navigator.of(context).pop();
  //                   }),
  //               ListTile(
  //                 leading: const Icon(Icons.photo_camera),
  //                 title: const Text('Camera'),
  //                 onTap: () {
  //                   getImage(imgSource: ImageSource.camera);
  //
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    allMessage();
    getChatStatus();
    super.initState();
  }

  getChatStatus() async {
    // await logOutController.getChatStatus(
    //   id: patientHomeScreenController.doctorId.isNotEmpty
    //       ? patientHomeScreenController.doctorId.string
    //       : widget.doctor.id,
    // );
    Map<String, String> header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      // "Content-Type": "application/json",
    };

    final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl + Constants.chatStatus}${_doctorHomeScreenController.doctorChat.value.patientId}'),
        headers: header);
    d.log(
        'response1?:>>>> ${"${Constants.baseUrl + Constants.chatStatus}${_doctorHomeScreenController.doctorChat.value.patientId}"}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
  // Future<void> getChatStatus() async {
  //   await logOutController.getChatStatus(
  //     id: _doctorHomeScreenController?.doctorChat?.value?.patientId,
  //   );
  //
  // }

  void allMessage() async {
    setState(() {
      _doctorHomeScreenController.isLoadingOne = true;
    });
    addMsgController.allNewMessageApiResponse.data = null;
    try {
      _doctorHomeScreenController.getAllChatMessages(
          chatKey: _doctorHomeScreenController.doctorChat.value.chatKey,
          id: _userController.user.value.id);
    } catch (e) {
      d.log('e==========>>>>>$e');
    }
  }

  List<DoctorChat> doctorChat = [];
  // List<DoctorChat> tempMsg = [];

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
          leading: GestureDetector(
              onTap: () {
                _doctorHomeScreenController.endTimer();
                _doctorHomeScreenController.isLoadingOne = true;
                setState(() {});
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Row(
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: <Widget>[
                    // CircleAvatar(
                    //   radius: 18,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage: NetworkImage(
                    //       "${_doctorHomeScreenController?.doctorChat?.value?.patientProfilePic ?? _doctorHomeScreenController?.doctorChat?.value?.patientSocialProfilePic}"),
                    //   onBackgroundImageError: (context, error) {
                    //     return Container();
                    //   },
                    // ),

                    Builder(builder: (context) {
                      log('_doctorHomeScreenController==========>>>>>${_doctorHomeScreenController.doctorChat.value.patientProfilePic}');

                      return Utils().patientProfile(
                          _doctorHomeScreenController
                                  .doctorChat.value.patientSocialProfilePic ??
                              "",
                          _doctorHomeScreenController
                                  .doctorChat.value.patientProfilePic ??
                              "",
                          25);
                    }),

                    /*CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${_doctorHomeScreenController?.doctorChat?.value?.patientProfilePic.toString().isEmpty ? _doctorHomeScreenController?.doctorChat?.value?.patientSocialProfilePic : _doctorHomeScreenController?.doctorChat?.value?.patientProfilePic}",
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: imageProvider,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              defaultProfileImage,
                            ),
                            backgroundColor: Colors.grey.withOpacity(0.2),
                          );
                        },
                      ),
                    ),*/
                    FutureBuilder(
                      future: getChatStatus(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData.isBlank!) {
                            return const SizedBox();
                          }
                          if (snapshot.hasData) {
                            return snapshot.data['status'] == 'Success'
                                ? snapshot.data['data']['is_online'] == true
                                    ? Align(
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
                                      )
                                    : const SizedBox()
                                : const SizedBox();
                          }
                          return const SizedBox();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_doctorHomeScreenController.doctorChat.value.patientFirstName ?? ""} ${_doctorHomeScreenController.doctorChat.value.patientLastName ?? ""}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                  ),
                  FutureBuilder(
                    future: getChatStatus(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData.isBlank!) {
                          return const SizedBox();
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data['status'] == 'Fail') {
                            return const SizedBox();
                          } else {
                            String lastSeen =
                                snapshot.data['data']['last_seen'] ?? "";

                            if (lastSeen.isNotEmpty) {
                              // String date =
                              //     "${"13-06-2024 11:16:49".split(" ")[0].split("-")[2]}-${lastSeen.split(" ")[0].split("-")[1]}-${lastSeen.split(" ")[0].split("-")[0]}";
                              // String time = lastSeen.split(" ")[1];
                              // DateTime currentTime = DateTime.now();
                              //
                              // print('currentTime==========>>>>>${currentTime}');
                              //
                              // DateTime endTime =
                              //     DateTime.parse("$date $time.00000");
                              //
                              // print('endTime==========>>>>>${endTime}');
                              //
                              // dynamic diff =
                              //     currentTime.difference(endTime).inDays;
                              //
                              // print('diff==========>>>>>${diff}');
                              // print(
                              //     "DIFFERENCE ${diff == 1 ? 'today' : '$diff days'}");

                              var data1 =
                                  Utils.timeAgo(Utils.formattedDate(lastSeen));

                              return Text(
                                snapshot.data['data']['is_online'] == true
                                    ? 'Active now'
                                    // : 'Last seen at ${diff < 1 ? ' ${currentTime.difference(endTime).inMinutes < 60 ? '${currentTime.difference(endTime).inMinutes} min ago' : '${currentTime.difference(endTime).inHours} hours ago'}' : '$date'}',
                                    : data1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontSize: 16),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        }
                        return const SizedBox();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      return const SizedBox();
                    },
                  )
                ],
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Get.to(PatientDetailSCreen(
                  profilePic: _doctorHomeScreenController
                          .doctorChat.value.patientProfilePic ??
                      "",
                  fullName: _doctorHomeScreenController
                          .doctorChat.value.patientFirstName ??
                      "",
                  lastName: _doctorHomeScreenController
                          .doctorChat.value.patientLastName ??
                      "",
                  tribalStatus: _doctorHomeScreenController
                          .doctorChat.value.tribalStatus ??
                      "",
                  insuranceStatus: _doctorHomeScreenController
                          .doctorChat.value.insuranceEligibility ??
                      "",
                  gender:
                      _doctorHomeScreenController.doctorChat.value.gender ?? "",
                  email:
                      _doctorHomeScreenController.doctorChat.value.mail ?? '',
                  bloodGroup:
                      _doctorHomeScreenController.doctorChat.value.bloodGroup ??
                          "",
                ));
              },
              icon: const Icon(
                Icons.info,
                size: 30,
              ),
            ),
          ],
        ),
        body: PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            _doctorHomeScreenController.isLoadingOne = true;
            _doctorHomeScreenController.endTimer();
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: GetBuilder<DoctorHomeScreenController>(
                  builder: (dcontroller) {
                    return dcontroller.isLoadingOne == true
                        // ? Center(child: CircularProgressIndicator())
                        ? Center(
                            child: Utils.circular(),
                          )
                        : GetBuilder<AddNewChatMessageController>(
                            builder: (controller) {
                              if (controller.allNewMessageApiResponse.status ==
                                  Status.LOADING) {
                                // return Center(
                                //     child: CircularProgressIndicator());
                                return Center(
                                  child: Utils.circular(),
                                );
                              }
                              if (controller.allNewMessageApiResponse.status ==
                                  Status.ERROR) {
                                return const Center(
                                    child: Text('Server error'));
                              }
                              GetAllChatMessagesDoctor responseModel =
                                  controller.allNewMessageApiResponse.data;

                              if (responseModel.doctorChatList!.isEmpty) {
                                return Center(
                                    child: Text(
                                  'You Don\'t have any Messages',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ));
                              }

                              doctorChat = responseModel
                                  .doctorChatList!.reversed
                                  .toList();

                              // log('tempMsg==========>>>>>${tempMsg.map((e) => e.message)}');

                              // doctorChat.insertAll(0, tempMsg);

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  reverse: true,
                                  controller: _controller,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 15,
                                  ),
                                  itemCount:
                                      responseModel.doctorChatList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    DoctorChat doctorChat =
                                        this.doctorChat[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: MessageItem(
                                        onLongPress: () {
                                          _openBottomSheet(
                                            context,
                                            () {
                                              _doctorHomeScreenController
                                                  .deleteDoctorMessage(
                                                      doctorChat.id.toString())
                                                  .then((value) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Message deleted successfully",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors
                                                        .grey.shade800
                                                        .withOpacity(0.9),
                                                    textColor: Colors.white,
                                                    fontSize: 15.5);
                                                return null;
                                              });
                                            },
                                          );
                                        },
                                        attachment: doctorChat.attachment!,
                                        send: doctorChat.fromType == "doctor",
                                        message: doctorChat.message.toString(),
                                        time: doctorChat.created!.isEmpty
                                            ? ""
                                            : DateFormat('hh:mm a').format(
                                                Utils.formattedDate(doctorChat
                                                    .created
                                                    .toString())),
                                        networkImage: _userController
                                                .user.value.profilePic ??
                                            "",
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              /*    Expanded(
                  child: Obx(() {
                    if (_doctorHomeScreenController
                            .getAllChatMessagesDoctorModel.value.apiState ==
                        APIState.COMPLETE) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.separated(
                            controller: _controller,
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            itemCount: _doctorHomeScreenController
                                    ?.getAllChatMessagesDoctorModel
                                    ?.value
                                    ?.doctorChatList
                                    ?.length ??
                                0,
                            itemBuilder: (context, index) {
                              DoctorChat _doctorChat = _doctorHomeScreenController
                                  ?.getAllChatMessagesDoctorModel
                                  ?.value
                                  ?.doctorChatList[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: MessageItem(
                                  attachment: _doctorChat?.attachment,
                                  send: _doctorChat?.fromType == "doctor",
                                  message: _doctorChat?.message.toString() ?? "",
                                  time:
                                      '${DateFormat('hh:mm a').format(DateTime.parse(_doctorChat?.created.toString()))}',
                                  networkImage:
                                      '${_userController?.user?.value?.profilePic ?? ""}',
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (_doctorHomeScreenController
                            .getAllChatMessagesDoctorModel.value.apiState ==
                        APIState.COMPLETE_WITH_NO_DATA) {
                      return Center(
                        child: Container(
                          child: Text('You Don\'t have any Messages'),
                        ),
                      );
                    } else if (_doctorHomeScreenController
                            .getAllChatMessagesDoctorModel.value.apiState ==
                        APIState.ERROR) {
                      return Center(child: Text("Error"));
                    } else if (_doctorHomeScreenController
                            .getAllChatMessagesDoctorModel.value.apiState ==
                        APIState.PROCESSING) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(""),
                      );
                    }
                  }),
                ),*/
              SafeArea(
                child: Container(
                  // height: 70,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 0.5),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.attach_file,
                      //     size: 25,
                      //   ),
                      // ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.camera_alt,
                      //     size: 25,
                      //   ),
                      // ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  minLines: 1,
                                  maxLines: 4,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      _doctorHomeScreenController
                                          .isLoading.value = false;
                                      return 'Enter Message';
                                    }
                                    return null;
                                  },
                                  // onTap: () {
                                  //   Timer(
                                  //       Duration(milliseconds: 100),
                                  //       () => _controller.jumpTo(_controller
                                  //           .position.maxScrollExtent));
                                  // },
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[250],
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    hintText: 'Enter message',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400], fontSize: 24),
                                  ),
                                  autofocus: false,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        _isDark ? Colors.white : kColorDarkBlue,
                                  ),
                                  cursorWidth: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // IconButton(
                      //     icon: Icon(Icons.image),
                      //     onPressed: () {
                      //       _showPicker(context);
                      //     }),
                      // IconButton(
                      //     icon: Icon(Icons.picture_as_pdf_outlined),
                      //     onPressed: () async {
                      //       result = await FilePicker.platform.pickFiles(
                      //         type: FileType.custom,
                      //         allowedExtensions: ['pdf'],
                      //       );
                      //       pdf = File(result.paths[0]);
                      //       pdf != null
                      //           ? Get.to(ChatUploadScreen(
                      //               type: 'pdf',
                      //               pdf: pdf,
                      //               loginType: 'doctor',
                      //             ))
                      //           : print('imageW  $imageW');
                      //       print("RESULT:::::?${result.paths[0]}");
                      //     }),
                      IconButton(
                        onPressed: () async {
                          if (messageController.text.isNotEmpty ||
                              imageW != null ||
                              pdf != null) {
                            String msg = messageController.text.trim();
                            messageController.text = "";

                            // DoctorChat value = DoctorChat(
                            //     message: msg,
                            //     fromType: "doctor",
                            //     toId: "",
                            //     modified: "",
                            //     fromId: "",
                            //     created: "",
                            //     chatKey: "",
                            //     attachment: "",
                            //     id: "",
                            //     toType: "");

                            // tempMsg.insert(0, value);

                            _doctorHomeScreenController.isLoading.value = true;

                            await _doctorHomeScreenController
                                .createNewMessageDoctor(
                                    message: msg,
                                    chatKey: _doctorHomeScreenController
                                        .doctorChat.value.chatKey,
                                    fromId: _userController.user.value.id,
                                    fromType: "doctor",
                                    toId: _doctorHomeScreenController
                                            .doctorChat.value.patientId ??
                                        "",
                                    toType: "patient",
                                    attachment: imageW ?? pdf);
                            msg = "";

                            // tempMsg.clear();

                            await _doctorHomeScreenController
                                .getAllChatMessagesDoctor();

                            _doctorHomeScreenController.isLoading.value = false;

                            // Timer(
                            //     Duration(milliseconds: 100),
                            //     () => _controller.jumpTo(
                            //         _controller.position.maxScrollExtent));
                          }
                        },
                        icon: /* Obx(
                          () => */ /*_doctorHomeScreenController.isLoading.value
                              ? CircularProgressIndicator()
                              // ? Center(
                              //     child: Utils.circular(),
                              //   )
                              :*/
                            const Icon(
                          Icons.send,
                          size: 25,
                        ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      );
    });
  }

  _openBottomSheet(BuildContext context, Function() onTap) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
                title: Text(
                  Translate.of(context)!.translate('Delete Message'),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: onTap,
              ),
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  size: 20,
                ),
                title: Text(
                  Translate.of(context)!.translate('cancel'),
                  style: TextStyle(
                    color: _isDark ? Colors.blue : const Color(0xff4a4a4a),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class MessageItem extends StatelessWidget {
  final bool send;
  final String message;
  final String time;
  final String networkImage;
  final String? attachment;
  final Function()? onLongPress;

  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  MessageItem(
      {super.key,
      this.attachment,
      required this.send,
      required this.message,
      required this.time,
      required this.networkImage,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    String? attach = attachment?.split('.').last;
    return InkWell(
      onLongPress: send ? onLongPress : null,
      child: Builder(
        builder: (context) {
          if (message == "" && attachment == "") {
            return const SizedBox();
          } else {
            return message != "" && attachment != ""
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment:
                        send ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                          visible: !send,
                          child: Utils().patientProfile(
                              _doctorHomeScreenController
                                      .doctorChat.value.patientProfilePic ??
                                  "",
                              _doctorHomeScreenController.doctorChat.value
                                      .patientSocialProfilePic ??
                                  "",
                              10)
                          // CircleAvatar(
                          //   radius: 10,
                          //   backgroundColor: Colors.transparent,
                          //   backgroundImage: NetworkImage(
                          //       _doctorHomeScreenController
                          //               .doctorChat.value.patientProfilePic ??
                          //           ''),
                          // ),
                          ),
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.only(
                              left: !send ? 5 : (w / 2) - 80,
                              right: send ? 5 : (w / 2) - 80,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(send ? 20 : 0),
                                bottomRight: Radius.circular(send ? 0 : 20),
                              ),
                              color:
                                  send ? const Color(0xffeaf2fe) : kColorBlue,
                            ),
                            child: attach != 'pdf'
                                ? Column(
                                    crossAxisAlignment: !send
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(MessageShowScreen(
                                            file:
                                                'https://unhbackend.com/uploads/chat/$attachment',
                                            type: 'image',
                                          ));
                                        },
                                        child: Container(
                                          height: h * 0.2,
                                          width: w * 0.5,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20),
                                                topRight:
                                                    const Radius.circular(20),
                                                bottomLeft: Radius.circular(
                                                    send ? 20 : 0),
                                                bottomRight: Radius.circular(
                                                    send ? 0 : 20),
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      'https://unhbackend.com/uploads/chat/$attachment'),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      SelectableText(
                                        message,
                                        style: TextStyle(
                                          color: send
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      SelectableText(
                                        time,
                                        style: TextStyle(
                                          color: send
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(MessageShowScreen(
                                            file:
                                                'https://unhbackend.com/uploads/chat/$attachment',
                                            type: 'pdf',
                                          ));
                                        },
                                        child: Container(
                                            height: h * 0.2,
                                            width: w * 0.5,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20),
                                                topRight:
                                                    const Radius.circular(20),
                                                bottomLeft: Radius.circular(
                                                    send ? 20 : 0),
                                                bottomRight: Radius.circular(
                                                    send ? 0 : 20),
                                              ),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/pdf.png',
                                                height: 50,
                                                width: 50,
                                              ),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      SelectableText(
                                        message,
                                        style: TextStyle(
                                          color: send
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      SelectableText(
                                        time,
                                        style: TextStyle(
                                          color: send
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )),
                      ),
                      Visibility(
                          visible: send,
                          child: Utils()
                              .patientProfile(networkImage, networkImage, 10)
                          // CircleAvatar(
                          //   radius: 10,
                          //   backgroundColor: Colors.transparent,
                          //   backgroundImage: NetworkImage(networkImage),
                          // ),
                          ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment:
                        send ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                          visible: !send,
                          child: Utils().patientProfile(
                              _doctorHomeScreenController
                                      .doctorChat.value.patientProfilePic ??
                                  "",
                              _doctorHomeScreenController.doctorChat.value
                                      .patientSocialProfilePic ??
                                  "",
                              10)
                          // CircleAvatar(
                          //   radius: 10,
                          //   backgroundColor: Colors.transparent,
                          //   backgroundImage: NetworkImage(
                          //       _doctorHomeScreenController
                          //               .doctorChat.value.patientProfilePic ??
                          //           ''),
                          // ),
                          ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: !send ? 5 : (w / 2) - 80,
                            right: send ? 5 : (w / 2) - 80,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(send ? 20 : 0),
                              bottomRight: Radius.circular(send ? 0 : 20),
                            ),
                            color: send ? const Color(0xffeaf2fe) : kColorBlue,
                          ),
                          child: message == ""
                              ? attach != 'pdf'
                                  ? Column(
                                      crossAxisAlignment: !send
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(MessageShowScreen(
                                              file:
                                                  "https://unhbackend.com/uploads/chat/$attachment",
                                              type: 'image',
                                            ));
                                          },
                                          child: Container(
                                            height: h * 0.2,
                                            width: w * 0.5,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(20),
                                                  topRight:
                                                      const Radius.circular(20),
                                                  bottomLeft: Radius.circular(
                                                      send ? 20 : 0),
                                                  bottomRight: Radius.circular(
                                                      send ? 0 : 20),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://unhbackend.com/uploads/chat/$attachment'),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        SelectableText(
                                          time,
                                          style: TextStyle(
                                            color: send
                                                ? kColorDarkBlue
                                                : Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: h * 0.2,
                                          width: w * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20),
                                              topRight:
                                                  const Radius.circular(20),
                                              bottomLeft: Radius.circular(
                                                  send ? 20 : 0),
                                              bottomRight: Radius.circular(
                                                  send ? 0 : 20),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(MessageShowScreen(
                                                file:
                                                    'https://unhbackend.com/uploads/chat/$attachment',
                                                type: 'pdf',
                                              ));
                                            },
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/pdf.png',
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        SelectableText(
                                          time,
                                          style: TextStyle(
                                            color: send
                                                ? kColorDarkBlue
                                                : Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: SelectableText(
                                        message,
                                        style: TextStyle(
                                          color: send
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SelectableText(
                                      time,
                                      style: TextStyle(
                                        color: send
                                            ? kColorDarkBlue
                                            : Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Visibility(
                          visible: send,
                          child: Utils()
                              .patientProfile(networkImage, networkImage, 10)
                          // CircleAvatar(
                          //   radius: 10,
                          //   backgroundColor: Colors.transparent,
                          //   backgroundImage: NetworkImage(networkImage),
                          // ),
                          ),
                    ],
                  );
          }
        },
      ),
    );
  }
}
