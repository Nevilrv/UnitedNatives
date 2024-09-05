import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/ResponseModel/get_all_patient_messagelist_model.dart';
import 'package:united_natives/ResponseModel/get_new_message_doctor_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/doctormessages/msg_show_screen.dart';
import 'package:united_natives/pages/myPatientMessageList/upload_screen.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';

import '../utils/pref_manager.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class FirstMessagePage extends StatefulWidget {
  final String? patientId;
  final String? docId;
  final String? docFName;
  final String? docLName;
  final String? docImage;
  final String? docSocialImage;
  final String? chatKey;

  const FirstMessagePage(
      {super.key,
      this.docId,
      this.docImage,
      this.docFName,
      this.docLName,
      this.docSocialImage,
      this.chatKey,
      this.patientId});

  @override
  State createState() => _FisrtMessagePageState();
}

class _FisrtMessagePageState extends State<FirstMessagePage> {
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  final UserController _userController = Get.find<UserController>();

  final TextEditingController messageController = TextEditingController();

  final ScrollController _controller = ScrollController();

  String chatKey = '';
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
                loginType: 'patient',
              ))
            : log('imageW  $imageW');
      } else {}
    });
  }

/*  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      getImage(imgSource: ImageSource.gallery);

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(imgSource: ImageSource.camera);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }*/

  GetAllPatientChatMessages responseModel = GetAllPatientChatMessages();

  @override
  void initState() {
    // _controller.jumpTo(_controller.position.maxScrollExtent);
    // changeScroll();
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
      "Content-Type": "application/json",
    };
    final response = await http.get(
        Uri.parse('${Constants.baseUrl}common/chatStatus/${widget.docId}'),
        headers: header);
    if (response.statusCode == 200) {
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

  @override
  void dispose() {
    patientHomeScreenController.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: <Widget>[
                  Utils().patientProfile(
                      patientHomeScreenController.doctorProfile,
                      patientHomeScreenController.doctorSocialProfile,
                      25),

                  /*CircleAvatar(
                      radius: 25,
                      child: ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: OctoImage(
                          image: CachedNetworkImageProvider(
                              patientHomeScreenController?.doctorProfile ??
                                  patientHomeScreenController
                                      ?.doctorSocialProfile ??
                                  'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                          placeholderBuilder: OctoPlaceholder.blurHash(
                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                            // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                          ),
                          errorBuilder: OctoError.circleAvatar(
                              backgroundColor: Colors.white,
                              text: Image.network(
                                  'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png')),
                          fit: BoxFit.fill,
                          height: Get.height,
                          width: Get.height,
                        ),
                      )),*/
                  FutureBuilder(
                    future: getChatStatus(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
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
                  'Dr. ${widget.docFName ?? ''}' '${widget.docLName ?? ''}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
                FutureBuilder(
                  future: getChatStatus(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data['status'] == 'Fail') {
                          return const SizedBox();
                        } else {
                          String lastSeen = snapshot.data['data']['last_seen'];

                          var data1 =
                              Utils.timeAgo(Utils.formattedDate(lastSeen));

                          return Text(
                            snapshot.data['data']['is_online'] == true
                                ? 'Active now'
                                : data1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 16),
                          );
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
        actions: const <Widget>[
          // IconButton(
          //   onPressed: () {
          //     print(_bookAppointmentController
          //         .doctorBySpecialitiesModelData.value.doctorSpecialities);
          //     _bookAppointmentController
          //         .doctorBySpecialitiesModelData.value.doctorSpecialities
          //         .forEach((element) {
          //       if (element.firstName ==
          //           patientHomeScreenController.doctorName.value) {
          //         doctorDetails = element;
          //       }
          //     });
          //     Get.toNamed(Routes.doctorProfile, arguments: doctorDetails);
          //   },
          //   icon: Icon(
          //     Icons.info,
          //     size: 30,
          //   ),
          // )
        ],
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          await patientHomeScreenController.endTimer();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GetBuilder<AddNewChatMessageController>(
                  builder: (controller) {
                    if (controller.allNewMessagePatientApiResponse.status ==
                        Status.LOADING) {
                      return Center(
                        child: Utils.circular(),
                      );
                      // return Center(child: CircularProgressIndicator());
                    }
                    if (controller.allNewMessagePatientApiResponse.status ==
                        Status.ERROR) {
                      return const Center(child: Text('Server error'));
                    }

                    GetAllPatientChatMessages responseModel =
                        controller.allNewMessagePatientApiResponse.data;
                    // if (controller.allNewMessageApiResponse.data == null) {
                    //   return Center(
                    //       child: Text('You Don\'t have any Messages'));
                    // }
                    return ListView.separated(
                      reverse: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                      // physics: NeverScrollableScrollPhysics(),

                      itemCount: responseModel.patientChatList!.length,
                      itemBuilder: (context, index) {
                        List<PatientChat> patientData =
                            responseModel.patientChatList!.reversed.toList();
                        PatientChat patientChat = patientData[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: MessageItem(
                            send: patientChat.fromType == "patient"
                                ? true.obs
                                : false.obs,
                            message: patientChat.message.toString().obs,
                            time: DateFormat('hh:mm a').format(
                                DateTime.parse(patientChat.created.toString())),
                            networkImage:
                                _userController.user.value.profilePic!,
                            attachment: patientChat.attachment!,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SafeArea(
              child: Container(
                // height: 70,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          minLines: 1,
                          maxLines: 4,
                          validator: (text) {
                            if (text!.isEmpty) {
                              patientHomeScreenController.isLoading.value =
                                  false;
                              return 'Enter Message';
                            }
                            return null;
                          },
                          onTap: () {
                            // Timer(
                            //     Duration(milliseconds: 300),
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
                              color: _isDark ? Colors.white : kColorDarkBlue,
                              fontSize: 24),
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
                    //               loginType: 'patient',
                    //             ))
                    //           : print('imageW  $imageW');
                    //       print("RESULT:::::?${result.paths[0]}");
                    //     }),
                    IconButton(
                      onPressed: () async {
                        log('+++++++++done++++++');
                        if (formKey.currentState!.validate()) {
                          String msg = messageController.text.trim();
                          messageController.text = "";

                          CreateNewMessage createNewMessage =
                              await patientHomeScreenController
                                  .createNewMessagePatient(
                                      message: msg,
                                      chatKey: chatKey == '' ? '' : chatKey,
                                      fromId: _userController.user.value.id,
                                      fromType: "patient",
                                      toId: widget.docId,
                                      toType: "doctor",
                                      attachment: imageW ?? pdf!);

                          chatKey = createNewMessage.chatKey!;
                          patientHomeScreenController.chatKey.value =
                              createNewMessage.chatKey!;
                          msg = "";
                          // await patientHomeScreenController
                          //     .getAllPatientChatMessagesList(chatKey);

                          patientHomeScreenController.getAllChatMessages(
                              chatKey, widget.patientId.toString());

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
                            ? CircularProgressIndicator()
                            // ? Center(
                            //     child: Utils.circular(),
                            //   )
                            :*/
                          const Icon(
                        Icons.send,
                        size: 30,
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
  }
}

class MessageItem extends StatelessWidget {
  final RxBool send;
  final RxString message;
  final String time;
  final String networkImage;
  final String attachment;

  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  MessageItem(
      {super.key,
      required this.attachment,
      required this.send,
      required this.message,
      required this.time,
      required this.networkImage});

  @override
  Widget build(BuildContext context) {
    String attach = attachment.split('.').last;
    // print('ATTACHMENT  ${attachment}');
    if (message.value == "" && attachment == "") {
      return const SizedBox();
    } else {
      return message.value != "" && attachment != ""
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
                  send.value ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: !send.value,
                  child: Utils().patientProfile(
                      patientHomeScreenController.doctorProfile,
                      patientHomeScreenController.doctorSocialProfile,
                      10),
                  // CircleAvatar(
                  //   radius: 10,
                  //   backgroundColor: Colors.transparent,
                  //   backgroundImage:
                  //       NetworkImage(patientHomeScreenController.doctorProfile),
                  // ),
                ),
                Flexible(
                  child: Container(
                      margin: EdgeInsets.only(
                        left: !send.value
                            ? 5
                            : (MediaQuery.of(context).size.width / 2) - 80,
                        right: send.value
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
                          bottomLeft: Radius.circular(send.value ? 20 : 0),
                          bottomRight: Radius.circular(send.value ? 0 : 20),
                        ),
                        color:
                            send.value ? const Color(0xffeaf2fe) : kColorBlue,
                      ),
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
                                          bottomLeft: Radius.circular(
                                              send.value ? 20 : 0),
                                          bottomRight: Radius.circular(
                                              send.value ? 0 : 20),
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
                                const SizedBox(
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
                                      height: Get.height * 0.2,
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
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
                                          width: 50,
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                SelectableText(
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
                                const SizedBox(
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
                            )),
                ),
                Visibility(
                    visible: send.value,
                    child:
                        Utils().patientProfile(networkImage, networkImage, 10)
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
                  send.value ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Visibility(
                    visible: !send.value,
                    child: Utils().patientProfile(
                        patientHomeScreenController.doctorProfile,
                        patientHomeScreenController.doctorSocialProfile,
                        10)
                    // CircleAvatar(
                    //   radius: 10,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage:
                    //       NetworkImage(patientHomeScreenController.doctorProfile),
                    // ),
                    ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: !send.value
                          ? 5
                          : (MediaQuery.of(context).size.width / 2) - 80,
                      right: send.value
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
                        bottomLeft: Radius.circular(send.value ? 20 : 0),
                        bottomRight: Radius.circular(send.value ? 0 : 20),
                      ),
                      color: send.value ? const Color(0xffeaf2fe) : kColorBlue,
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
                                            bottomLeft: Radius.circular(
                                                send.value ? 20 : 0),
                                            bottomRight: Radius.circular(
                                                send.value ? 0 : 20),
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
                                        bottomLeft: Radius.circular(
                                            send.value ? 20 : 0),
                                        bottomRight: Radius.circular(
                                            send.value ? 0 : 20),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    child:
                        Utils().patientProfile(networkImage, networkImage, 10)
                    // CircleAvatar(
                    //   radius: 10,
                    //   backgroundColor: Colors.transparent,
                    //   backgroundImage: NetworkImage(networkImage),
                    // ),
                    ),
              ],
            );
    }
  }
}
