import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:doctor_appointment_booking/components/agora_video_call.dart';
import 'package:doctor_appointment_booking/components/custom_disable_button.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/doctor_get_doctor_Appointments_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/store_meeting_credantial_response_model.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/agora_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_builder/timer_builder.dart';

import '../routes/routes.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';

class UpcomingAppointmentListItemDoctor extends StatefulWidget {
  final PatientAppoint patientAppoint;
  final List dates;

  UpcomingAppointmentListItemDoctor(this.patientAppoint, this.dates);

  @override
  _UpcomingAppointmentListItemDoctorState createState() =>
      _UpcomingAppointmentListItemDoctorState();
}

class _UpcomingAppointmentListItemDoctorState
    extends State<UpcomingAppointmentListItemDoctor> {
  DoctorHomeScreenController _doctorHomeScreenController = Get.find();
  final UserController userController = Get.find();
  bool isLoading = false;
  Timer timer;
  bool isLoadingMeet = false;
  bool isLoadingMark = false;
  String id;
  String meetingID;

  AgoraController agoraController = Get.put(AgoraController());
  @override
  void initState() {
    agoraController.agoraController(userController.user.value.id);
    super.initState();
  }

  refresh() async {
    await _doctorHomeScreenController.getDoctorAppointmentsModel();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime startTime1 = Utils.formattedDate(
    //     '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}.000');
    // String hour = '${startTime1.hour - 1}';
    // String finalHour = hour.length == 1 ? "0" + hour : hour;
    // String sTime = startTime1.hour.toString().length == 1
    //     ? "0" + startTime1.hour.toString()
    //     : startTime1.hour.toString();
    //
    // DateTime startTime = Utils.formattedDate(
    //     '${widget.patientAppoint.appointmentDate} $finalHour:50:00.000');
    // DateTime showMarkAssCompletedTime = Utils.formattedDate(
    //     '${widget.patientAppoint.appointmentDate} $sTime:01:00.000');
    //
    // DateTime endTime = startTime1.add(Duration(hours: 1));

    DateTime startTime1 = Utils.formattedDate(
        '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}.000');

    // String hour = '${startTime1.hour - 1}';

    // String finalHour = hour.length == 1 ? "0" + hour : hour;

    // String sTime = startTime1.hour.toString().length == 1
    //     ? "0" + startTime1.hour.toString()
    //     : startTime1.hour.toString();

    DateTime startTime = startTime1.subtract(Duration(minutes: 15));

    log('startTime==========>>>>>$startTime');

    // DateTime.parse(
    //     '${DateFormat("yyyy-MM-dd").format(startTime1)} $hour:45:00.000');

    DateTime showMarkAssCompletedTime = startTime1.add(Duration(minutes: 5));

    // DateTime.parse(
    //     '${DateFormat("yyyy-MM-dd").format(startTime1)} ${int.parse(hour) + 1}:05:00.000');

    // DateTime showMarkAssCompletedTime = Utils.formattedDate(
    //     '${widget.patientAppoint.appointmentDate} $hour:01:00.000');

    DateTime endTime = startTime.add(Duration(hours: 1));

    DateTime time = Utils.formattedDate(
        '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}');

    bool rejoin = (widget.patientAppoint.meetingData.id.toString().isNotEmpty &&
        widget.patientAppoint.meetingData.password.toString().isNotEmpty);

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
                    SizedBox(
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
                              title: Translate.of(context).translate('date'),
                              subtitle:
                                  '${DateFormat('EEEE, dd MMM yyyy').format(time)}',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _buildColumn(
                              context: context,
                              title: Translate.of(context).translate('time'),
                              subtitle: '${DateFormat('hh:mm a').format(time)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
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
                              title: Translate.of(context)
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
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: widget.patientAppoint.appointmentStatus == '3'
                            ? SizedBox()
                            : widget.patientAppoint.appointmentStatus == '1'
                                ? CustomDisableButton(
                                    text: Translate.of(context)
                                        .translate('Accepted'),
                                    textSize: 16,
                                    onPressed: null,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  )
                                : isLoading
                                    ? Container(
                                        height: 60,
                                        child: Center(
                                          child: Utils.circular(height: 60),
                                        ),
                                      )
                                    : CustomButton(
                                        text: Translate.of(context)
                                            .translate('Accept'),
                                        textSize: 16,
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await _doctorHomeScreenController
                                              .startAppointmentPatient(
                                                  widget
                                                      .patientAppoint.doctorId,
                                                  widget.patientAppoint.id);
                                          refresh();

                                          Utils.showSnackBar('Accepted',
                                              'Appointment accepted!');

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                      ),
                      Container(
                        width: double.infinity,
                        child: widget.patientAppoint.appointmentStatus != '2'
                            ? rejoin
                                ? CustomButton(
                                    text: Translate.of(context)
                                        .translate('Add prescription'),
                                    textSize: 14,
                                    onPressed: () async {
                                      await Get.toNamed(Routes.addprescription,
                                              arguments: widget.patientAppoint)
                                          .then((value) => refresh());
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  )
                                : SizedBox()
                            : CustomButton(
                                text: Translate.of(context)
                                    .translate('Add prescription'),
                                textSize: 14,
                                onPressed: () async {
                                  await Get.toNamed(Routes.addprescription,
                                          arguments: widget.patientAppoint)
                                      .then((value) => refresh());
                                },
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                      ),
                      Builder(
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            child: widget.patientAppoint.appointmentStatus ==
                                    '3'
                                ? CustomOutlineButton(
                                    text: 'Declined',
                                    textSize: 14,
                                    onPressed: null,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  )
                                : CustomOutlineButton(
                                    text: Translate.of(context)
                                        .translate('Decline'),
                                    textSize: 14,
                                    onPressed: () => _showAlert(
                                      context,
                                      () async {
                                        Navigator.of(context).pop();

                                        await _doctorHomeScreenController
                                            .cancelAppointmentPatient(
                                                widget.patientAppoint.doctorId,
                                                widget.patientAppoint.id)
                                            .then((value) => refresh());
                                      },
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                                  ? Container(
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
                                              channelsName: widget
                                                  .patientAppoint
                                                  .meetingData
                                                  .id,
                                              tokens: widget.patientAppoint
                                                  .meetingData.password);

                                          await Future.delayed(
                                                  Duration(seconds: 5))
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
                                              startMeeting(
                                                  context: context,
                                                  channelsName: getAgoraToken
                                                      .data.channelName,
                                                  tokens:
                                                      getAgoraToken.data.token);
                                            } catch (e) {
                                              setState(() {
                                                isLoadingMeet = false;
                                              });
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Something Went to Wrong')));
                                          }
                                        } else {
                                          print(response.reasonPhrase);
                                        }

                                        // try {
                                        //   setState(() {
                                        //     isLoadingMeet = true;
                                        //   });
                                        //   startMeeting(context);
                                        //   Navigator.push(context,
                                        //       MaterialPageRoute(builder:
                                        //           (BuildContext context) {
                                        //     return MeetingWidget();
                                        //   }));
                                        // } catch (e) {
                                        //   setState(() {
                                        //     isLoadingMeet = false;
                                        //   });
                                        //   print('$e');
                                        // }
                                      },
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                            )
                          : SizedBox()
                      : SizedBox();
            },
          ),
          TimerBuilder.scheduled(
            [showMarkAssCompletedTime, endTime],
            builder: (context) {
              final now = DateTime.now();
              final started = now.compareTo(showMarkAssCompletedTime) >= 0;

              // final ended = now.compareTo(endTime) >= 0;

              return widget.patientAppoint.appointmentStatus == '1' &&
                      !started &&
                      !rejoin
                  ? SizedBox()
                  : widget.patientAppoint.appointmentStatus == '2' ||
                          started ||
                          rejoin
                      /*? ended
                      ? SizedBox()*/
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoadingMark == true
                              // ? Center(child: CircularProgressIndicator())
                              ? Container(
                                  height: 60,
                                  child: Center(
                                    child: Utils.circular(height: 60),
                                  ),
                                )
                              : CustomButton(
                                  text: 'Mark this appointment completed',
                                  textSize: 18,
                                  onPressed: () async {
                                    // if (widget.dates.any((element) =>
                                    //         DateTime.parse(element)
                                    //             .isBefore(startTime1)) &&
                                    //     widget.patientAppoint
                                    //             .appointmentStatus ==
                                    //         '1') {
                                    //   Utils.showSnackBar('Warning',
                                    //       'Please mark past appointment as completed first');
                                    //   return null;
                                    // }

                                    setState(() {
                                      isLoadingMark = true;
                                    });

                                    changeMeetingStatus(
                                      docId: userController.user.value.id,
                                      s2: widget.patientAppoint.meetingData.id,
                                    );

                                    print(
                                        'appoimtment id ${widget.patientAppoint.id}');
                                    String url1 =
                                        '${Constants.baseUrl + Constants.doctorCompleteAppointment}';

                                    DateTime start;
                                    DateTime end;
                                    String meetingDuration;

                                    if (Prefs.getString(Prefs.vcStartTime) !=
                                            null &&
                                        Prefs.getString(Prefs.vcEndTime) !=
                                            null) {
                                      start = DateTime.parse(
                                          Prefs.getString(Prefs.vcStartTime));

                                      end = DateTime.parse(
                                          Prefs.getString(Prefs.vcEndTime));

                                      if (start != null && end != null) {
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
                                    }

                                    Map<String, dynamic> body1 = {
                                      "doctor_id": userController.user.value.id,
                                      "appointment_id":
                                          widget.patientAppoint.id,
                                      "vc_start_time": "$start",
                                      "vc_end_time": "$end",
                                      "vc_duration": "$meetingDuration"
                                    };

                                    log('RESPONSE MEET UPDATE$body1');

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
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                ),
                        )
                      // : SizedBox()
                      : SizedBox();
            },
          ),
          SizedBox(height: 5)
          // ElevatedButton(
          //   onPressed: () {
          //     startMeeting(context);
          //   },
          //   child: Text('ZoomSdkDemo'),
          // )
        ],
      ),
    );
  }

  // Future getAgoraToken() async {
  //   http.Response response = await http.get(
  //     Uri.parse(
  //         'http://www.unhbackend.com/AppServices/common/agoraToken/${Prefs.getString(Prefs.SOCIALID)}'),
  //   );
  //   if (response.statusCode == 200) {
  //     var result = jsonDecode(response.body);
  //     log('agora token---------$result');
  //     return result;
  //   } else {}
  // }

  // cameraPermission() async {
  //   PermissionStatus cameraStatus;
  //   if (cameraStatus == PermissionStatus.granted) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
  //   }
  //   if (cameraStatus == PermissionStatus.denied) {
  //     cameraStatus = await Permission.camera.request();
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('You need to provide a Camera Permission'),
  //     ));
  //   }
  //   if (cameraStatus == PermissionStatus.permanentlyDenied) {
  //     openAppSettings();
  //   }
  //
  //   PermissionStatus microPhoneStatus ;
  //   if (microPhoneStatus == PermissionStatus.granted) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
  //   }
  //   if (microPhoneStatus == PermissionStatus.denied) {
  //     microPhoneStatus = await Permission.microphone.request();
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('You need to provide a MicroPhone Permission'),
  //     ));
  //   }
  //   if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  cameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You need to provide a Camera Permission'),
      ));
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    PermissionStatus microPhoneStatus = await Permission.microphone.request();

    if (microPhoneStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Permission Granted')));
    }
    if (microPhoneStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You need to provide a MicroPhone Permission'),
      ));
    }
    if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  changeMeetingStatus({String docId, String s2}) async {
    String url1 = '${Constants.baseUrl + Constants.doctorZoomAction}';

    Map<String, dynamic> body1 = {
      "doctor_id": docId,
      "meeting_id": s2,
      "meeting_status": 'ended'
    };

    log('RESPONSE========MEET========UPDATE========>$body1');

    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response1 = await http.post(Uri.parse(url1),
        body: jsonEncode(body1), headers: header1);
    log('RESPONSE MEET ENDED AGORA CALL${response1.body}');
    print("[Meeting Status] :- Ended");
  }

  startMeeting(
      {BuildContext context,
      @required String channelsName,
      @required String tokens}) async {
    ///start meeting ///
    String url = '${Constants.baseUrl + Constants.doctorZoomMeeting}';
    Map<String, dynamic> body = {
      "doctor_id": userController.user.value.id,
      "patient_id": widget.patientAppoint.patientId,
      "appointment_id": widget.patientAppoint.appointmentId,

      // "meeting_id": meetingDetailsResult[0],
      //"meeting_password": meetingDetailsResult[1]
      "meeting_id": '$channelsName',
      "meeting_password": '$tokens',
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
      // await agoraController.agoraController();

      await cameraPermission();

      if (model.status == 'Success') {
        id = model.data.id;
        meetingID = model.data.meetingId;
        log('id==============${model.data.meetingId.toString()}');

        /// update status
        String url1 = '${Constants.baseUrl + Constants.doctorZoomAction}';
        Map<String, dynamic> body1 = {
          "doctor_id": userController.user.value.id,
          "id": '${model.data.id.toString()}',
          "meeting_id": '${model.data.meetingId.toString()}',
          "meeting_status": 'started'
        };
        log('RESPONSE MEET UPDATE$body1');

        Map<String, String> header1 = {
          "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
        };
        http.Response response1 = await http.post(Uri.parse(url1),
            body: jsonEncode(body1), headers: header1);
        log('RESPONSE MEET UPDATE ZOOM ${response1.body}');
///////////////////////////////////

      }
    } else {
      log('Please try again');
    }
    setState(() {
      isLoadingMeet = false;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVideoCall(
          docId: userController.user.value.id,
          s1: '${model.data.id.toString()}',
          s2: '${model.data.meetingId.toString()}',
          token: '$tokens',
          channelName: '$channelsName',
        ),
      ),
    ).then(
      (value) async {
        await Future.delayed(Duration(milliseconds: 500));

        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => new AlertDialog(
            title: Text(
              "Appointment Completed",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "The appointment is completed kindly add Prescription and mark this appointment as completed"),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                      refresh();
                    },
                  ),
                  TextButton(
                    child: Text("Add Prescription"),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) async {
                          Navigator.pop(context);
                          await Future.delayed(Duration.zero).then(
                            (value) async {
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
    // final endTime = meetingEndTime;
    /* await Get.toNamed(Routes.addprescription, arguments: widget.patientAppoint);

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: Text(
          "Appointment completed",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "The appointment is completed please mark this appointment as completed"),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );*/

    // meetingEndTime = endTime;
    setState(() {});
  }

  bool isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid) {
      result = status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_IDLE";
      print('status $result');
      print('status $status');
    } else {
      result = status == "MEETING_STATUS_ENDED";
      print('status $result');
      print('status $status');
    }

    return result;
  }

// ZoomOptions zoomOptions = new ZoomOptions(
//   domain: "zoom.us",
//   // appKey: "6UolodTzvCegwhymYWspR7lAcE6YsZlQgI7v", //API KEY FROM ZOOM
//   appKey: "DH2t0pFNREEirS6mvQx6DL37qREapObvlVcX", //API KEY FROM ZOOM
//   //appSecret: "N5Zh2pHGUaMzKVMP8rZxfr357OV4u3RaCGqr",
//   appSecret: "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw",
//   // "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw",
// );
// var meetingOptions = new ZoomMeetingOptions(
//     //userId: 'indigenoushealthapp@gmail.com', //pass host email for zoom
//     userId: 'nevilrv@gmail.com', //pass host email for zoom
//     //  userPassword: 'oikLfd5asdaD&^ihj;kl', //pass host password for zoom
//     userPassword: 'Nevil@9120', //pass host password for zoom
//     disableDialIn: "false",
//     disableDrive: "false",
//     disableInvite: "false",
//     disableShare: "false",
//     disableTitlebar: "false",
//     viewOptions: "false",
//     noAudio: "false",
//     noDisconnectAudio: "false");

// var zoom = ZoomView();
//   zoom.initZoom(zoomOptions).then((results) {
//     if (results[0] == 0) {
//       zoom.onMeetingStatus().listen((status) async {
//         print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//         if (_isMeetingEnded(status[0])) {
//           setState(() {
//             isLoadingMeet = false;
//           });
//           String url1 =
//               '${Constants.baseUrl}Doctor/zoom_action';
//           Map<String, dynamic> body1 = {
//             "doctor_id": Prefs.getString(Prefs.SOCIALID),
//             "id": id,
//             "meeting_id": meetingID,
//             "meeting_status": 'ended'
//           };
//           log('RESPONSE MEET UPDATE${body1}');
//
//           Map<String, String> header1 = {
//             "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
//           };
//           http.Response response1 = await http.post(Uri.parse(url1),
//               body: jsonEncode(body1), headers: header1);
//           log('RESPONSE MEET ENDED${response1.body}');
//
//           print("[Meeting Status] :- Ended");
//           timer.cancel();
//         }
//         if (status[0] == "MEETING_STATUS_INMEETING") {
//           zoom.meetinDetails().then((meetingDetailsResult) async {
//             ///start meeting
//
//             String url =
//                 '${Constants.baseUrl}Doctor/zoom_meeting';
//             Map<String, dynamic> body = {
//               "doctor_id": Prefs.getString(Prefs.SOCIALID),
//               "patient_id": widget.patientAppoint.patientId,
//               "meeting_id": meetingDetailsResult[0],
//               "meeting_password": meetingDetailsResult[1]
//             };
//             Map<String, String> header = {
//               "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
//             };
//             http.Response response = await http.post(Uri.parse(url),
//                 body: jsonEncode(body), headers: header);
//             log('RESPONSE MEET ${response.body}');
//             StoreMeetingCredantialResponseModel model =
//                 StoreMeetingCredantialResponseModel.fromJson(
//                     jsonDecode(response.body));
//
//             if (model.status == 'Success') {
//               id = model.data.id;
//               meetingID = model.data.meetingId;
//
//               /// update status
//               String url1 =
//                   '${Constants.baseUrl}Doctor/zoom_action';
//               Map<String, dynamic> body1 = {
//                 "doctor_id": Prefs.getString(Prefs.SOCIALID),
//                 "id": '${model.data.id.toString()}',
//                 "meeting_id": '${model.data.meetingId.toString()}',
//                 "meeting_status": 'started'
//               };
//               log('RESPONSE MEET UPDATE${body1}');
//
//               Map<String, String> header1 = {
//                 "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
//               };
//               http.Response response1 = await http.post(Uri.parse(url1),
//                   body: jsonEncode(body1), headers: header1);
//               log('RESPONSE MEET UPDATE${response1.body}');
//             } else {
//               log('Please try again');
//             }
//
//             log('RESPONSE Model ${model.data.id}');
//             log('ID::${meetingDetailsResult[0]}');
//             log('PASSWORD::${meetingDetailsResult[1]}');
//
//             print("[MeetingDetailsResult] :- " +
//                 meetingDetailsResult.toString());
//             setState(() {
//               isLoadingMeet = false;
//             });
//           });
//         }
//       });
//       zoom.startMeeting(meetingOptions).then((loginResult) {
//         print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
//         if (loginResult[0] == "SDK ERROR") {
//           //SDK INIT FAILED
//           setState(() {
//             isLoadingMeet = false;
//           });
//
//           print((loginResult[1]).toString());
//         } else if (loginResult[0] == "LOGIN ERROR") {
//           setState(() {
//             isLoadingMeet = false;
//           });
//
//           //LOGIN FAILED - WITH ERROR CODES
//         //   if (loginResult[1] ==
//         //       ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
//         //     print("Multiple Failed Login Attempts");
//         //   }
//         //   print((loginResult[1]).toString());
//         // } else {
//         //   //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
//         //   print((loginResult[0]).toString());
//         // }
//       }});
//     }
//   }).catchError((error) {
//     // print("[Error Generated] : " + );error;
//   });
}

Column _buildColumn({
  @required BuildContext context,
  @required String title,
  @required subtitle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
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
            .subtitle1
            .copyWith(fontWeight: FontWeight.w500),
      ),
    ],
  );
}
// }

