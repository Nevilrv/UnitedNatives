import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/components/agora_video_call.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/store_meeting_credantial_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:octo_image/octo_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_builder/timer_builder.dart';
import '../../../utils/constants.dart';

class NextAppointment2Widget extends StatefulWidget {
  const NextAppointment2Widget({super.key});

  @override
  State<NextAppointment2Widget> createState() => _NextAppointment2WidgetState();
}

class _NextAppointment2WidgetState extends State<NextAppointment2Widget> {
  final DoctorHomeScreenController _doctorHomeScreenController = Get.find();
  final PatientHomeScreenController _patientHomeScreenController = Get.find();

  PatientScheduledClassController patientScheduledClassController = Get.find();
  final UserController userController = Get.find();
  bool isLoadingMeet = false;
  bool isLoading = false;
  String? id;
  String? meetingID;
  bool isLoadingMark = false;

  refresh() async {
    await _doctorHomeScreenController.getDoctorHomePage();
    await _doctorHomeScreenController.filterData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<VisitedPatient>? dataList = _doctorHomeScreenController
            .doctorHomePageModelData.value.data?.upcomingAppointments;

        dataList?.sort((b, a) {
          String dateA = "${b.appointmentDate} ${b.appointmentTime}";
          String dateB = "${a.appointmentDate} ${a.appointmentTime}";
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        });

        VisitedPatient data = dataList!.first;

        final time = Utils.formattedDate(
            '${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}')}');

