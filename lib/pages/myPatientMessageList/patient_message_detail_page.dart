import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/doctormessages/msg_show_screen.dart';
import 'package:united_natives/pages/myPatientMessageList/patient_information_screen.dart';
import 'package:united_natives/pages/myPatientMessageList/upload_screen.dart';
import 'package:united_natives/sevices/doctor_home_screen_service.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import '../../utils/constants.dart';

class DoctorMessagesDetailPage2 extends StatefulWidget {
  String? chatKey;
  final String? profilePic;
  final String? fullName;
  final String? lastName;
  final String? email;
  final String? bloodGroup;
  final String? gender;
  final String? insuranceStatus;
  final String? tribalStatus;
  final String? patientId;
  final String? attachment;
//   @override
//   _DoctorMessagesDetailPage createState() => _DoctorMessagesDetailPage();
// }
//
// class _DoctorMessagesDetailPage extends State<DoctorMessagesDetailPage> {
  DoctorMessagesDetailPage2(
      {super.key,
      this.chatKey,
      this.profilePic,
      this.fullName,
      this.lastName,
      this.email,
      this.bloodGroup,
      this.gender,
      this.insuranceStatus,
      this.tribalStatus,
      this.patientId,
      this.attachment});

  @override
  State<DoctorMessagesDetailPage2> createState() =>
      _DoctorMessagesDetailPage2State();
}

class _DoctorMessagesDetailPage2State extends State<DoctorMessagesDetailPage2> {
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.put(DoctorHomeScreenController());

  final UserController _userController = Get.find<UserController>();