_showAlert(BuildContext context, Function onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cancel Client Appointment'),
        content: Text("Are You Sure Want To Proceed ?"),
        actions: <Widget>[
          MaterialButton(
            child: Text("YES"),
            onPressed: onPressed,
            //     () {
            //   //Put your code here which you want to execute on Yes button click.
            //   Navigator.of(context).pop();
            // },
          ),
          MaterialButton(
            child: Text("NO"),
            onPressed: () {
              //Put your code here which you want to execute on No button click.
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

///
///
///
///
/// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:developer';
// // import 'dart:io';
// // import 'package:doctor_appointment_booking/components/agora_video_call.dart';
// // import 'package:doctor_appointment_booking/components/custom_disable_button.dart';
// // import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
// // import 'package:doctor_appointment_booking/data/pref_manager.dart';
// // import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// // import 'package:doctor_appointment_booking/model/doctor_get_doctor_Appointments_model.dart';
// // import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_agora_token_model.dart';
// // import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/store_meeting_credantial_response_model.dart';
// // import 'package:doctor_appointment_booking/utils/constants.dart';
// // import 'package:doctor_appointment_booking/utils/utils.dart';
// // import 'package:doctor_appointment_booking/viewModel/agora_view_model.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // // import 'package:flutter_zoom_sdk/zoom_options.dart';
// // // import 'package:flutter_zoom_sdk/zoom_view.dart';
// // import 'package:get/get.dart' hide Trans;
// // import 'package:http/http.dart' as http;
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:timer_builder/timer_builder.dart';
// // // import '../agora_video_call_demo.dart';
// // import '../routes/routes.dart';
// // import 'custom_button.dart';
// // import 'custom_outline_button.dart';
// //
// // class UpcomingAppointmentListItemDoctor extends StatefulWidget {
// //   final PatientAppoint patientAppoint;
// //
// //   UpcomingAppointmentListItemDoctor(this.patientAppoint);
// //
// //   @override
// //   _UpcomingAppointmentListItemDoctorState createState() =>
// //       _UpcomingAppointmentListItemDoctorState();
// // }
// //
// // class _UpcomingAppointmentListItemDoctorState
// //     extends State<UpcomingAppointmentListItemDoctor> {
// //   DoctorHomeScreenController _doctorHomeScreenController = Get.find();
// //   bool isLoading = false;
// //   Timer timer;
// //   bool isLoadingMeet = false;
// //   bool isLoadingMark = false;
// //   String id;
// //   String meetingID;
// //
// //   AgoraController agoraController = Get.put(AgoraController());
// //   @override
// //   void initState() {
// //     agoraController.agoraController();
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     DateTime startTime1 = DateTime.parse(
// //         '${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}.000');
// //     String hour = '${startTime1.hour - 1}';
// //     String finalHour = hour.length == 1 ? "0" + hour : hour;
// //     String sTime = startTime1.hour.toString().length == 1
// //         ? "0" + startTime1.hour.toString()
// //         : startTime1.hour.toString();
// //
// //     log('finalHour.length---------->>>>>>>>${startTime1.hour.toString().length}');
// //
// //     log('1---------------$finalHour----->>>>>>>>${widget.patientAppoint.appointmentDate}');
// //     log('2---------------${startTime1.hour}------>>>>>>>>${widget.patientAppoint.appointmentDate}');
// //     DateTime startTime = DateTime.parse(
// //         '${widget.patientAppoint.appointmentDate} $finalHour:50:00.000');
// //     DateTime showMarkAssCompletedTime = DateTime.parse(
// //         '${widget.patientAppoint.appointmentDate} ${sTime}:01:00.000');
// //
// //     DateTime endTime = startTime1.add(Duration(hours: 1));
// //
// //     return Card(
// //       child: Column(
// //         children: [
// //           Row(
// //             children: <Widget>[
// //               Expanded(
// //                 flex: 2,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: <Widget>[
// //                     SizedBox(
// //                       height: 20,
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 15),
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: <Widget>[
// //                           Expanded(
// //                             child: _buildColumn(
// //                               context: context,
// //                               title: Translate.of(context).translate('date'),
// //                               subtitle:
// //                                   '${DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse('${widget.patientAppoint.appointmentDate}'))}',
// //                             ),
// //                           ),
// //                           SizedBox(
// //                             width: 10,
// //                           ),
// //                           Expanded(
// //                             child: _buildColumn(
// //                               context: context,
// //                               title: Translate.of(context).translate('time'),
// //                               subtitle:
// //                                   '${DateFormat('hh:mm a').format(DateTime.parse('${widget.patientAppoint.appointmentDate} ${widget.patientAppoint.appointmentTime}'))}',
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 15,
// //                     ),
// //                     Divider(
// //                       height: 1,
// //                       thickness: 1,
// //                       indent: 10,
// //                       endIndent: 10,
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.all(15),
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: <Widget>[
// //                           Expanded(
// //                             child: _buildColumn(
// //                               context: context,
// //                               title: Translate.of(context)
// //                                   .translate('Client Name'),
// //                               subtitle:
// //                                   '${widget.patientAppoint.patientFirstName} ${widget.patientAppoint.patientLastName}',
// //                             ),
// //                           ),
// //                           Expanded(
// //                             child: _buildColumn(
// //                               context: context,
// //                               title: 'Purpose of Visit',
// //                               subtitle:
// //                                   '${widget.patientAppoint.purposeOfVisit}',
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(
// //                 width: 10,
// //               ),
// //               Expanded(
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(right: 15),
// //                   child: Column(
// //                     children: <Widget>[
// //                       Container(
// //                         width: double.infinity,
// //                         child: widget.patientAppoint.appointmentStatus == '1'
// //                             ? CustomDisableButton(
// //                                 text:
// //                                     Translate.of(context).translate('Accepted'),
// //                                 // text: 'Finished'.tr(),
// //                                 textSize: 16,
// //                                 onPressed: null,
// //                                 padding: EdgeInsets.symmetric(
// //                                   vertical: 10,
// //                                 ),
// //                               )
// //                             : isLoading
// //                                 ? Center(
// //                                     child: SizedBox(
// //                                       height: 25,
// //                                       width: 25,
// //                                       child: CircularProgressIndicator(
// //                                         strokeWidth: 1,
// //                                       ),
// //                                     ),
// //                                   )
// //                                 : CustomButton(
// //                                     text: Translate.of(context)
// //                                         .translate('Accept'),
// //                                     textSize: 16,
// //                                     onPressed: () async {
// //                                       setState(() {
// //                                         isLoading = true;
// //                                       });
// //                                       await _doctorHomeScreenController
// //                                           .startAppointmentPatient(
// //                                               widget.patientAppoint.doctorId,
// //                                               widget.patientAppoint.id);
// //                                       await _doctorHomeScreenController
// //                                           .getDoctorAppointmentsModel();
// //
// //                                       Utils.showSnackBar(
// //                                           title: 'Accepted',
// //                                           message: 'Appointment accepted!');
// //
// //                                       setState(() {
// //                                         isLoading = false;
// //                                       });
// //                                     },
// //                                     padding: EdgeInsets.symmetric(
// //                                       vertical: 10,
// //                                     ),
// //                                   ),
// //                       ),
// //                       Container(
// //                         width: double.infinity,
// //                         child: widget.patientAppoint.prescriptionCount == 0
// //                             ? CustomButton(
// //                                 text: Translate.of(context)
// //                                     .translate('Edit prescription'),
// //                                 textSize: 14,
// //                                 onPressed: () {
// //                                   Get.toNamed(Routes.addprescription,
// //                                       arguments: widget.patientAppoint);
// //                                 },
// //                                 padding: EdgeInsets.symmetric(
// //                                   vertical: 10,
// //                                 ),
// //                               )
// //                             : CustomButton(
// //                                 text: Translate.of(context)
// //                                     .translate('Add prescription'),
// //                                 textSize: 14,
// //                                 onPressed: () {
// //                                   Get.toNamed(Routes.addprescription,
// //                                       arguments: widget.patientAppoint);
// //                                 },
// //                                 padding: EdgeInsets.symmetric(vertical: 10),
// //                               ),
// //                       ),
// //                       Builder(
// //                         builder: (context) {
// //                           return Container(
// //                             width: double.infinity,
// //                             child: widget.patientAppoint.appointmentStatus ==
// //                                     '3'
// //                                 ? CustomOutlineButton(
// //                                     text: 'Declined',
// //                                     textSize: 14,
// //                                     onPressed: null,
// //                                     padding: EdgeInsets.symmetric(vertical: 10),
// //                                   )
// //                                 : CustomOutlineButton(
// //                                     text: Translate.of(context)
// //                                         .translate('Decline'),
// //                                     textSize: 14,
// //                                     onPressed: () => _showAlert(
// //                                       context,
// //                                       () {
// //                                         _doctorHomeScreenController
// //                                             .cancelAppointmentPatient(
// //                                                 widget.patientAppoint.doctorId,
// //                                                 widget.patientAppoint.id);
// //                                         Navigator.of(context).pop();
// //                                       },
// //                                     ),
// //                                     padding: EdgeInsets.symmetric(vertical: 10),
// //                                   ),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ),
// //           TimerBuilder.scheduled(
// //             [startTime, endTime],
// //             builder: (context) {
// //               final now = DateTime.now();
// //               final started = now.compareTo(startTime) >= 0;
// //               final ended = now.compareTo(endTime) >= 0;
// //               return isLoadingMeet == true
// //                   ? Center(child: CircularProgressIndicator())
// //                   : widget.patientAppoint.appointmentStatus == '1'
// //                       ? Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: isLoadingMeet == true
// //                               ? Center(child: CircularProgressIndicator())
// //                               : CustomButton(
// //                                   text: 'Start Meeting',
// //                                   textSize: 18,
// //                                   onPressed: () async {
// //                                     print('start meeting');
// //                                     var headers = {
// //                                       'Authorization':
// //                                           'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //                                       'Cookie':
// //                                           'ci_session=5d272013f8aaa1d629bb834a68b3d0178d0454e3'
// //                                     };
// //                                     var request = http.MultipartRequest(
// //                                         'GET',
// //                                         Uri.parse(
// //                                             'http://www.unhbackend.com/AppServices/common/agoraToken/${DateTime.now().millisecondsSinceEpoch}'));
// //
// //                                     request.headers.addAll(headers);
// //
// //                                     http.StreamedResponse response =
// //                                         await request.send();
// //
// //                                     if (response.statusCode == 200) {
// //                                       agoraController.meetingStartTime =
// //                                           DateTime.now();
// //
// //                                       log('agoraController.meetingStartTime-----1----->>>>>>>>${agoraController.meetingStartTime}');
// //                                       log('agoraController.meetingStartTime-----1----->>>>>>>>${agoraController.meetingEndTime}');
// //
// //                                       var agoraData =
// //                                           await response.stream.bytesToString();
// //
// //                                       GetAgoraToken getAgoraToken =
// //                                           GetAgoraToken.fromJson(
// //                                               jsonDecode(agoraData));
// //
// //                                       if (getAgoraToken.status == 'Success') {
// //                                         try {
// //                                           setState(() {
// //                                             isLoadingMeet = true;
// //                                           });
// //                                           startMeeting(
// //                                               context: context,
// //                                               channelsName: getAgoraToken
// //                                                   .data.channelName,
// //                                               tokens: getAgoraToken.data.token);
// //                                         } catch (e) {
// //                                           setState(() {
// //                                             isLoadingMeet = false;
// //                                           });
// //                                         }
// //                                       } else {
// //                                         ScaffoldMessenger.of(context)
// //                                             .showSnackBar(SnackBar(
// //                                                 content: Text(
// //                                                     'Something Went to Wrong')));
// //                                       }
// //
// //                                       log('+++++token++++++${getAgoraToken.data.token}');
// //                                     } else {
// //                                       print(response.reasonPhrase);
// //                                     }
// //
// //                                     // try {
// //                                     //   setState(() {
// //                                     //     isLoadingMeet = true;
// //                                     //   });
// //                                     //   startMeeting(context);
// //                                     //   Navigator.push(context,
// //                                     //       MaterialPageRoute(builder:
// //                                     //           (BuildContext context) {
// //                                     //     return MeetingWidget();
// //                                     //   }));
// //                                     // } catch (e) {
// //                                     //   setState(() {
// //                                     //     isLoadingMeet = false;
// //                                     //   });
// //                                     //   print('$e');
// //                                     // }
// //                                   },
// //                                   padding: EdgeInsets.symmetric(vertical: 10),
// //                                 ),
// //                         )
// //                       : started
// //                           ? ended
// //                               ? SizedBox()
// //                               : widget.patientAppoint.appointmentStatus == '1'
// //                                   ? Padding(
// //                                       padding: const EdgeInsets.all(8.0),
// //                                       child: isLoadingMeet == true
// //                                           ? Center(
// //                                               child:
// //                                                   CircularProgressIndicator())
// //                                           : CustomButton(
// //                                               text: 'Start Meeting',
// //                                               textSize: 18,
// //                                               onPressed: () async {
// //                                                 print('start meeting');
// //                                                 var headers = {
// //                                                   'Authorization':
// //                                                       'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //                                                   'Cookie':
// //                                                       'ci_session=5d272013f8aaa1d629bb834a68b3d0178d0454e3'
// //                                                 };
// //                                                 var request = http.MultipartRequest(
// //                                                     'GET',
// //                                                     Uri.parse(
// //                                                         'http://www.unhbackend.com/AppServices/common/agoraToken/${DateTime.now().millisecondsSinceEpoch}'));
// //
// //                                                 request.headers.addAll(headers);
// //
// //                                                 http.StreamedResponse response =
// //                                                     await request.send();
// //
// //                                                 if (response.statusCode ==
// //                                                     200) {
// //                                                   agoraController
// //                                                           .meetingStartTime =
// //                                                       DateTime.now();
// //
// //                                                   log('agoraController.meetingStartTime-----1----->>>>>>>>${agoraController.meetingStartTime}');
// //                                                   log('agoraController.meetingStartTime-----1----->>>>>>>>${agoraController.meetingEndTime}');
// //
// //                                                   var agoraData = await response
// //                                                       .stream
// //                                                       .bytesToString();
// //
// //                                                   GetAgoraToken getAgoraToken =
// //                                                       GetAgoraToken.fromJson(
// //                                                           jsonDecode(
// //                                                               agoraData));
// //
// //                                                   if (getAgoraToken.status ==
// //                                                       'Success') {
// //                                                     try {
// //                                                       setState(() {
// //                                                         isLoadingMeet = true;
// //                                                       });
// //                                                       startMeeting(
// //                                                           context: context,
// //                                                           channelsName:
// //                                                               getAgoraToken.data
// //                                                                   .channelName,
// //                                                           tokens: getAgoraToken
// //                                                               .data.token);
// //                                                     } catch (e) {
// //                                                       setState(() {
// //                                                         isLoadingMeet = false;
// //                                                       });
// //                                                     }
// //                                                   } else {
// //                                                     ScaffoldMessenger.of(
// //                                                             context)
// //                                                         .showSnackBar(SnackBar(
// //                                                             content: Text(
// //                                                                 'Something Went to Wrong')));
// //                                                   }
// //
// //                                                   log('+++++token++++++${getAgoraToken.data.token}');
// //                                                 } else {
// //                                                   print(response.reasonPhrase);
// //                                                 }
// //
// //                                                 // try {
// //                                                 //   setState(() {
// //                                                 //     isLoadingMeet = true;
// //                                                 //   });
// //                                                 //   startMeeting(context);
// //                                                 //   Navigator.push(context,
// //                                                 //       MaterialPageRoute(builder:
// //                                                 //           (BuildContext context) {
// //                                                 //     return MeetingWidget();
// //                                                 //   }));
// //                                                 // } catch (e) {
// //                                                 //   setState(() {
// //                                                 //     isLoadingMeet = false;
// //                                                 //   });
// //                                                 //   print('$e');
// //                                                 // }
// //                                               },
// //                                               padding: EdgeInsets.symmetric(
// //                                                   vertical: 10),
// //                                             ),
// //                                     )
// //                                   : SizedBox()
// //                           : SizedBox();
// //             },
// //           ),
// //           TimerBuilder.scheduled(
// //             [showMarkAssCompletedTime, endTime],
// //             builder: (context) {
// //               final now = DateTime.now();
// //               final started = now.compareTo(showMarkAssCompletedTime) >= 0;
// //               final ended = now.compareTo(endTime) >= 0;
// //               return started
// //                   ? ended
// //                       ? SizedBox()
// //                       : widget.patientAppoint.appointmentStatus == '1'
// //                           ? Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: isLoadingMark == true
// //                                   ? Center(child: CircularProgressIndicator())
// //                                   : CustomButton(
// //                                       text: 'Mark this appointment completed',
// //                                       textSize: 18,
// //                                       onPressed: () async {
// //                                         setState(() {
// //                                           isLoadingMark = true;
// //                                         });
// //                                         print(
// //                                             'appoimtment id ${widget.patientAppoint.id}');
// //                                         String url1 =
// //                                             '${Constants.baseUrl + Constants.doctorCompleteAppointment}';
// //
// //                                         final meetingStart =
// //                                             agoraController.meetingStartTime ==
// //                                                     null
// //                                                 ? "00:00:00"
// //                                                 : DateFormat('hh:mm:ss').format(
// //                                                     agoraController
// //                                                         .meetingStartTime);
// //                                         final meetingEnd = agoraController
// //                                                     .meetingEndTime ==
// //                                                 null
// //                                             ? "00:00:00"
// //                                             : DateFormat('hh:mm:ss').format(
// //                                                 agoraController.meetingEndTime);
// //
// //                                         final meetingDuration = agoraController
// //                                                         .meetingEndTime ==
// //                                                     null ||
// //                                                 agoraController.meetingEndTime
// //                                                         .difference(
// //                                                             agoraController
// //                                                                 .meetingStartTime)
// //                                                         .inMinutes
// //                                                         .toString() ==
// //                                                     "0"
// //                                             ? "1"
// //                                             : agoraController.meetingEndTime
// //                                                 .difference(agoraController
// //                                                     .meetingStartTime)
// //                                                 .inMinutes
// //                                                 .toString();
// //
// //                                         log('meetingStart---------->>>>>>>>$meetingStart');
// //                                         log('meetingEnd---------->>>>>>>>$meetingEnd');
// //                                         log('meetingDuration---------->>>>>>>>$meetingDuration');
// //
// //                                         Map<String, dynamic> body1 = {
// //                                           "doctor_id":
// //                                               Prefs.getString(Prefs.SOCIALID),
// //                                           "appointment_id":
// //                                               widget.patientAppoint.id,
// //                                           "vc_start_time": "$meetingStart",
// //                                           "vc_end_time": "$meetingEnd",
// //                                           "vc_duration": "$meetingDuration"
// //                                         };
// //                                         log('RESPONSE MEET UPDATE$body1');
// //
// //                                         Map<String, String> header1 = {
// //                                           "Content-Type": "application/json",
// //                                           "Authorization":
// //                                               'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //                                         };
// //                                         http.Response response1 =
// //                                             await http.post(Uri.parse(url1),
// //                                                 body: jsonEncode(body1),
// //                                                 headers: header1);
// //                                         log('RESPONSE MEET ENDED${response1.body}');
// //                                         if (response1.statusCode == 200) {
// //                                           Utils.showSnackBar(
// //                                               title: 'Appointment',
// //                                               message:
// //                                                   'Doctor Mark this appointment completed');
// //
// //                                           setState(() {
// //                                             isLoadingMark = false;
// //                                           });
// //
// //                                           await _doctorHomeScreenController
// //                                               .getDoctorAppointmentsModel();
// //                                         } else {
// //                                           Utils.showSnackBar(
// //                                               title: 'Appointment',
// //                                               message:
// //                                                   'Please try after some time!');
// //                                           setState(() {
// //                                             isLoadingMark = false;
// //                                           });
// //                                         }
// //                                       },
// //                                       padding:
// //                                           EdgeInsets.symmetric(vertical: 10),
// //                                     ),
// //                             )
// //                           : SizedBox()
// //                   : SizedBox();
// //             },
// //           ),
// //           SizedBox(height: 5)
// //           // ElevatedButton(
// //           //   onPressed: () {
// //           //     startMeeting(context);
// //           //   },
// //           //   child: Text('ZoomSdkDemo'),
// //           // )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Future getAgoraToken() async {
// //   //   http.Response response = await http.get(
// //   //     Uri.parse(
// //   //         'http://www.unhbackend.com/AppServices/common/agoraToken/${Prefs.getString(Prefs.SOCIALID)}'),
// //   //   );
// //   //   if (response.statusCode == 200) {
// //   //     var result = jsonDecode(response.body);
// //   //     log('agora token---------$result');
// //   //     return result;
// //   //   } else {}
// //   // }
// //
// //   // cameraPermission() async {
// //   //   PermissionStatus cameraStatus;
// //   //   if (cameraStatus == PermissionStatus.granted) {
// //   //     ScaffoldMessenger.of(context)
// //   //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
// //   //   }
// //   //   if (cameraStatus == PermissionStatus.denied) {
// //   //     cameraStatus = await Permission.camera.request();
// //   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //   //       content: Text('You need to provide a Camera Permission'),
// //   //     ));
// //   //   }
// //   //   if (cameraStatus == PermissionStatus.permanentlyDenied) {
// //   //     openAppSettings();
// //   //   }
// //   //
// //   //   PermissionStatus microPhoneStatus ;
// //   //   if (microPhoneStatus == PermissionStatus.granted) {
// //   //     ScaffoldMessenger.of(context)
// //   //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
// //   //   }
// //   //   if (microPhoneStatus == PermissionStatus.denied) {
// //   //     microPhoneStatus = await Permission.microphone.request();
// //   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //   //       content: Text('You need to provide a MicroPhone Permission'),
// //   //     ));
// //   //   }
// //   //   if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
// //   //     openAppSettings();
// //   //   }
// //   // }
// //
// //   cameraPermission() async {
// //     PermissionStatus cameraStatus = await Permission.camera.request();
// //     if (cameraStatus == PermissionStatus.granted) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text('Permission Granted')));
// //     }
// //     if (cameraStatus == PermissionStatus.denied) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('You need to provide a Camera Permission'),
// //       ));
// //     }
// //     if (cameraStatus == PermissionStatus.permanentlyDenied) {
// //       openAppSettings();
// //     }
// //
// //     PermissionStatus microPhoneStatus = await Permission.microphone.request();
// //     if (microPhoneStatus == PermissionStatus.granted) {
// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text('Permission Granted')));
// //     }
// //     if (microPhoneStatus == PermissionStatus.denied) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('You need to provide a MicroPhone Permission'),
// //       ));
// //     }
// //     if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
// //       openAppSettings();
// //     }
// //   }
// //
// //   // microPhonePermission() async {
// //   //   PermissionStatus microPhoneStatus = await Permission.microphone.request();
// //   //   if (microPhoneStatus == PermissionStatus.granted) {
// //   //     ScaffoldMessenger.of(context)
// //   //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
// //   //   }
// //   //   if (microPhoneStatus == PermissionStatus.denied) {
// //   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //   //       content: Text('You need to provide a MicroPhone Permission'),
// //   //     ));
// //   //   }
// //   //   if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
// //   //     openAppSettings();
// //   //   }
// //   // }
// //
// //   startMeeting(
// //       {BuildContext context,
// //       @required String channelsName,
// //       @required String tokens}) async {
// //     ///start meeting ///
// //     String url = '${Constants.baseUrl + Constants.doctorZoomMeeting}';
// //     Map<String, dynamic> body = {
// //       "doctor_id": Prefs.getString(Prefs.SOCIALID),
// //       "patient_id": widget.patientAppoint.patientId,
// //       // "meeting_id": meetingDetailsResult[0],
// //       //"meeting_password": meetingDetailsResult[1]
// //       "meeting_id": '$channelsName',
// //       "meeting_password": '$tokens',
// //     };
// //     Map<String, String> header = {
// //       "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //     };
// //     http.Response response = await http.post(Uri.parse(url),
// //         body: jsonEncode(body), headers: header);
// //     log('RESPONSE MEET ${response.body}');
// //
// //     StoreMeetingCredantialResponseModel model =
// //         StoreMeetingCredantialResponseModel.fromJson(jsonDecode(response.body));
// //     if (response.statusCode == 200) {
// //       // await agoraController.agoraController();
// //
// //       cameraPermission();
// //       //microPhonePermission();
// //
// //       if (model.status == 'Success') {
// //         id = model.data.id;
// //         meetingID = model.data.meetingId;
// //         log('id==============${model.data.meetingId.toString()}');
// //
// //         /// update status
// //         String url1 = '${Constants.baseUrl + Constants.doctorZoomAction}';
// //         Map<String, dynamic> body1 = {
// //           "doctor_id": Prefs.getString(Prefs.SOCIALID),
// //           "id": '${model.data.id.toString()}',
// //           "meeting_id": '${model.data.meetingId.toString()}',
// //           "meeting_status": 'started'
// //         };
// //         log('RESPONSE MEET UPDATE$body1');
// //
// //         Map<String, String> header1 = {
// //           "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //         };
// //         http.Response response1 = await http.post(Uri.parse(url1),
// //             body: jsonEncode(body1), headers: header1);
// //         log('RESPONSE MEET UPDATE ZOOM ${response1.body}');
// // ///////////////////////////////////
// //
// //       }
// //     } else {
// //       log('Please try again');
// //     }
// //     setState(() {
// //       isLoadingMeet = false;
// //     });
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => MyVideoCall(
// //           s1: '${model.data.id.toString()}',
// //           s2: '${model.data.meetingId.toString()}',
// //           token: '$tokens',
// //           channelName: '$channelsName',
// //         ),
// //       ),
// //     );
// //
// //     // final endTime = meetingEndTime;
// //     Get.toNamed(Routes.addprescription, arguments: widget.patientAppoint);
// //     // meetingEndTime = endTime;
// //   }
// //
// //   bool isMeetingEnded(String status) {
// //     var result = false;
// //
// //     if (Platform.isAndroid) {
// //       result = status == "MEETING_STATUS_DISCONNECTING" ||
// //           status == "MEETING_STATUS_IDLE";
// //       print('status $result');
// //       print('status $status');
// //     } else {
// //       result = status == "MEETING_STATUS_ENDED";
// //       print('status $result');
// //       print('status $status');
// //     }
// //
// //     return result;
// //   }
// //
// //   // ZoomOptions zoomOptions = new ZoomOptions(
// //   //   domain: "zoom.us",
// //   //   // appKey: "6UolodTzvCegwhymYWspR7lAcE6YsZlQgI7v", //API KEY FROM ZOOM
// //   //   appKey: "DH2t0pFNREEirS6mvQx6DL37qREapObvlVcX", //API KEY FROM ZOOM
// //   //   //appSecret: "N5Zh2pHGUaMzKVMP8rZxfr357OV4u3RaCGqr",
// //   //   appSecret: "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw",
// //   //   // "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw",
// //   // );
// //   // var meetingOptions = new ZoomMeetingOptions(
// //   //     //userId: 'indigenoushealthapp@gmail.com', //pass host email for zoom
// //   //     userId: 'nevilrv@gmail.com', //pass host email for zoom
// //   //     //  userPassword: 'oikLfd5asdaD&^ihj;kl', //pass host password for zoom
// //   //     userPassword: 'Nevil@9120', //pass host password for zoom
// //   //     disableDialIn: "false",
// //   //     disableDrive: "false",
// //   //     disableInvite: "false",
// //   //     disableShare: "false",
// //   //     disableTitlebar: "false",
// //   //     viewOptions: "false",
// //   //     noAudio: "false",
// //   //     noDisconnectAudio: "false");
// //
// //   // var zoom = ZoomView();
// //   //   zoom.initZoom(zoomOptions).then((results) {
// //   //     if (results[0] == 0) {
// //   //       zoom.onMeetingStatus().listen((status) async {
// //   //         print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
// //   //         if (_isMeetingEnded(status[0])) {
// //   //           setState(() {
// //   //             isLoadingMeet = false;
// //   //           });
// //   //           String url1 =
// //   //               '${Constants.baseUrl}Doctor/zoom_action';
// //   //           Map<String, dynamic> body1 = {
// //   //             "doctor_id": Prefs.getString(Prefs.SOCIALID),
// //   //             "id": id,
// //   //             "meeting_id": meetingID,
// //   //             "meeting_status": 'ended'
// //   //           };
// //   //           log('RESPONSE MEET UPDATE${body1}');
// //   //
// //   //           Map<String, String> header1 = {
// //   //             "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //   //           };
// //   //           http.Response response1 = await http.post(Uri.parse(url1),
// //   //               body: jsonEncode(body1), headers: header1);
// //   //           log('RESPONSE MEET ENDED${response1.body}');
// //   //
// //   //           print("[Meeting Status] :- Ended");
// //   //           timer.cancel();
// //   //         }
// //   //         if (status[0] == "MEETING_STATUS_INMEETING") {
// //   //           zoom.meetinDetails().then((meetingDetailsResult) async {
// //   //             ///start meeting
// //   //
// //   //             String url =
// //   //                 '${Constants.baseUrl}Doctor/zoom_meeting';
// //   //             Map<String, dynamic> body = {
// //   //               "doctor_id": Prefs.getString(Prefs.SOCIALID),
// //   //               "patient_id": widget.patientAppoint.patientId,
// //   //               "meeting_id": meetingDetailsResult[0],
// //   //               "meeting_password": meetingDetailsResult[1]
// //   //             };
// //   //             Map<String, String> header = {
// //   //               "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //   //             };
// //   //             http.Response response = await http.post(Uri.parse(url),
// //   //                 body: jsonEncode(body), headers: header);
// //   //             log('RESPONSE MEET ${response.body}');
// //   //             StoreMeetingCredantialResponseModel model =
// //   //                 StoreMeetingCredantialResponseModel.fromJson(
// //   //                     jsonDecode(response.body));
// //   //
// //   //             if (model.status == 'Success') {
// //   //               id = model.data.id;
// //   //               meetingID = model.data.meetingId;
// //   //
// //   //               /// update status
// //   //               String url1 =
// //   //                   '${Constants.baseUrl}Doctor/zoom_action';
// //   //               Map<String, dynamic> body1 = {
// //   //                 "doctor_id": Prefs.getString(Prefs.SOCIALID),
// //   //                 "id": '${model.data.id.toString()}',
// //   //                 "meeting_id": '${model.data.meetingId.toString()}',
// //   //                 "meeting_status": 'started'
// //   //               };
// //   //               log('RESPONSE MEET UPDATE${body1}');
// //   //
// //   //               Map<String, String> header1 = {
// //   //                 "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
// //   //               };
// //   //               http.Response response1 = await http.post(Uri.parse(url1),
// //   //                   body: jsonEncode(body1), headers: header1);
// //   //               log('RESPONSE MEET UPDATE${response1.body}');
// //   //             } else {
// //   //               log('Please try again');
// //   //             }
// //   //
// //   //             log('RESPONSE Model ${model.data.id}');
// //   //             log('ID::${meetingDetailsResult[0]}');
// //   //             log('PASSWORD::${meetingDetailsResult[1]}');
// //   //
// //   //             print("[MeetingDetailsResult] :- " +
// //   //                 meetingDetailsResult.toString());
// //   //             setState(() {
// //   //               isLoadingMeet = false;
// //   //             });
// //   //           });
// //   //         }
// //   //       });
// //   //       zoom.startMeeting(meetingOptions).then((loginResult) {
// //   //         print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
// //   //         if (loginResult[0] == "SDK ERROR") {
// //   //           //SDK INIT FAILED
// //   //           setState(() {
// //   //             isLoadingMeet = false;
// //   //           });
// //   //
// //   //           print((loginResult[1]).toString());
// //   //         } else if (loginResult[0] == "LOGIN ERROR") {
// //   //           setState(() {
// //   //             isLoadingMeet = false;
// //   //           });
// //   //
// //   //           //LOGIN FAILED - WITH ERROR CODES
// //   //         //   if (loginResult[1] ==
// //   //         //       ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
// //   //         //     print("Multiple Failed Login Attempts");
// //   //         //   }
// //   //         //   print((loginResult[1]).toString());
// //   //         // } else {
// //   //         //   //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
// //   //         //   print((loginResult[0]).toString());
// //   //         // }
// //   //       }});
// //   //     }
// //   //   }).catchError((error) {
// //   //     // print("[Error Generated] : " + );error;
// //   //   });
// // }
// //
// // Column _buildColumn({
// //   @required BuildContext context,
// //   @required String title,
// //   @required subtitle,
// // }) {
// //   return Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //     children: <Widget>[
// //       Text(
// //         title,
// //         style: TextStyle(
// //           color: Colors.grey,
// //           fontSize: 16,
// //           fontWeight: FontWeight.w400,
// //         ),
// //         maxLines: 1,
// //         overflow: TextOverflow.ellipsis,
// //       ),
// //       Text(
// //         subtitle,
// //         style: Theme.of(context)
// //             .textTheme
// //             .subtitle1
// //             .copyWith(fontWeight: FontWeight.w500),
// //       ),
// //     ],
// //   );
// // }
// // // }
// //
// // _showAlert(BuildContext context, Function onPressed) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text('Cancel Client Appointment'),
// //         content: Text("Are You Sure Want To Proceed ?"),
// //         actions: <Widget>[
// //           FlatButton(
// //             child: Text("YES"),
// //             onPressed: onPressed,
// //             //     () {
// //             //   //Put your code here which you want to execute on Yes button click.
// //             //   Navigator.of(context).pop();
// //             // },
// //           ),
// //           FlatButton(
// //             child: Text("NO"),
// //             onPressed: () {
// //               //Put your code here which you want to execute on No button click.
// //               Navigator.of(context).pop();
// //             },
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
///