        bool rejoin = (data.meetingData!.id.toString().isNotEmpty &&
            data.meetingData!.password.toString().isNotEmpty);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: kColorBlue,
          ),
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
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(time),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
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
                          '${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}')}');

                      DateTime appointmentDate = DateTime.parse("$dateTime");

                      // String targetTime =
                      //     "${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}')}";

                      int difference =
                          dateTime.difference(currentTime).inMinutes;
                      bool isWithin5Minutes = difference <= 15;

                      return /*appointmentDate.difference(currentTime).inDays != 0
                          ? SizedBox()
                          : !isWithin5Minutes
                              ? SizedBox()
                              :*/
                          isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                )
                                  /*Container(
                                  height: 60,
                                  child: Center(
                                    child: Utils.circular(height: 60),
                                  ),
                                )*/
                                  .paddingOnly(right: Get.width * 0.05)
                              : CustomButton(
                                  textSize: 18,
                                  color: data.appointmentStatus == "0"
                                      ? Colors.white
                                      : appointmentDate
                                                  .difference(currentTime)
                                                  .inDays ==
                                              0
                                          ? !isWithin5Minutes
                                              ? Colors.white70
                                              : Colors.white
                                          : Colors.white70,

                                  fontColor: kColorBlue,
                                  text: data.appointmentStatus == "0"
                                      ? "Accept Appointment"
                                      : rejoin
                                          ? "Rejoin Meeting"
                                          : "Start Meeting",
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (data.appointmentStatus == "0") {
                                      await _doctorHomeScreenController
                                          .startAppointmentPatient(
                                              data.doctorId!,
                                              data.appointmentId);
                                      await _doctorHomeScreenController
                                          .getDoctorAppointmentsModel();
                                      Utils.showSnackBar(
                                          'Accepted', 'Appointment accepted!');
                                      setState(() {
                                        isLoading = false;
                                      });
                                      refresh();

                                      return;
                                    }

                                    if (appointmentDate
                                            .difference(currentTime)
                                            .inDays ==
                                        0) {
                                      if (!isWithin5Minutes) {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        return messageDialog(
                                            title: "Warning",
                                            message:
                                                'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(dateTime)} ${DateFormat("hh:mm a").format(dateTime)}. You can join meeting 15 minutes before the scheduled time',
                                            context: context);
                                      } else {
                                        if (rejoin) {
                                          final data1 = PatientAppoint(
                                            id: data.id,
                                            patientId: data.patientId,
                                            adminReadStat: data.adminReadStat,
                                            appointmentDate:
                                                data.appointmentDate,
                                            appointmentFor: data.appointmentFor,
                                            appointmentId: data.appointmentId,
                                            appointmentStatus:
                                                data.appointmentStatus,
                                            appointmentTime:
                                                data.appointmentTime,
                                            createdDate: data.createdDate,
                                            doctorId: data.doctorId,
                                            modifiedDate: data.modifiedDate,
                                            patientBloodGroup:
                                                data.patientBloodGroup,
                                            patientCaseManager:
                                                data.patientCaseManager,
                                            patientContactNumber:
                                                data.patientContactNumber,
                                            patientEmail: data.patientEmail,
                                            patientEmergencyContact:
                                                data.patientEmergencyContact,
                                            patientFirstName:
                                                data.patientFirstName,
                                            patientFullName:
                                                data.patientFullName,
                                            patientGender: data.patientGender,
                                            patientHeight: data.patientHeight,
                                            patientInsuranceEligibility: data
                                                .patientInsuranceEligibility,
                                            patientLastName:
                                                data.patientLastName,
                                            patientMaritalStatus:
                                                data.patientMaritalStatus,
                                            patientMobile: data.patientMobile,
                                            patientProfilePic:
                                                data.patientProfilePic,
                                            patientSocialProfilePic:
                                                data.patientSocialPic,
                                            patientTribalStatus:
                                                data.patientTribalStatus,
                                            patientWeight: data.patientWeight,
                                            prescriptionCount:
                                                data.prescriptionCount,
                                            purposeOfVisit: data.purposeOfVisit,
                                            userEmail: data.userEmail,
                                            userMobile: data.userMobile,
                                          );

                                          startMeeting(
                                                  patientAppoint: data1,
                                                  context: context,
                                                  channelsName:
                                                      data.meetingData!.id!,
                                                  tokens: data
                                                      .meetingData!.password!)
                                              .then((value) => refresh());

                                          await Future.delayed(
                                                  const Duration(seconds: 5))
                                              .then((value) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });

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
                                              // setState(() {
                                              //   isLoadingMeet = true;
                                              // });

                                              final data1 = PatientAppoint(
                                                id: data.id,
                                                patientId: data.patientId,
                                                adminReadStat:
                                                    data.adminReadStat,
                                                appointmentDate:
                                                    data.appointmentDate,
                                                appointmentFor:
                                                    data.appointmentFor,
                                                appointmentId:
                                                    data.appointmentId,
                                                appointmentStatus:
                                                    data.appointmentStatus,
                                                appointmentTime:
                                                    data.appointmentTime,
                                                createdDate: data.createdDate,
                                                doctorId: data.doctorId,
                                                modifiedDate: data.modifiedDate,
                                                patientBloodGroup:
                                                    data.patientBloodGroup,
                                                patientCaseManager:
                                                    data.patientCaseManager,
                                                patientContactNumber:
                                                    data.patientContactNumber,
                                                patientEmail: data.patientEmail,
                                                patientEmergencyContact: data
                                                    .patientEmergencyContact,
                                                patientFirstName:
                                                    data.patientFirstName,
                                                patientFullName:
                                                    data.patientFullName,
                                                patientGender:
                                                    data.patientGender,
                                                patientHeight:
                                                    data.patientHeight,
                                                patientInsuranceEligibility: data
                                                    .patientInsuranceEligibility,
                                                patientLastName:
                                                    data.patientLastName,
                                                patientMaritalStatus:
                                                    data.patientMaritalStatus,
                                                patientMobile:
                                                    data.patientMobile,
                                                patientProfilePic:
                                                    data.patientProfilePic,
                                                patientSocialProfilePic:
                                                    data.patientSocialPic,
                                                patientTribalStatus:
                                                    data.patientTribalStatus,
                                                patientWeight:
                                                    data.patientWeight,
                                                prescriptionCount:
                                                    data.prescriptionCount,
                                                purposeOfVisit:
                                                    data.purposeOfVisit,
                                                userEmail: data.userEmail,
                                                userMobile: data.userMobile,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (!context.mounted) return;
                                              await startMeeting(
                                                      patientAppoint: data1,
                                                      context: context,
                                                      channelsName:
                                                          getAgoraToken.data!
                                                              .channelName!,
                                                      tokens: getAgoraToken
                                                          .data!.token!)
                                                  .then((value) => refresh());
                                            } catch (e) {
                                              setState(() {
                                                isLoadingMeet = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              isLoadingMeet = false;
                                            });
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Something Went to Wrong'),
                                              ),
                                            );
                                          }
                                        }
                                      }

                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      return messageDialog(
                                          title: "Warning",
                                          message:
                                              'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(time)} ${DateFormat("hh:mm a").format(dateTime)}. You can join meeting 15 minutes before the scheduled time',
                                          context: context);

                                      // return Utils.showSnackBar(
                                      //     title: 'Warning',
                                      //     message:
                                      //         'Meeting scheduled on ${DateFormat('EEEE, d MMMM').format(DateTime.parse("${data.appointmentDate}"))} ${DateFormat("hh:mm a").format(DateTime.parse(targetTime))}. You can join meeting 10 minutes before the scheduled time');
                                    }
                                  },
                                  // icon: Icons.video_call,
                                );
                    },
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
                height: 40,
                thickness: 0.5,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: OctoImage(
                        image: CachedNetworkImageProvider(
                            (_doctorHomeScreenController
                                        .doctorHomePageModelData
                                        .value
                                        .data!
                                        .upcomingAppointments!
                                        .last
                                        .patientProfilePic
                                        .toString()
                                        .isEmpty
                                    ? _doctorHomeScreenController
                                        .doctorHomePageModelData
                                        .value
                                        .data!
                                        .upcomingAppointments
                                        ?.last
                                        .patientSocialPic
                                    : _doctorHomeScreenController
                                        .doctorHomePageModelData
                                        .value
                                        .data!
                                        .upcomingAppointments
                                        ?.last
                                        .patientProfilePic) ??
                                'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                        // placeholderBuilder: OctoPlaceholder.blurHash(
                        //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                        // ),
                        progressIndicatorBuilder: (context, progress) {
                          double? value;
                          var expectedBytes = progress?.expectedTotalBytes;
                          if (progress != null && expectedBytes != null) {
                            value =
                                progress.cumulativeBytesLoaded / expectedBytes;
                          }
                          return CircularProgressIndicator(value: value);
                        },
                        // errorBuilder: OctoError.circleAvatar(
                        //     backgroundColor: Colors.white,
                        //     text: Image.asset(
                        //       "assets/images/defaultProfile.png",
                        //       scale: 2,
                        //       fit: BoxFit.cover,
                        //     )),

                        errorBuilder: OctoError.circleAvatar(
                          backgroundColor: Colors.white,
                          text: Image.network(
                            'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                            color: const Color(0xFF7E7D7D),
                            // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                          ),
                        ),

                        fit: BoxFit.fill,
                        width: 56,
                        height: 56,
                      ),
                    ), /*CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('${_doctorHomeScreenController.doctorHomePageModelData.value.data.upcomingAppointments?.last?.patientProfilePic}'),
                  ),*/
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${data.patientFirstName} ${data.patientLastName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${data.purposeOfVisit}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: 102,
                  // ),
                ],
              ),

              /// MARK AS COMPLETED

              Builder(builder: (context) {
                // DateTime temp1 = DateTime.parse(
                //     '${data.appointmentDate} ${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour.toString().length == 1 ? "0" + DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour.toString() : DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour.toString()}:01:00.000');
                // DateTime temp2 = DateTime.parse(
                //         '${data.appointmentDate} ${'${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour - 1}'.length == 1 ? "0" + '${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour - 1}' : '${DateTime.parse('${data.appointmentDate} ${data.appointmentTime}.000').hour - 1}'}:06:00.000')
                //     .add(Duration(hours: 1));

                DateTime showMarkAssCompletedTime =
                    time.add(const Duration(minutes: 5));

                // DateTime.parse(
                //     '${DateFormat("yyyy-MM-dd").format(time)} ${time.hour}:${time.minute + 5}:00.000');

                // DateTime showMarkAssCompletedTime = Utils.formattedDate(
                //     '${data.appointmentDate} ${data.appointmentTime}');

                DateTime endTime =
                    showMarkAssCompletedTime.add(const Duration(minutes: 40));

                // log('showMarkAssCompletedTime==========>>>>>$showMarkAssCompletedTime');
                // log('endTime==========>>>>>$endTime');

                // showMarkAssCompletedTime==========>>>>>2024-06-11 14:05:00.000
                // endTime==========>>>>>2024-06-11 14:45:00.000

                return TimerBuilder.scheduled(
                  [showMarkAssCompletedTime, endTime],
                  builder: (context) {
                    final now = DateTime.now();
                    final started =
                        now.compareTo(showMarkAssCompletedTime) >= 0;
                    // final ended = now.compareTo(endTime) >= 0;

                    return data.appointmentStatus == '1' && !started && !rejoin
                        ? const SizedBox()
                        : data.appointmentStatus == '2' || started || rejoin
                            ? /*ended
                            ?*/
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isLoadingMark == true
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1,
                                        ),
                                      )
                                    // Center(
                                    //     child: Utils.circular(),
                                    //   )
                                    : CustomButton(
                                        color: Colors.white,
                                        fontColor: kColorBlue,
                                        text: 'Mark this appointment completed',
                                        textSize: 18,
                                        onPressed: () async {
                                          setState(() {
                                            isLoadingMark = true;
                                          });

                                          changeMeetingStatus(
                                              docId:
                                                  "${userController.user.value.id}",
                                              s2: "${data.meetingData?.id}");

                                          String url1 = Constants.baseUrl +
                                              Constants
                                                  .doctorCompleteAppointment;
                                          String? meetingDuration;
                                          DateTime? start;
                                          DateTime? end;

                                          if (Prefs.getString(
                                                      Prefs.vcStartTime) !=
                                                  null &&
                                              Prefs.getString(
                                                      Prefs.vcEndTime) !=
                                                  null) {
                                            start = DateTime.parse(
                                                Prefs.getString(
                                                        Prefs.vcStartTime) ??
                                                    "");

                                            end = DateTime.parse(
                                                Prefs.getString(
                                                        Prefs.vcEndTime) ??
                                                    "");

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
                                            "doctor_id":
                                                userController.user.value.id,
                                            "appointment_id":
                                                data.appointmentId,
                                            "vc_start_time": "$start",
                                            "vc_end_time": "$end",
                                            "vc_duration": meetingDuration
                                          };
                                          Map<String, String> header1 = {
                                            "Content-Type": "application/json",
                                            "Authorization":
                                                'Bearer ${Prefs.getString(Prefs.BEARER)}',
                                          };
                                          http.Response response1 =
                                              await http.post(Uri.parse(url1),
                                                  body: jsonEncode(body1),
                                                  headers: header1);
                                          if (response1.statusCode == 200) {
                                            Prefs.removeKey(Prefs.vcStartTime);
                                            Prefs.removeKey(Prefs.vcEndTime);

                                            Utils.showSnackBar('Appointment',
                                                'Provider Mark this appointment completed');

                                            setState(() {
                                              isLoadingMark = false;
                                            });

                                            await _doctorHomeScreenController
                                                .getDoctorAppointmentsModel();

                                            await _patientHomeScreenController
                                                .getPatientHomePage();

                                            if (patientScheduledClassController
                                                    .getClassPatientApiResponse
                                                    .status ==
                                                Status.COMPLETE) {
                                              if (patientScheduledClassController
                                                      .getClassPatientApiResponse
                                                      .data
                                                      .data ==
                                                  null) {
                                                await patientScheduledClassController
                                                    .getClassListPatient(
                                                        id: userController
                                                            .user.value.id!,
                                                        date: '');
                                              } else {
                                                await patientScheduledClassController
                                                    .getClassListPatient(
                                                        id: userController
                                                            .user.value.id!,
                                                        date: '');
                                              }
                                            }
                                          } else {
                                            Utils.showSnackBar('Appointment',
                                                'Please try after some time!');
                                            setState(() {
                                              isLoadingMark = false;
                                            });
                                          }

                                          refresh();
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ).paddingOnly(top: 10),
                              )
                            // : SizedBox()
                            : const SizedBox();
                  },
                );
              }),
            ],
          ),
        );
      },
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

  Future startMeeting({
    required BuildContext context,
    required String channelsName,
    required String tokens,
    required PatientAppoint patientAppoint,
  }) async {
    ///start meeting ///
    String url = Constants.baseUrl + Constants.doctorZoomMeeting;
    Map<String, dynamic> body = {
      "doctor_id": userController.user.value.id,
      "patient_id": patientAppoint.patientId,
      // "meeting_id": meetingDetailsResult[0],
      //"meeting_password": meetingDetailsResult[1],
      "appointment_id": patientAppoint.appointmentId,
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
      // await agoraController.agoraController();

      await cameraPermission();

      if (model.status == 'Success') {
        id = model.data?.id;
        meetingID = model.data?.meetingId;

        /// update status
        String url1 = Constants.baseUrl + Constants.doctorZoomAction;
        Map<String, dynamic> body1 = {
          "doctor_id": userController.user.value.id,
          // "id": '${model.data.id.toString()}',
          "meeting_id": model.data?.meetingId.toString(),
          "meeting_status": 'started'
        };
        log('RESPONSE MEET UPDATE$body1');

        Map<String, String> header1 = {
          "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
        };
        http.Response response1 = await http.post(Uri.parse(url1),
            body: jsonEncode(body1), headers: header1);
        log('RESPONSE MEET UPDATE ZOOM ${response1.body}');
      }
    } else {
      log('Please try again');
    }
    setState(() {
      isLoadingMeet = false;
    });
    if (!context.mounted) return;
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
        /// GET MEETING STATUS ///

        /// /// /// /// /// /// ///

        await Future.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c1) => AlertDialog(
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
                      Navigator.pop(c1);
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
                          Navigator.pop(c1);
                          await Future.delayed(Duration.zero).then(
                            (value) async {
                              if (!c1.mounted) return;
                              await Navigator.of(c1).pushNamed(
                                  Routes.addprescription,
                                  arguments: patientAppoint);
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
      },
    );
    setState(() {});
    // final endTime = meetingEndTime;
    // meetingEndTime = endTime;
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

  changeMeetingStatus({required String docId, required String s2}) async {
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

  messageDialog(
      {required BuildContext context,
      required String message,
      required String title}) async {
    showDialog(
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
                      refresh();
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
                            refresh();
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
}
