import 'dart:async';
import 'dart:io';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ChatUploadScreen extends StatefulWidget {
  final File? image;
  final String? type;
  final File? pdf;
  final String? loginType;

  const ChatUploadScreen(
      {super.key, this.image, this.type, this.pdf, this.loginType});
  @override
  State<ChatUploadScreen> createState() => _ChatUploadScreenState();
}

class _ChatUploadScreenState extends State<ChatUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.put<DoctorHomeScreenController>(DoctorHomeScreenController());
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();
  final ScrollController _controller = ScrollController();
  final TextEditingController messageController = TextEditingController();

  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.05,
            ),
            widget.type == 'image'
                ? widget.image == null || widget.image?.path == ''
                    ? Expanded(
                        child: Container(color: Colors.black12),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: Colors.black12,
                            child: Image.file(widget.image!, fit: BoxFit.fill),
                          ),
                        ),
                      )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.red,
                        child: SfPdfViewer.file(widget.pdf!, pageSpacing: 1.0),
                      ),
                    ),
                  ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            validator: (text) {
                              if (text!.isEmpty) {
                                _doctorHomeScreenController.isLoading.value =
                                    false;
                                return 'Enter Message';
                              }
                              return null;
                            },
                            onTap: () {
                              Timer(
                                  const Duration(milliseconds: 100),
                                  () => _controller.jumpTo(
                                      _controller.position.maxScrollExtent));
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
                              fillColor: Colors.white.withOpacity(0.2),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              hintText: 'Enter message',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 22),
                            ),
                            autofocus: false,
                            style: const TextStyle(color: Colors.white),
                            cursorWidth: 1),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      _doctorHomeScreenController.isLoading.value = true;
                      await _doctorHomeScreenController.createNewMessageDoctor(
                          message: messageController.text.trim(),
                          chatKey: widget.loginType == 'patient'
                              ? patientHomeScreenController.chatKey.value
                              : _doctorHomeScreenController
                                  .doctorChat.value.chatKey,
                          fromId: _userController.user.value.id,
                          fromType: widget.loginType == 'patient'
                              ? "patient"
                              : "doctor",
                          toId: widget.loginType == 'patient'
                              ? patientHomeScreenController.toId.value
                              : _doctorHomeScreenController
                                      .doctorChat.value.toId ??
                                  "",
                          toType: widget.loginType == 'patient'
                              ? 'doctor'
                              : "patient",
                          attachment: widget.image ?? widget.pdf);
                      await _doctorHomeScreenController
                          .getAllChatMessagesDoctor();
                      Navigator.pop(context);
                      _doctorHomeScreenController.isLoading.value = false;
                      messageController.text = "";
                    },
                    icon: Obx(
                      () => _doctorHomeScreenController.isLoading.value
                          ? Utils.circular()
                          : const Icon(Icons.send, size: 25),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
      ),
    );
  }
}
