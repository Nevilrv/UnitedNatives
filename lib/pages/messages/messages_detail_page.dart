import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/model/getSorted_patient_chatList_model.dart';
import 'package:doctor_appointment_booking/model/get_all_doctor.dart';
import 'package:doctor_appointment_booking/model/get_all_patient_messagelist_model.dart';
import 'package:doctor_appointment_booking/model/get_new_message_doctor_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/doctormessages/msg_show_screen.dart';
import 'package:doctor_appointment_booking/pages/myPatientMessageList/upload_screen.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/add_new_chat_message_view_model.dart';
import 'package:doctor_appointment_booking/viewModel/log_out_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class MessagesDetailPage extends StatefulWidget {
  final Doctor doctor;
  final SortedPatientChat sortedPatientChat;
  final UserController _userController = Get.find<UserController>();
  MessagesDetailPage({super.key, this.doctor, this.sortedPatientChat}) {
    final PatientHomeScreenController patientHomeScreenController =
        Get.find<PatientHomeScreenController>();
    log('doctor.chatKey==========>>>>>${doctor.chatKey ?? ""}');
    if (doctor.chatKey != null &&
        doctor.chatKey != "" &&
        doctor.chatKey.isNotEmpty) {
      patientHomeScreenController.getAllChatMessages(
          doctor.chatKey ?? "", _userController.user.value.id);
    }
  }

  @override
  _MessagesDetailPageState createState() => _MessagesDetailPageState();
}

class _MessagesDetailPageState extends State<MessagesDetailPage> {
  DoctorSpecialities doctorDetails;

  BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());

  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  final UserController _userController = Get.find<UserController>();

  final TextEditingController messageController = TextEditingController();

  ScrollController _controller = ScrollController();

  RxBool _isLoading = false.obs;

  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  LogOutController logOutController = Get.put(LogOutController());
  GetAllPatientChatMessages responseModel = GetAllPatientChatMessages();
  ImagePicker _picker = ImagePicker();
  FilePickerResult result;
  File imageW;
  File pdf;
  String chatKey;
  AddNewChatMessageController addNewChatMessageController = Get.find();

  Future getImage({ImageSource imgSource}) async {
    final pickedFile = await _picker.pickImage(source: imgSource);

    setState(() {
      if (pickedFile != null) {
        imageW = File(pickedFile.path);
        imageW != null
            ? Get.to(ChatUploadScreen(
                image: imageW,
                type: 'image',
                loginType: 'patient',
              ))
            : print('imageW  $imageW');
      } else {
        print('=====>>>>> No image selected.');
      }
    });
  }

  GetAllPatientChatMessages getAllPatientChatMessages;
  // void _showPicker(context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext bc) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: <Widget>[
  //             ListTile(
  //                 leading: new Icon(Icons.photo_library),
  //                 title: new Text('Photo Library'),
  //                 onTap: () {
  //                   getImage(imgSource: ImageSource.gallery);
  //                   Navigator.of(context).pop();
  //                 }),
  //             ListTile(
  //               leading: const Icon(Icons.photo_camera),
  //               title: const Text('Camera'),
  //               onTap: () {
  //                 getImage(imgSource: ImageSource.camera);
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    // _controller.jumpTo(_controller.position.maxScrollExtent);
    chatKey = widget.doctor.chatKey;
    print('ChatKeyChatKeyChatKey  $chatKey');
    addNewChatMessageController.allNewMessagePatientApiResponse.data = null;
    // changeScroll();
    // FirstMessage();
    _bookAppointmentController.getSpecialities(_isLoading).then((value) {
      _bookAppointmentController.getDoctorSpecialities('', context);
    });
    // print(
    //     'patientHomeScreenController.chatKey.value1  ${widget.sortedPatientChat.chatKey}');
    // //
    // patientHomeScreenController
    //     .getAllChatMessages(widget.sortedPatientChat.chatKey);
    getChatStatus();
    super.initState();
  }

  @override
  void dispose() {
    addNewChatMessageController.allNewMessagePatientApiResponse.data = null;
    patientHomeScreenController.endTimer();

    widget.doctor.chatKey != null &&
            widget.doctor.chatKey != "" &&
            widget.doctor.chatKey.isNotEmpty
        ? patientHomeScreenController.timer.cancel()
        : SizedBox();
    Prefs.clearFilter();
    super.dispose();
  }

  firstMessage() async {
    if (widget.doctor.chatKey != null &&
        widget.doctor.chatKey != "" &&
        widget.doctor.chatKey.isNotEmpty) {
      addNewChatMessageController.allNewMessagePatientApiResponse.data = null;
    } else {
      // responseModel.patientChatList.clear();
      addNewChatMessageController.allNewMessagePatientApiResponse.data = null;
    }
  }

  getChatStatus() async {
    // await logOutController.getChatStatus(
    //   id: patientHomeScreenController.doctorId.isNotEmpty
    //       ? patientHomeScreenController.doctorId.string
    //       : widget.doctor.id,
    // );
    Map<String, String> header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      "Content-Type": "application/json",
    };
    final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl + Constants.chatStatus}${patientHomeScreenController.doctorId.isNotEmpty ? patientHomeScreenController.doctorId.string : widget.doctor.id}'),
        headers: header);
    print(
        'response1?:>>>> ${"${Constants.baseUrl + Constants.chatStatus}${patientHomeScreenController.doctorId.isNotEmpty ? patientHomeScreenController.doctorId.string : widget.doctor.id}"}');
    if (response.statusCode == 200) {
      print('response1?:>>>> ${response.body}');

      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  void changeScroll() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
      // _controller.animateTo(_controller.position.maxScrollExtent,
      //     duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
    // _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  final _formKey = GlobalKey<FormState>();
  List<PatientChat> patientData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            Prefs.clearFilter();
            Get.back();
            await patientHomeScreenController.endTimer();
            widget.doctor.chatKey != null &&
                    widget.doctor.chatKey != "" &&
                    widget.doctor.chatKey.isNotEmpty
                ? patientHomeScreenController.timer.cancel()
                : SizedBox();
          },
        ),
        title: Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: Stack(
                children: <Widget>[
                  Utils().patientProfile(
                      patientHomeScreenController?.doctorProfile ?? "",
                      patientHomeScreenController?.doctorSocialProfile ?? "",
                      25),

                  /*CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl: patientHomeScreenController?.doctorProfile ??
                          patientHomeScreenController?.doctorSocialProfile,
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

                  // CircleAvatar(
                  //   radius: 25,
                  //   child: ClipOval(
                  //     clipBehavior: Clip.hardEdge,
                  //     child: OctoImage(
                  //       image: CachedNetworkImageProvider(
                  //           patientHomeScreenController?.doctorProfile ??
                  //               patientHomeScreenController
                  //                   ?.doctorSocialProfile ??
                  //               'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                  //       placeholderBuilder: OctoPlaceholder.blurHash(
                  //         'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //         // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  //       ),
                  //       errorBuilder: OctoError.circleAvatar(
                  //         backgroundColor: Colors.white,
                  //         text: Image.network(
                  //             'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                  //       ),
                  //       fit: BoxFit.fill,
                  //       height: Get.height,
                  //       width: Get.height,
                  //     ),
                  //   ),
                  // ),
                  FutureBuilder(
                    future: getChatStatus(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData.isBlank) {
                          return SizedBox();
                        }
                        if (snapshot.hasData) {
                          return snapshot.data['status'] == 'Success'
                              ? snapshot.data['data']['is_online'] == false
                                  ? SizedBox()
                                  : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(1),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: CircleAvatar(
                                            backgroundColor: Colors.green),
                                      ),
                                    )
                              : SizedBox();
                        }
                        return SizedBox();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox();
                      }
                      return SizedBox();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientHomeScreenController.doctorName.isNotEmpty &&
                          patientHomeScreenController.doctorLastName.isNotEmpty
                      ? 'Dr. ${patientHomeScreenController?.doctorName?.value ?? ""} ${patientHomeScreenController?.doctorLastName?.value ?? ""}'
                      : (widget.doctor?.firstName ?? '') +
                          ' ' +
                          (widget.doctor?.lastName ?? ''),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                FutureBuilder(
                  future: getChatStatus(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData.isBlank) {
                        return SizedBox();
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data['status'] != 'Success' ||
                            snapshot.data['data']['last_seen'] == null) {
                          return SizedBox();
                        } else {
                          print(
                              'snapshot.dadaist_online ${snapshot.data['data']['is_online']}');
                          String lastSeen = snapshot.data['data']['last_seen'];

                          if (lastSeen != null) {
                            // String date =
                            //     "${lastSeen.split(" ")[0].split("-")[2]}-${lastSeen.split(" ")[0].split("-")[1]}-${lastSeen.split(" ")[0].split("-")[0]}";
                            // String time = lastSeen.split(" ")[1];
                            // DateTime currentTime = DateTime.now();
                            // DateTime endTime =
                            //     DateTime.parse("$date $time.00000");
                            // dynamic diff = currentTime.difference(endTime).inDays;
                            // print(
                            //     "DIFFERENCE ${diff == 1 ? 'today' : '$diff days'}");

                            var data1 =
                                "${Utils.timeAgo(Utils.formattedDate(lastSeen))}";

                            return Text(
                              snapshot.data['data']['is_online'] == true
                                  ? 'Active  now'
                                  // : 'Last seen at ${diff < 1 ? ' ${currentTime.difference(endTime).inMinutes < 60 ? '${currentTime.difference(endTime).inMinutes} min ago' : '${currentTime.difference(endTime).inHours} hours ago'}' : '$date'}',

                                  : data1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 18),
                            );
                          } else {
                            return SizedBox();
                          }
                        }
                      }
                      return SizedBox();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox();
                    }
                    return SizedBox();
                  },
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await patientHomeScreenController.endTimer();

              print(_bookAppointmentController
                  .doctorBySpecialitiesModelData.value.doctorSpecialities);
              _bookAppointmentController
                  .doctorBySpecialitiesModelData.value.doctorSpecialities
                  .forEach((element) {
                if (element.firstName ==
                    patientHomeScreenController.doctorName.value) {
                  doctorDetails = element;
                }
              });

              Get.toNamed(Routes.doctorProfile, arguments: doctorDetails);
            },
            icon: Icon(Icons.info, size: 30),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          await patientHomeScreenController.endTimer();
          Prefs.clearFilter();
          return true;
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GetBuilder<AddNewChatMessageController>(
                  builder: (controller) {
                    if (controller.allNewMessagePatientApiResponse.status ==
                        Status.LOADING) {
                      // return Center(child: CircularProgressIndicator());
                      return Center(
                        child: Utils.circular(),
                      );
                    } else if (controller
                            .allNewMessagePatientApiResponse.status ==
                        Status.ERROR) {
                      return Center(child: Text('Server error'));
                    } else
                    // if (controller
                    //       .allNewMessagePatientApiResponse.status ==
                    //   Status.COMPLETE)
                    {
                      responseModel =
                          controller.allNewMessagePatientApiResponse.data;

                      // String tempMsg = jsonEncode(responseModel);
                      // Prefs.setString(Prefs.tempMsg, tempMsg);

                      return ListView.separated(
                        reverse: true,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 15,
                        ),
                        itemCount: responseModel?.patientChatList?.length ?? 0,
                        padding: EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, index) {
                          patientData =
                              responseModel.patientChatList.reversed.toList();

                          PatientChat _patientChat = patientData[index];

                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: MessageItem(
                              onLongPress: () {
                                _openBottomSheet(
                                  context,
                                  () {
                                    patientHomeScreenController
                                        .deleteChatMessagePatient(
                                            patientId:
                                                _userController.user.value.id,
                                            id: _patientChat?.id.toString())
                                        .then(
                                      (value) {
                                        Fluttertoast.showToast(
                                            msg: "Message deleted successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors
                                                .grey.shade800
                                                .withOpacity(0.8),
                                            textColor: Colors.white,
                                            fontSize: 15.5);
                                        return null;
                                      },
                                    );
                                  },
                                );
                              },
                              send: _patientChat?.fromType == "patient"
                                  ? true.obs
                                  : false.obs,
                              message:
                                  _patientChat?.message.toString().obs ?? "",
                              time:
                                  '${DateFormat('hh:mm a').format(Utils.formattedDate("${_patientChat?.created.toString()}"))}',
                              networkImage:
                                  _userController.user.value.profilePic,
                              attachment: _patientChat.attachment,
                            ),
                          );
                        },
                      );
                    }
                    // else {
                    //   if (responseModel != null) {
                    //     responseModel = Prefs.getString(Prefs.tempMsg) != null
                    //         ? GetAllPatientChatMessages.fromJson(
                    //             json.decode(Prefs.getString(Prefs.tempMsg)))
                    //         : null;
                    //
                    //     return ListView.separated(
                    //       reverse: true,
                    //       separatorBuilder: (context, index) => SizedBox(
                    //         height: 15,
                    //       ),
                    //       itemCount:
                    //           responseModel?.patientChatList?.length ?? 0,
                    //       padding: EdgeInsets.only(bottom: 10),
                    //       itemBuilder: (context, index) {
                    //         List<PatientChat> patientData =
                    //             responseModel.patientChatList.reversed.toList();
                    //         PatientChat _patientChat = patientData[index];
                    //
                    //         return Padding(
                    //           padding: const EdgeInsets.only(
                    //             top: 6.0,
                    //           ),
                    //           child: MessageItem(
                    //             send: _patientChat?.fromType == "patient"
                    //                 ? true.obs
                    //                 : false.obs,
                    //             message:
                    //                 _patientChat?.message.toString().obs ?? "",
                    //             time:
                    //                 '${DateFormat('hh:mm a').format(DateTime.parse(_patientChat?.created.toString()))}',
                    //             networkImage:
                    //                 _userController.user.value.profilePic,
                    //             attachment: _patientChat.attachment,
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   } else {
                    //     return Center(child: CircularProgressIndicator());
                    //   }
                    // }
                  },
                )

                /* Obx(() {
                  if (patientHomeScreenController
                          .getAllPatientChatMessages.value.apiState ==
                      APIState.COMPLETE) {
                    return Obx(() => ListView.separated(
                          controller: _controller,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: patientHomeScreenController
                                  ?.getAllPatientChatMessages
                                  ?.value
                                  ?.patientChatList
                                  ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            PatientChat _patientChat =
                                patientHomeScreenController
                                    ?.getAllPatientChatMessages
                                    ?.value
                                    ?.patientChatList[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: MessageItem(
                                send: _patientChat?.fromType == "patient"
                                    ? true.obs
                                    : false.obs,
                                message:
                                    _patientChat?.message.toString().obs ?? "",
                                time:
                                    '${DateFormat('hh:mm a').format(DateTime.parse(_patientChat?.created.toString()))}',
                                networkImage:
                                    _userController.user.value.profilePic,
                                attachment: _patientChat.attachment,
                              ),
                            );
                          },
                        ));
                  } else if (patientHomeScreenController
                          .getAllPatientChatMessages.value.apiState ==
                      APIState.COMPLETE_WITH_NO_DATA) {
                    return Center(
                      child: Container(
                        child: Text('You Don\'t have any Messages'),
                      ),
                    );
                  } else if (patientHomeScreenController
                          .getAllPatientChatMessages.value.apiState ==
                      APIState.ERROR) {
                    return Center(child: Text("Error"));
                  } else if (patientHomeScreenController
                          .getAllPatientChatMessages.value.apiState ==
                      APIState.PROCESSING) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("No Data to show !"),
                    );
                  }
                })*/
                ,
              ),
            ),
            SafeArea(
              child: Container(
                // height: 70,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200], width: 0.5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                            enableSuggestions: false,
                            autocorrect: false,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.done,
                            validator: (text) {
                              if (text.isEmpty) {
                                patientHomeScreenController.isLoading.value =
                                    false;
                                return 'Enter Message';
                              }
                              return null;
                            },
                            controller: messageController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[250],
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintText: 'Enter message',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 24),
                            ),
                            // autofocus: false,
                            style: TextStyle(
                              fontSize: 24,
                              color: _isDark ? Colors.white : kColorDarkBlue,
                            ),
                            cursorWidth: 1),
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
                    //               loginType: 'patient',
                    //             ))
                    //           : print('imageW  $imageW');
                    //       print("RESULT=====>${result.paths[0]}");
                    //     }),
                    IconButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print(
                              '_userController.user.value.id  ${_userController.user.value.id}');
                          print(
                              'patientHomeScreenController?.toId?.value  ${patientHomeScreenController?.toId?.value}');

                          PatientChat value = PatientChat(
                              message: messageController.text.trim(),
                              fromType: "patient",
                              toType: "doctor",
                              id: "",
                              attachment: "",
                              chatKey: "",
                              created: "",
                              fromId: "",
                              modified: "",
                              toId: "");

                          patientData.insert(0, value);

                          String msg = messageController.text.trim();

                          messageController.text = "";

                          if (chatKey == '') {
                            CreateNewMessage _createNewMessage =
                                await patientHomeScreenController
                                    .createNewMessagePatient(
                                        message: msg,
                                        chatKey: "",
                                        fromId: _userController.user.value.id,
                                        fromType: "patient",
                                        toId: (patientHomeScreenController
                                                    ?.toId?.isNotEmpty ??
                                                false)
                                            ? patientHomeScreenController
                                                ?.toId?.value
                                            : widget.doctor?.id ?? '',
                                        toType: "doctor",
                                        attachment: imageW ?? pdf);
                            widget.doctor?.chatKey = _createNewMessage.chatKey;
                            patientHomeScreenController.chatKey.value =
                                _createNewMessage.chatKey;
                            chatKey = _createNewMessage.chatKey;
                            print('_createNewMessage.chatKey  $chatKey');
                            patientHomeScreenController.getAllChatMessages(
                                chatKey ?? "",
                                _userController.user.value.id ?? "");
                          } else {
                            CreateNewMessage _createNewMessage =
                                await patientHomeScreenController
                                    .createNewMessagePatient(
                                        message: msg,
                                        chatKey: patientHomeScreenController
                                            .chatKey.value,
                                        fromId: _userController.user.value.id,
                                        fromType: "patient",
                                        toId: (patientHomeScreenController
                                                    ?.toId?.isNotEmpty ??
                                                false)
                                            ? patientHomeScreenController
                                                ?.toId?.value
                                            : widget.doctor?.id ?? '',
                                        toType: "doctor",
                                        attachment: imageW ?? pdf);
                            widget.doctor?.chatKey = _createNewMessage.chatKey;
                            patientHomeScreenController.chatKey.value =
                                _createNewMessage.chatKey;
                          }

                          msg = "";
                          await patientHomeScreenController
                              .getAllPatientChatMessagesList(
                                  patientHomeScreenController.chatKey.value);
                          // Timer(Duration(milliseconds: 500), () {
                          //   if (_controller.hasClients) {
                          //     return _controller
                          //         .jumpTo(_controller.position.maxScrollExtent);
                          //   }
                          // });
                        }
                      },
                      icon: /*Obx(
                        () =>*/ /*patientHomeScreenController.isLoading.value
                            // ? Center(
                            //     child: Utils.circular(),
                            //   )
                            ? CircularProgressIndicator()
                            :*/
                          Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  _openBottomSheet(BuildContext context, Function() onTap) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
              leading: Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
              title: Text(
                Translate.of(context).translate('Delete Message'),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              onTap: onTap,
            ),
            ListTile(
              leading: Icon(
                Icons.cancel,
                size: 20,
              ),
              title: Text(
                Translate.of(context).translate('cancel'),
                style: TextStyle(
                    color: _isDark ? Colors.blue : Color(0xff4a4a4a),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  final RxBool send;
  final RxString message;
  final String time;
  final String networkImage;
  final String attachment;
  final Function onLongPress;

  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  MessageItem(
      {Key key,
      this.attachment,
      @required this.send,
      @required this.message,
      @required this.time,
      @required this.networkImage,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String attach = attachment.split('.').last;
    print('ATTACHMENT  $attach');

    return InkWell(
      onLongPress: send.value ? onLongPress : null,
      child: Builder(
        builder: (context) {
          if (message.value == "" && attachment == "") {
            return SizedBox();
          } else {
            return message.value != "" && attachment != ""
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: send.value
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: !send.value,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              "${patientHomeScreenController?.doctorProfile ?? ''}"),
                          onBackgroundImageError: (context, error) {
                            print("ERROR=====>>>>$error");
                            return Container();
                          },
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: !send.value
                                  ? 5
                                  : (MediaQuery.of(context).size.width / 2) -
                                      80,
                              right: send.value
                                  ? 5
                                  : (MediaQuery.of(context).size.width / 2) -
                                      80),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft:
                                    Radius.circular(send.value ? 20 : 0),
                                bottomRight:
                                    Radius.circular(send.value ? 0 : 20),
                              ),
                              color:
                                  send.value ? Color(0xffeaf2fe) : kColorBlue),
                          child: attach != 'pdf'
                              ? Column(
                                  crossAxisAlignment: !send.value
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(MessageShowScreen(
                                          file:
                                              'https:\/\/unhbackend.com\/uploads\/chat\/$attachment',
                                          type: 'image',
                                        ));
                                      },
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(
                                                  send.value ? 20 : 0),
                                              bottomRight: Radius.circular(
                                                  send.value ? 0 : 20),
                                            ),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https:\/\/unhbackend.com\/uploads\/chat\/$attachment'),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    SelectableText(
                                      message.value,
                                      style: TextStyle(
                                          color: send.value
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                      // textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 2),
                                    SelectableText(time,
                                        style: TextStyle(
                                          color: send.value
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        textAlign: TextAlign.start),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(MessageShowScreen(
                                          file:
                                              'https:\/\/unhbackend.com\/uploads\/chat\/$attachment',
                                          type: 'pdf',
                                        ));
                                      },
                                      child: Container(
                                          height: Get.height * 0.2,
                                          width: Get.width * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(
                                                  send.value ? 20 : 0),
                                              bottomRight: Radius.circular(
                                                  send.value ? 0 : 20),
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                                'assets/images/pdf.png',
                                                height: 50,
                                                width: 50),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    SelectableText(
                                      message.value,
                                      style: TextStyle(
                                          color: send.value
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                      // textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    SelectableText(time,
                                        style: TextStyle(
                                          color: send.value
                                              ? kColorDarkBlue
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                        ),
                      ),
                      Visibility(
                        visible: send.value,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(networkImage),
                          onBackgroundImageError: (context, error) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: send.value
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: !send.value,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              "${patientHomeScreenController?.doctorProfile ?? ''}"),
                          onBackgroundImageError: (context, error) {
                            print("ERROR=====>>>>> $error");
                            return Container();
                          },
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: !send.value
                                  ? 5
                                  : (MediaQuery.of(context).size.width / 2) -
                                      80,
                              right: send.value
                                  ? 5
                                  : (MediaQuery.of(context).size.width / 2) -
                                      80),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(send.value ? 20 : 0),
                              bottomRight: Radius.circular(send.value ? 0 : 20),
                            ),
                            color: send.value ? Color(0xffeaf2fe) : kColorBlue,
                          ),
                          child: message.value == ""
                              ? attach != 'pdf'
                                  ? Column(
                                      crossAxisAlignment: !send.value
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('pdf..... 1');
                                            Get.to(MessageShowScreen(
                                              file:
                                                  'https:\/\/unhbackend.com\/uploads\/chat\/$attachment',
                                              type: 'image',
                                            ));
                                          },
                                          child: Container(
                                            height: Get.height * 0.2,
                                            width: Get.width * 0.5,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft: Radius.circular(
                                                      send.value ? 20 : 0),
                                                  bottomRight: Radius.circular(
                                                      send.value ? 0 : 20),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https:\/\/unhbackend.com\/uploads\/chat\/$attachment'),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        SelectableText(time,
                                            style: TextStyle(
                                              color: send.value
                                                  ? kColorDarkBlue
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: Get.height * 0.2,
                                          width: Get.width * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(
                                                  send.value ? 20 : 0),
                                              bottomRight: Radius.circular(
                                                  send.value ? 0 : 20),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('pdf.....');
                                              Get.to(MessageShowScreen(
                                                file:
                                                    'https:\/\/unhbackend.com\/uploads\/chat\/$attachment',
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
                                        SizedBox(
                                          height: 2,
                                        ),
                                        SelectableText(
                                          time,
                                          style: TextStyle(
                                            color: send.value
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
                                        message.value,
                                        style: TextStyle(
                                          color: send.value
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
                                        color: send.value
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
                        visible: send.value,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(networkImage ?? ""),
                          onBackgroundImageError: (context, error) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}
