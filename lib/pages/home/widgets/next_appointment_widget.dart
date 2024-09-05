import 'package:united_natives/components/agora_video_call.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/ResponseModel/patient_homepage_model.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/constants.dart';

class NextAppointmentWidget extends StatefulWidget {
  const NextAppointmentWidget({super.key});

  @override
  State<NextAppointmentWidget> createState() => _NextAppointmentWidgetState();
}

class _NextAppointmentWidgetState extends State<NextAppointmentWidget> {
  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  int temp = 0;

  getData(UpcomingAppointments data) async {
    if (data.meetingData != null) {
      if (data.meetingData!.id!.isNotEmpty &&
          data.meetingData!.password!.isNotEmpty) {
        data.status = await _patientHomeScreenController.getMeetingStatus(
            data.meetingData!.id!, data.doctorId!);
      }
    }
    temp = 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<UpcomingAppointments>? dataList = _patientHomeScreenController
            .patientHomePageData.value.data?.upcomingAppointments;

        dataList?.sort(
          (b, a) {
            String dateA = "${b.appointmentDate} ${b.appointmentTime}";
            String dateB = "${a.appointmentDate} ${a.appointmentTime}";
            return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
          },
        );

        UpcomingAppointments? data = dataList?.first;

        final time = Utils.formattedDate(
            '${DateTime.parse('${data?.appointmentDate} ${data?.appointmentTime}')}');

        if (temp == 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            getData(data!);
          });
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: kColorBlue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          DateFormat('EEEE, d MMMM').format(time),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(time),
                          // '${data.appointmentTime}',
                          // '${_patientHomeScreenController.visitedDoctorUpcomingPastData.value.upcomingPast?.upcoming?.first?.appointmentDate}, ${_patientHomeScreenController.visitedDoctorUpcomingPastData.value.upcomingPast?.upcoming?.first?.appointmentTime}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Builder(
                    builder: (context) {
                      DateTime currentTime = DateTime.now();

                      final dateTime = Utils.formattedDate(
                          '${DateTime.parse('${data?.appointmentDate} ${data?.appointmentTime}')}');

                      DateTime appointmentDate = DateTime.parse("$dateTime");

                      // String targetTime =
                      //     '${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}')}';
                      int difference =
                          dateTime.difference(currentTime).inMinutes;

                      bool isWithin5Minutes = difference <= 15;
                      return /*appointmentDate.difference(currentTime).inDays != 0
                          ? SizedBox()
                          : !isWithin5Minutes
                              ? SizedBox()
                              :*/
                          CustomButton(
                        textSize: 18,
                        color: data?.appointmentStatus == "0"
                            ? Colors.white70
                            : appointmentDate.difference(currentTime).inDays ==
                                    0
                                ? !isWithin5Minutes
                                    ? Colors.white70
                                    : Colors.white
                                : Colors.white70,
                        fontColor: kColorBlue,
                        text: data?.status == "rejoin"
                            ? "Rejoin Meeting"
                            : "Join Meeting",
                        onPressed: () async {
                          if (data?.appointmentStatus == "0") {
                            messageDialog(
                                title: "Appointment not accepted",
                                message:
                                    "Please wait till the provider accepts your appointment",
                                context: context);

                            // Utils.showSnackBar(
                            //     title: 'Appointment not accepted',
                            //     message:
                            //         "Please wait till the doctor accepts your appointment");
                            return;
                          }

                          if (appointmentDate.difference(currentTime).inDays ==
                              0) {
                            if (!isWithin5Minutes) {
                              return messageDialog(
                                  title: "Warning",
                                  message:
                                      'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(dateTime)} ${DateFormat("hh:mm a").format(dateTime)}. You can join meeting 15 minutes before the scheduled time when provider started meeting.',
                                  context: context);

                              // return Utils.showSnackBar(
                              //     title: 'Warning',
                              //     message:
                              //         'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(DateTime.parse("${data.appointmentDate}"))} ${DateFormat("hh:mm a").format(DateTime.parse(targetTime))}. You can join meeting 10 minutes before the scheduled time when doctor started meeting.');
                            } else {
                              if (data!.meetingData!.id.toString().isEmpty) {
                                return messageDialog(
                                    title: "Stay tuned",
                                    message:
                                        "Wait for the provider and please refresh the page..",
                                    context: context);
                              } else {
                                await cameraPermission(context);

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyVideoCall(
                                        docId: data.doctorId,
                                        s1: "${data.id}",
                                        s2: "${data.meetingData?.id}",
                                        channelName: "${data.meetingData?.id}",
                                        token: "${data.meetingData?.password}"),
                                  ),
                                ).then(
                                  (value) async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    await showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext c1) => AlertDialog(
                                        title: const Text(
                                          "Appointment Ended",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        content: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                "If you disconnect the call unintentionally please contact with your provider via message and rejoin/reconnect the meeting"),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                child: const Text(
                                                  "Okay",
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                  _patientHomeScreenController
                                                      .getPatientHomePage();
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }

                              // return Utils.showSnackBar(
                              //     title: 'Stay tuned',
                              //     message: 'Wait for the doctor...');
                            }
                          } else {
                            return messageDialog(
                                title: "Stay tuned",
                                message:
                                    'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(dateTime)} ${DateFormat("hh:mm a").format(dateTime)}. You can join meeting 15 minutes before the scheduled time when provider started meeting.',
                                context: context);

                            // return Utils.showSnackBar(
                            //     title: 'Warning',
                            //     message:
                            //         'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(DateTime.parse("${data.appointmentDate}"))} ${DateFormat("hh:mm a").format(DateTime.parse(targetTime))}. You can join meeting 10 minutes before the scheduled time when doctor started meeting.');
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.grey, height: 40, thickness: 0.5),
              Row(
                children: <Widget>[
                  Utils().patientProfile(data?.doctorProfilePic ?? "",
                      data?.doctorSocialProfilePic ?? "", 28),

                  // Container(
                  //     width: 56,
                  //     height: 56,
                  //     padding: EdgeInsets.all(2),
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle, color: Colors.white),
                  //     child: ClipOval(
                  //       child: OctoImage(
                  //           image: CachedNetworkImageProvider(
                  //               data?.doctorProfilePic),
                  //           placeholderBuilder: OctoPlaceholder.blurHash(
                  //             "LEHV6nWB2yk8pyo0adR*.7kCMdnj",
                  //           ),
                  //           errorBuilder: OctoError.circleAvatar(
                  //               backgroundColor: Colors.white,
                  //               text: Image.network(
                  //                   "https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png")),
                  //           fit: BoxFit.cover,
                  //           height: Get.height,
                  //           width: Get.width),
                  //     ) /*CircleAvatar(
                  //   backgroundColor: Colors.transparent,
                  //   backgroundImage: NetworkImage(
                  //     '${data.doctorProfilePic}',
                  //   ),
                  // ),*/
                  //     ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${data?.doctorFirstName} ${data?.doctorLastName}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${data?.doctorSpeciality}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
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
      barrierDismissible: false,
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
                      _patientHomeScreenController.getPatientHomePage();
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
                            _patientHomeScreenController.getPatientHomePage();
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

  cameraPermission(BuildContext context) async {
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
}
