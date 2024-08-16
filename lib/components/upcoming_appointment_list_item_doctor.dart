import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:united_natives/components/agora_video_call.dart';
import 'package:united_natives/components/custom_disable_button.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/store_meeting_credantial_response_model.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';

import '../routes/routes.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';

class UpcomingAppointmentListItemDoctor extends StatefulWidget {
  final PatientAppoint patientAppoint;
  final List dates;

  const UpcomingAppointmentListItemDoctor(this.patientAppoint, this.dates,
      {super.key});

  @override
  State<UpcomingAppointmentListItemDoctor> createState() =>
      _UpcomingAppointmentListItemDoctorState();
}

class _UpcomingAppointmentListItemDoctorState
    extends State<UpcomingAppointmentListItemDoctor> {
  final DoctorHomeScreenController _doctorHomeScreenController = Get.find();
  final UserController userController = Get.find();
  bool isLoading = false;
  Timer? timer;
  bool isLoadingMeet = false;
  bool isLoadingMark = false;
  String? id;
  String? meetingID;

  AgoraController agoraController = Get.put(AgoraController());
  @override
  void initState() {
    agoraController.agoraController("${userController.user.value.id}");
    super.initState();
  }

  refresh() async {
    await _doctorHomeScreenController.getDoctorAppointmentsModel();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTime1 = Utils.formattedDate(
        '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}.000');
    DateTime startTime = startTime1.subtract(const Duration(minutes: 15));
    DateTime showMarkAssCompletedTime =
        startTime1.add(const Duration(minutes: 5));
    DateTime endTime = startTime.add(const Duration(hours: 1));

    DateTime time = Utils.formattedDate(
        '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}');

    bool rejoin =
        (widget.patientAppoint.meetingData!.id.toString().isNotEmpty &&
            widget.patientAppoint.meetingData!.password.toString().isNotEmpty);

    return Card(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: _buildColumn(
                              context: context,
                              title: Translate.of(context)!.translate('date'),
                              subtitle:
                                  DateFormat('EEEE, dd MMM yyyy').format(time),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _buildColumn(
                              context: context,
                              title: Translate.of(context)!.translate('time'),
                              subtitle: DateFormat('hh:mm a').format(time),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: _buildColumn(
                              context: context,
                              title: Translate.of(context)!
                                  .translate('Client Name'),
                              subtitle:
                                  '${widget.patientAppoint.patientFirstName} ${widget.patientAppoint.patientLastName}',
                            ),
                          ),
                          Expanded(
                            child: _buildColumn(
                              context: context,
                              title: 'Purpose of Visit',
                              subtitle:
                                  '${widget.patientAppoint.purposeOfVisit}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: widget.patientAppoint.appointmentStatus == '3'
                            ? const SizedBox()
                            : widget.patientAppoint.appointmentStatus == '1'
                                ? CustomDisableButton(
                                    text: Translate.of(context)!
                                        .translate('Accepted'),
                                    textSize: 16,
                                    onPressed: () {},
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  )
                                : isLoading
                                    ? SizedBox(
                                        height: 60,
                                        child: Center(
                                          child: Utils.circular(height: 60),
                                        ),
                                      )
                                    : CustomButton(
                                        text: Translate.of(context)!
                                            .translate('Accept'),
                                        textSize: 16,
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await _doctorHomeScreenController
                                              .startAppointmentPatient(
                                                  "${widget.patientAppoint.doctorId}",
                                                  widget.patientAppoint.id);
                                          refresh();

                                          Utils.showSnackBar('Accepted',
                                              'Appointment accepted!');

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: widget.patientAppoint.appointmentStatus != '2'
                            ? rejoin
                                ? CustomButton(
                                    text: Translate.of(context)!
                                        .translate('Add prescription'),
                                    textSize: 14,
                                    onPressed: () async {
                                      await Get.toNamed(Routes.addprescription,
                                              arguments: widget.patientAppoint)
                                          ?.then((value) => refresh());
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  )
                                : const SizedBox()
                            : CustomButton(
                                text: Translate.of(context)!
                                    .translate('Add prescription'),
                                textSize: 14,
                                onPressed: () async {
                                  await Get.toNamed(Routes.addprescription,
                                          arguments: widget.patientAppoint)
                                      ?.then((value) => refresh());
                                },
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                      ),
                      Builder(
                        builder: (context) {
                          return SizedBox(
                            width: double.infinity,
                            child:
                                widget.patientAppoint.appointmentStatus == '3'
                                    ? CustomOutlineButton(
                                        text: 'Declined',
                                        textSize: 14,
                                        onPressed: () {},
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      )
                                    : CustomOutlineButton(
                                        text: Translate.of(context)!
                                            .translate('Decline'),
                                        textSize: 14,
                                        onPressed: () => _showAlert(
                                          context,
                                          () async {
                                            Navigator.of(context).pop();

                                            await _doctorHomeScreenController
                                                .cancelAppointmentPatient(
                                                    "${widget.patientAppoint.doctorId}",
                                                    widget.patientAppoint.id)
                                                .then((value) => refresh());
                                          },
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          TimerBuilder.scheduled(
            [startTime, endTime],
            builder: (context) {
              final now = DateTime.now();
              final started = now.compareTo(startTime) >= 0;
              // final ended = now.compareTo(endTime) >= 0;

              return isLoadingMeet == true
                  // ? Center(child: CircularProgressIndicator())
                  ? Center(
                      child: Utils.circular(),
                    )
                  : started
                      /*? ended
                          ? SizedBox()*/
                      ? widget.patientAppoint.appointmentStatus == '1'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isLoadingMeet == true
                                  // ? Center(child: CircularProgressIndicator())
                                  ? SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Utils.circular(height: 60),
                                      ),
                                    )
                                  : CustomButton(
                                      text: rejoin
                                          ? 'Rejoin Meeting'
                                          : 'Start Meeting',
                                      textSize: 18,
                                      onPressed: () async {
                                        if (widget.dates.any((element) =>
                                                Utils.formattedDate(element)
                                                    .isBefore(startTime1)) &&
                                            widget.patientAppoint
                                                    .appointmentStatus ==
                                                '1') {
                                          Utils.showSnackBar('Warning',
                                              'Please mark past appointment as completed first');
                                          return null;
                                        }

                                        if (rejoin) {
                                          setState(() {
                                            isLoadingMeet = true;
                                          });

                                          startMeeting(
                                              context: context,
                                              channelsName:
                                                  "${widget.patientAppoint.meetingData?.id}",
                                              tokens:
                                                  "${widget.patientAppoint.meetingData?.password}");

                                          await Future.delayed(
                                                  const Duration(seconds: 5))
                                              .then((value) => setState(() {
                                                    isLoading = false;
                                                  }));

                                          return;
                                        }

                                        var headers = {
                                          'Authorization':
                                              'Bearer ${Prefs.getString(Prefs.BEARER)}',
                                          'Cookie':
                                              'ci_session=5d272013f8aaa1d629bb834a68b3d0178d0454e3'
                                        };
                                        var request = http.MultipartRequest(
                                            'GET',
                                            Uri.parse(
                                                '${Constants.baseUrl1}common/agoraToken/${DateTime.now().millisecondsSinceEpoch}'));

                                        request.headers.addAll(headers);

                                        http.StreamedResponse response =
                                            await request.send();

                                        if (response.statusCode == 200) {
                                          Prefs.setString(
                                              Prefs.vcStartTime,
                                              DateTime.now()
                                                  .toUtc()
                                                  .toString());
                                          var agoraData = await response.stream
                                              .bytesToString();

                                          GetAgoraToken getAgoraToken =
                                              GetAgoraToken.fromJson(
                                                  jsonDecode(agoraData));

                                          if (getAgoraToken.status ==
                                              'Success') {
                                            try {
                                              setState(() {
                                                isLoadingMeet = true;
                                              });
                                              if (!context.mounted) return;

                                              startMeeting(
                                                  context: context,
                                                  channelsName:
                                                      "${getAgoraToken.data?.channelName}",
                                                  tokens:
                                                      "${getAgoraToken.data?.token}");
                                            } catch (e) {
                                              setState(() {
                                                isLoadingMeet = false;
                                              });
                                            }
                                          } else {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Something Went to Wrong')));
                                          }
                                        }
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                            )
                          : const SizedBox()
                      : const SizedBox();
            },
          ),
          TimerBuilder.scheduled(
            [showMarkAssCompletedTime, endTime],
            builder: (context) {
              final now = DateTime.now();
              final started = now.compareTo(showMarkAssCompletedTime) >= 0;

              return widget.patientAppoint.appointmentStatus == '1' &&
                      !started &&
                      !rejoin
                  ? const SizedBox()
                  : widget.patientAppoint.appointmentStatus == '2' ||
                          started ||
                          rejoin
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoadingMark == true
                              ? SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: Utils.circular(height: 60),
                                  ),
                                )
                              : CustomButton(
                                  text: 'Mark this appointment completed',
                                  textSize: 18,
                                  onPressed: () async {
                                    setState(() {
                                      isLoadingMark = true;
                                    });

                                    changeMeetingStatus(
                                      docId: userController.user.value.id,
                                      s2: "${widget.patientAppoint.meetingData?.id}",
                                    );

                                    String url1 = Constants.baseUrl +
                                        Constants.doctorCompleteAppointment;

                                    DateTime? start;
                                    DateTime? end;
                                    String? meetingDuration;

                                    if (Prefs.getString(Prefs.vcStartTime)!
                                            .isNotEmpty &&
                                        Prefs.getString(Prefs.vcEndTime)!
                                            .isNotEmpty) {
                                      start = DateTime.parse(
                                          Prefs.getString(Prefs.vcStartTime)!);

                                      end = DateTime.parse(
                                          Prefs.getString(Prefs.vcEndTime)!);

                                      meetingDuration = end
                                                  .difference(start)
                                                  .inMinutes
                                                  .toString() ==
                                              "0"
                                          ? "1"
                                          : end
                                              .difference(start)
                                              .inMinutes
                                              .toString();
                                    }

                                    Map<String, dynamic> body1 = {
                                      "doctor_id": userController.user.value.id,
                                      "appointment_id":
                                          widget.patientAppoint.id,
                                      "vc_start_time": "$start",
                                      "vc_end_time": "$end",
                                      "vc_duration": meetingDuration
                                    };

                                    Map<String, String> header1 = {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          'Bearer ${Prefs.getString(Prefs.BEARER)}',
                                    };

                                    http.Response response1 = await http.post(
                                        Uri.parse(url1),
                                        body: jsonEncode(body1),
                                        headers: header1);

                                    log('RESPONSE MEET ENDED${response1.body}');

                                    if (response1.statusCode == 200) {
                                      Prefs.removeKey(Prefs.vcStartTime);
                                      Prefs.removeKey(Prefs.vcEndTime);

                                      Utils.showSnackBar('Appointment',
                                          'Provider Mark this appointment completed');

                                      setState(() {
                                        isLoadingMark = false;
                                      });

                                      refresh();
                                    } else {
                                      Utils.showSnackBar('Appointment',
                                          'Please try after some time!');
                                      setState(() {
                                        isLoadingMark = false;
                                      });
                                    }
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                        )
                      : const SizedBox();
            },
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }

  cameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.denied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to provide a Camera Permission'),
      ));
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    PermissionStatus microPhoneStatus = await Permission.microphone.request();

    if (microPhoneStatus == PermissionStatus.denied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to provide a MicroPhone Permission'),
      ));
    }
    if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  microPhonePermission() async {
    PermissionStatus microPhoneStatus = await Permission.microphone.request();
    if (microPhoneStatus == PermissionStatus.granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Permission Granted')));
    }
    if (microPhoneStatus == PermissionStatus.denied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You need to provide a MicroPhone Permission'),
      ));
    }
    if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  changeMeetingStatus({String? docId, String? s2}) async {
    String url1 = Constants.baseUrl + Constants.doctorZoomAction;

    Map<String, dynamic> body1 = {
      "doctor_id": docId,
      "meeting_id": s2,
      "meeting_status": 'ended'
    };

    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response1 = await http.post(Uri.parse(url1),
        body: jsonEncode(body1), headers: header1);
    log('RESPONSE MEET ENDED AGORA CALL${response1.body}');
  }

  startMeeting(
      {BuildContext? context,
      required String channelsName,
      required String tokens}) async {
    ///start meeting ///
    String url = Constants.baseUrl + Constants.doctorZoomMeeting;
    Map<String, dynamic> body = {
      "doctor_id": userController.user.value.id,
      "patient_id": widget.patientAppoint.patientId,
      "appointment_id": widget.patientAppoint.appointmentId,
      "meeting_id": channelsName,
      "meeting_password": tokens,
    };
    Map<String, String> header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: header);
    log('RESPONSE MEET ${response.body}');

    StoreMeetingCredantialResponseModel model =
        StoreMeetingCredantialResponseModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      await cameraPermission();

      if (model.status == 'Success') {
        id = model.data?.id;
        meetingID = model.data?.meetingId;

        /// update status
        String url1 = Constants.baseUrl + Constants.doctorZoomAction;
        Map<String, dynamic> body1 = {
          "doctor_id": userController.user.value.id,
          "id": model.data?.id.toString(),
          "meeting_id": model.data?.meetingId.toString(),
          "meeting_status": 'started'
        };

        Map<String, String> header1 = {
          "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
        };
        http.Response response1 = await http.post(Uri.parse(url1),
            body: jsonEncode(body1), headers: header1);

        log('response1==========>>>>>$response1');
      }
    } else {
      log('Please try again');
    }
    setState(() {
      isLoadingMeet = false;
    });
    if (!context!.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVideoCall(
          docId: userController.user.value.id,
          s1: model.data?.id.toString(),
          s2: model.data?.meetingId.toString(),
          token: tokens,
          channelName: channelsName,
        ),
      ),
    ).then(
      (value) async {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;

        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              "Appointment Completed",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "The appointment is completed kindly add Prescription and mark this appointment as completed",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      refresh();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "Add Prescription",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) async {
                          Navigator.pop(context);
                          await Future.delayed(Duration.zero).then(
                            (value) async {
                              if (!context.mounted) return;
                              await Navigator.of(context).pushNamed(
                                  Routes.addprescription,
                                  arguments: widget.patientAppoint);
                              refresh();
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
        setState(() {});
      },
    );
    setState(() {});
  }

  bool isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_IDLE";
    } else {
      result = status == "MEETING_STATUS_ENDED";
    }

    return result;
  }
}

Column _buildColumn({
  required BuildContext context,
  required String title,
  required subtitle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
    ],
  );
}
// }

_showAlert(BuildContext context, Function() onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cancel Client Appointment'),
        content: const Text("Are You Sure Want To Proceed ?"),
        actions: <Widget>[
          MaterialButton(
            onPressed: onPressed,
            child: const Text("YES"),
          ),
          MaterialButton(
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
