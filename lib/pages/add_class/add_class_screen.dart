import 'dart:io';
import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_class_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_class_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/scheduled_class_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScheduledClassController scheduledClassController = Get.find();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController featureImageController = TextEditingController();
  final UserController userController = Get.find();

  File? featureImageFile;

  bool isStreaming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          Translate.of(context)!.translate('add_class'),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontSize: 24),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                AddClassReqModel model = AddClassReqModel();
                model.doctorId = userController.user.value.id;
                model.title = titleController.text;
                model.description = descriptionController.text;
                model.featuredImage = featureImageFile?.path;
                model.date = dateController.text;
                model.startTime = startTimeController.text;
                model.endTime = endTimeController.text;
                model.streaming = isStreaming ? '1' : '0';
                await scheduledClassController.addClass(model);
                if (scheduledClassController.addclassApiResponse.status ==
                    Status.COMPLETE) {
                  AddClassResponseModel responseModel =
                      scheduledClassController.addclassApiResponse.data;
                  if (responseModel.status == "Success") {
                    Future.delayed(const Duration(seconds: 1), () {
                      scheduledClassController.getClassDoctor(
                          id: userController.user.value.id!, date: "");
                      Navigator.pop(context);

                      Utils.showSnackBar(
                          "Add class successfully", responseModel.message);

                      // CommonSnackBar.snackBar( responseModel.message);
                    });
                  } else {
                    Utils.showSnackBar("Failed", "Server error");
                    // CommonSnackBar.snackBar( "Server error");
                  }
                } else {
                  Utils.showSnackBar("Failed", "Server error");
                  // CommonSnackBar.snackBar( "Server error");
                }
              }
            },
            icon: const Icon(
              Icons.done,
            ),
          )
        ],
      ),
      body: GetBuilder<ScheduledClassController>(
        builder: (controller) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///TITLE
                        titleWidget(),

                        ///DESCRIPTION
                        descriptionWidget(),

                        ///Streaming
                        streamingSwitchWidget(),

                        ///DATE
                        dateWidget(),

                        ///TIME
                        timeWidget(),

                        ///IMAGE
                        imageWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              controller.addclassApiResponse.status == Status.LOADING
                  ? Container(
                      color: Colors.blueGrey.withOpacity(0.1),
                      child: Center(
                        child: Utils.loadingBar(),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  Widget titleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*enter title';
            }
            return null;
          },
          controller: titleController,
          hintText: 'Enter title here',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          validator: (text) {
            if (text!.isEmpty) {
              return '*enter class description';
            }
            return null;
          },
          controller: descriptionController,
          hintText: 'Enter class description',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget streamingSwitchWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Streaming",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            CupertinoSwitch(
              value: isStreaming,
              onChanged: (value) {
                isStreaming = value;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget dateWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          readOnly: true,
          validator: (text) {
            if (text!.isEmpty) {
              return '*select the date';
            }
            return null;
          },
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            dateController.text = date.toString().split(' ').first;
          },
          controller: dateController,
          hintText: 'Select the date',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget timeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ///START TIME
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Start Time",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return '*select the start time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final startTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (startTime != null) {
                        startTimeController.text = startTime.format(context);
                      }
                    },
                    controller: startTimeController,
                    hintText: 'Select the start time',
                    hintTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xffbcbcbc),
                      fontFamily: 'NunitoSans',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            ///END TIME
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "End Time",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return '*select the end time';
                      }
                      return null;
                    },
                    onTap: () async {
                      if (startTimeController.text.isNotEmpty) {
                        final endTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (endTime != null) {
                          DateTime startTime = DateFormat.jm()
                              .parse(startTimeController.text.toLowerCase());

                          final formettedStartTime = TimeOfDay(
                              hour: startTime.hour, minute: startTime.minute);

                          if (endTime
                                  .toString()
                                  .compareTo(formettedStartTime.toString()) >
                              0) {
                            endTimeController.text = endTime.format(context);
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                title: 'WARNING',
                                message: 'please select valid time',
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } else {
                        Get.showSnackbar(
                          const GetSnackBar(
                            title: 'WARNING',
                            message: 'please first select the start time',
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    controller: endTimeController,
                    hintText: 'Select the end time',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget imageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Class Feature Image",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          readOnly: true,
          validator: (text) {
            if (text!.isEmpty) {
              return '*select the date';
            }
            return null;
          },
          suffixIcon: featureImageController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    featureImageFile = null;
                    featureImageController.text = '';
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                ),
          onTap: () async {
            ImagePicker imagePicker = ImagePicker();
            final pick =
                await imagePicker.pickImage(source: ImageSource.gallery);

            featureImageFile = File(pick!.path);
            featureImageController.text = pick.path;
            setState(() {});
          },
          controller: featureImageController,
          hintText: 'Select feature image',
          hintTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xffbcbcbc),
            fontFamily: 'NunitoSans',
          ),
        ),
      ],
    );
  }
}