  final TextEditingController messageController = TextEditingController();
  LogOutController logOutController = Get.find();
  final ScrollController _controller = ScrollController();
  AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());
  final _formKey = GlobalKey<FormState>();

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  final ImagePicker _picker = ImagePicker();
  FilePickerResult? result;
  File? imageW;
  File? pdf;
  Future getImage({required ImageSource imgSource}) async {
    final pickedFile = await _picker.pickImage(source: imgSource);

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
        d.log('imageW  $imageW');
      } else {
        d.log('No image selected.');
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
  void dispose() {
    if (_doctorHomeScreenController.isClick == true) {
      _doctorHomeScreenController.endTimer();
    }
    _doctorHomeScreenController.isClick = false;

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    getChatStatus();

    // getMessage();
    // _doctorHomeScreenController
    //     .getAllChatMessagesDoctor(isAll: true, chatKey: widget.chatKey)
    //     .then((value) {});
    //
    // _doctorHomeScreenController.getAllChatMessagesPatient(
    //     chatKey: widget.chatKey);
    addNewChatMessageController.allNewMessageApiResponse.data = null;
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
      "Content-Type": "application/json",
    };
    final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl + Constants.chatStatus}${widget.patientId}'),
        headers: header);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Future<void> getChatStatus() async {
  //   await logOutController.getChatStatus(
  //     id: widget.patientId,
  //   );
  // }

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
          surfaceTintColor: Colors.transparent,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded)),
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
                    //   backgroundImage: NetworkImage("${widget.profilePic ?? ''}"),
                    //   onBackgroundImageError: (context, error) {
                    //     return Container();
                    //   },
                    // ),

                    Utils().patientProfile(widget.profilePic ?? "", "", 25),

                    /*CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl: widget.profilePic,
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
                    '${widget.fullName ?? ""} ${widget.lastName ?? ""}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
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
                            String? lastSeen =
                                snapshot.data['data']['last_seen'];

                            // dynamic diff;
                            // DateTime endTime;
                            // DateTime currentTime = DateTime.now();
                            // String date;
                            // if (lastSeen == null) {
                            //   lastSeen = "";
                            // } else {
                            //   print("lastSeen===>$lastSeen");
                            //
                            //   date = lastSeen == null
                            //       ? ""
                            //       : "${lastSeen.split(" ")[0].split("-")[2]}-${lastSeen.split(" ")[0].split("-")[1]}-${lastSeen.split(" ")[0].split("-")[0]}";
                            //   String time = lastSeen.split(" ")[1];
                            //
                            //   endTime = DateTime.parse("$date $time.00000");
                            //   diff = currentTime.difference(endTime).inDays;
                            //   print(
                            //       "DIFFERENCE ${diff == 1 ? 'today' : '$diff days'}");
                            // }

                            var data1 =
                                Utils.timeAgo(Utils.formattedDate(lastSeen!));
                            if (lastSeen.isNotEmpty) {
                              return Text(
                                lastSeen == ""
                                    ? ""
                                    : snapshot.data['data']['is_online'] == true
                                        ? 'Active now'
                                        // : 'Last seen at ${diff < 1 ? ' ${currentTime.difference(endTime).inMinutes < 60 ? '${currentTime.difference(endTime).inMinutes} min ago' : '${currentTime.difference(endTime).inHours} hours ago'}' : '$date'}',
                                        : data1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontSize: 18),
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
              onPressed: () async {
                if (_doctorHomeScreenController.isClick = true) {
                  _doctorHomeScreenController.endTimer();
                }
                _doctorHomeScreenController.isClick = false;
                await addNewChatMessageController.getSortedChatListDoctor(
                    doctorId: _userController.user.value.id);
                Get.to(PatientDetailSCreen(
                  profilePic: widget.profilePic,
                  fullName: widget.fullName,
                  lastName: widget.lastName,
                  tribalStatus: widget.tribalStatus,
                  insuranceStatus: widget.insuranceStatus,
                  gender: widget.gender,
                  email: widget.email,
                  bloodGroup: widget.bloodGroup,
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
            if (_doctorHomeScreenController.isClick == true) {
              _doctorHomeScreenController.endTimer();
            }
            _doctorHomeScreenController.isClick = false;
            // Get.back();
            // Get.off(const MyPatientMessageList());
          },
          child: Column(
            children: <Widget>[
              widget.chatKey.toString().isNotEmpty
                  ? Expanded(
                      child: GetBuilder<AddNewChatMessageController>(
                        builder: (controller) {
                          if (controller.allNewMessageApiResponse.status ==
                              Status.LOADING) {
                            // return Center(child: CircularProgressIndicator());
                            return Center(
                              child: Utils.circular(),
                            );
                          }
                          if (controller.allNewMessageApiResponse.status ==
                              Status.ERROR) {
                            return const Center(child: Text('Server error'));
                          }
                          GetAllChatMessagesDoctor responseModel =
                              controller.allNewMessageApiResponse.data;
                          if (controller.allNewMessageApiResponse.data ==
                              null) {
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
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              reverse: true,
                              controller: _controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15,
                              ),
                              itemCount:
                                  responseModel.doctorChatList?.length ?? 0,
                              itemBuilder: (context, index) {
                                List<DoctorChat> doctorChat = responseModel
                                    .doctorChatList!.reversed
                                    .toList();
                                DoctorChat doctorChat0 = doctorChat[index];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: MessageItem(
                                    attachment: doctorChat0.attachment!,
                                    send: doctorChat0.fromType == "doctor",
                                    message: doctorChat0.message.toString(),
                                    time: DateFormat('hh:mm a').format(
                                        DateTime.parse(
                                            doctorChat0.created.toString())),
                                    networkImage:
                                        _userController.user.value.profilePic ??
                                            "",
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                          child: Text(
                        'You Don\'t have any Messages',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                    ),
              // Expanded(
              //   child: Obx(() {
              //     if (_doctorHomeScreenController
              //             .getAllChatMessagesDoctorModel.value.apiState ==
              //         APIState.COMPLETE) {
              //       return Obx(
              //         () => Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: ListView.separated(
              //             controller: _controller,
              //             physics: AlwaysScrollableScrollPhysics(),
              //             separatorBuilder: (context, index) => SizedBox(
              //               height: 15,
              //             ),
              //             itemCount: _doctorHomeScreenController
              //                     ?.getAllChatMessagesDoctorModel
              //                     ?.value
              //                     ?.doctorChatList
              //                     ?.length ??
              //                 0,
              //             itemBuilder: (context, index) {
              //               DoctorChat _doctorChat = _doctorHomeScreenController
              //                   ?.getAllChatMessagesDoctorModel
              //                   ?.value
              //                   ?.doctorChatList[index];
              //               return Padding(
              //                 padding: const EdgeInsets.only(top: 6.0),
              //                 child: MessageItem(
              //                   attachment: _doctorChat.attachment,
              //                   recieverImage: widget.profilePic,
              //                   send: _doctorChat?.fromType == "doctor",
              //                   message: _doctorChat?.message.toString() ?? "",
              //                   time:
              //                       '${DateFormat('hh:mm a').format(DateTime.parse(_doctorChat?.created.toString()))}',
              //                   networkImage:
              //                       '${_userController?.user?.value?.profilePic ?? ""}',
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       );
              //     } else if (_doctorHomeScreenController
              //             .getAllChatMessagesDoctorModel.value.apiState ==
              //         APIState.COMPLETE_WITH_NO_DATA) {
              //       return Center(
              //         child: Container(
              //           child: Text('You Don\'t have any Messages'),
              //         ),
              //       );
              //     } else if (_doctorHomeScreenController
              //             .getAllChatMessagesDoctorModel.value.apiState ==
              //         APIState.ERROR) {
              //       return Center(child: Text("Error"));
              //     } else if (_doctorHomeScreenController
              //             .getAllChatMessagesDoctorModel.value.apiState ==
              //         APIState.PROCESSING) {
              //       return Container(
              //         child: Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       );
              //     } else {
              //       return Center(
              //         child: Text(""),
              //       );
              //     }
              //   }),
              // ),
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
                          child: TextFormField(
                            enableSuggestions: false,
                            autocorrect: false,
                            minLines: 1,
                            maxLines: 4,
                            validator: (text) {
                              if (text!.isEmpty) {
                                _doctorHomeScreenController.isLoading.value =
                                    false;
                                return 'Enter Message';
                              }
                              return null;
                            },
                            onTap: () {
                              // Timer(
                              //     Duration(milliseconds: 100),
                              //     () => _controller.jumpTo(
                              //         _controller.position.maxScrollExtent));
                            },
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
                              color: _isDark ? Colors.white : kColorDarkBlue,
                            ),
                            cursorWidth: 1,
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

                            _doctorHomeScreenController.isLoading.value = true;
                            await _doctorHomeScreenController
                                .createNewMessageDoctor(
                                    message: msg,
                                    chatKey: widget
                                        .chatKey /*doctorHomeScreenController
                                          .doctorChat.value.chatKey*/
                                    ,
                                    fromId: _userController.user.value.id,
                                    fromType: "doctor",
                                    toId: widget
                                        .patientId /*_doctorHomeScreenController
                                              .doctorChat.value?.toId ??
                                          ""*/
                                    ,
                                    toType: "patient",
                                    attachment: imageW ?? pdf);
                            msg = "";
                            d.log(
                                "_userController.user.value.id--->${_userController.user.value.id}");
                            d.log(
                                "_userController.user.value.id--->${widget.patientId}");
                            d.log(
                                "_doctorHomeScreenController.isClick------------->${_doctorHomeScreenController.isClick}");

                            if (_doctorHomeScreenController.isClick == false) {
                              GetSortedChatListDoctor data =
                                  await DoctorHomeScreenService()
                                      .getSortedChatListDoctor(
                                          doctorId:
                                              _userController.user.value.id!);
                              data.doctorChatList?.forEach((element) {
                                d.log(
                                    "element.patientId----->${element.patientId}");
                                if (element.patientId.toString() ==
                                    widget.patientId.toString()) {
                                  setState(() {
                                    widget.chatKey = element.chatKey.toString();
                                  });
                                }
                              });
                            }

                            d.log(
                                " widget.chatKey-------------->${widget.chatKey}");

                            if (_doctorHomeScreenController.isClick == true) {
                              _doctorHomeScreenController.endTimer();
                            }
                            _doctorHomeScreenController.isClick = true;
                            setState(() {});
                            // _doctorHomeScreenController
                            //     .getAllChatMessagesDoctor(
                            //         isAll: true, chatKey: widget.chatKey)
                            //     .then((value) {});

                            _doctorHomeScreenController
                                .getAllChatMessagesPatient(
                                    chatKey: widget.chatKey,
                                    id: _userController.user.value.id);
                            _doctorHomeScreenController.isLoading.value = false;

                            // Timer(
                            //     Duration(milliseconds: 100),
                            //     () => _controller.jumpTo(
                            //         _controller.position.maxScrollExtent));
                          }
                        },
                        icon: /*Obx(
                          () =>*/ /*_doctorHomeScreenController.isLoading.value
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
}

class MessageItem extends StatelessWidget {
  final bool send;
  final String message;
  final String time;
  final String networkImage;
  final String? recieverImage;
  final String? attachment;

  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  MessageItem(
      {super.key,
      this.attachment,
      required this.send,
      required this.message,
      required this.time,
      required this.networkImage,
      this.recieverImage});

  @override
  Widget build(BuildContext context) {
    String? attach = attachment?.split('.').last;
    // print('ATTACHMENT  ${attach}');
    // print('ATTACHMENT  ${attachment}');
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
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(_doctorHomeScreenController
                            .doctorChat.value.patientProfilePic ??
                        ''),
                  ),
                ),
                Flexible(
                  child: Container(
                      margin: EdgeInsets.only(
                        left: !send
                            ? 5
                            : (MediaQuery.of(context).size.width / 2) - 80,
                        right: send
                            ? 5
                            : (MediaQuery.of(context).size.width / 2) - 80,
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
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft:
                                              Radius.circular(send ? 20 : 0),
                                          bottomRight:
                                              Radius.circular(send ? 0 : 20),
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
                                    color: send ? kColorDarkBlue : Colors.white,
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
                                    color: send ? kColorDarkBlue : Colors.white,
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
                                          "https://unhbackend.com/uploads/chat/$attachment",
                                      type: 'pdf',
                                    ));
                                  },
                                  child: Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft:
                                              Radius.circular(send ? 20 : 0),
                                          bottomRight:
                                              Radius.circular(send ? 0 : 20),
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
                                    color: send ? kColorDarkBlue : Colors.white,
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
                                    color: send ? kColorDarkBlue : Colors.white,
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
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(networkImage),
                  ),
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
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(_doctorHomeScreenController
                            .doctorChat.value.patientProfilePic ??
                        ''),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: !send
                          ? 5
                          : (MediaQuery.of(context).size.width / 2) - 80,
                      right: send
                          ? 5
                          : (MediaQuery.of(context).size.width / 2) - 80,
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
                                            'https://unhbackend.com/uploads/chat/$attachment',
                                        type: 'image',
                                      ));
                                    },
                                    child: Container(
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(20),
                                            topRight: const Radius.circular(20),
                                            bottomLeft:
                                                Radius.circular(send ? 20 : 0),
                                            bottomRight:
                                                Radius.circular(send ? 0 : 20),
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
                                      color:
                                          send ? kColorDarkBlue : Colors.white,
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
                                  Container(
                                    height: Get.height * 0.2,
                                    width: Get.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft:
                                            Radius.circular(send ? 20 : 0),
                                        bottomRight:
                                            Radius.circular(send ? 0 : 20),
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
                                      color:
                                          send ? kColorDarkBlue : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: SelectableText(
                                  message,
                                  style: TextStyle(
                                    color: send ? kColorDarkBlue : Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // textAlign: TextAlign.start,
                                ),
                              ),
                              SelectableText(
                                time,
                                style: TextStyle(
                                  color: send ? kColorDarkBlue : Colors.white,
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
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(networkImage),
                  ),
                ),
              ],
            );
    }
  }
}
