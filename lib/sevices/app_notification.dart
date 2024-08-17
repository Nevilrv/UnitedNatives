import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/model/get_all_doctor.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/model/patient_prescription_model.dart';
import 'package:united_natives/pages/appointment/doctor_appointment.dart';
import 'package:united_natives/pages/appointment/my_appointments_page.dart';
import 'package:united_natives/pages/doctormessages/messages_detail_page.dart';
import 'package:united_natives/pages/login/phoneAuthScreen2.dart';
import 'package:united_natives/pages/messages/messages_detail_page.dart';
import 'package:united_natives/pages/notifications/patient_notification_page.dart';
import 'package:united_natives/pages/prescription/prescription_list_page.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';

class AppNotificationHandler {
  static final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  static final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();
  static AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());
  static GetSortedChatListDoctor getSortedChatListDoctor =
      GetSortedChatListDoctor();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final UserController _userController = Get.put(UserController());
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  ///get fcm token
  static Future getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      String? token = await firebaseMessaging.getToken();
      await Prefs.setString(Prefs.FcmToken, token!);
      return token;
    } catch (e) {
      return null;
    }
  }

  ///call when app in fore ground
  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      var data = jsonDecode(message.data['payload']);

      showMsg(notification!, data['screen'], data['timestamp'],
          data['relationId'].toString());
    });
  }

  /// handle notification when app in fore ground..///close app
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        log('A new onMessageOpenedApp event was published! getInitialMessage');
        var data = jsonDecode(message.data['payload']);
        _userController.isScreenName.value = data['screen'];
        _userController.notificationValue.value = data['relationId'].toString();
        _userController.isPinScreen.value = true;
      }
    });
  }

  ///show notification msg
  static void showMsg(RemoteNotification notification, String type, String date,
      String relationId) {
    log('notification==========>>>>>$notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/ic_launcher"),
            iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        log('payload==========>>>>>$payload');
        _userController.isScreenName.value = type;
        if (type == 'doctorAppointment') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const MyAppointmentsDoctor());
                  }
                })
              : Get.to(const MyAppointmentsDoctor());
        } else if (type == 'patientAppointment') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const MyAppointmentsPage());
                  }
                })
              : Get.to(const MyAppointmentsPage());
        } else if (type == 'patientAppointmentPrescription') {
          await patientHomeScreenController.getPatientPrescriptions();
          PatientPrescriptionsModel patientPrescriptionsModel =
              patientHomeScreenController.patientPrescriptionsModelData.value;
          for (var element in patientPrescriptionsModel.data!) {
            if (element.created == date) {
              _userController.notificationValue.value = element.appointmentId!;

              _userController.isPinScreen.value == true
                  ? await Get.to(const PhoneVerification2())?.then((value) {
                      if (_userController.isPinScreen.value == true) {
                        return Get.to(PrescriptionPage(
                            appointmentId: element.appointmentId));
                      }
                    })
                  : Get.to(
                      PrescriptionPage(appointmentId: element.appointmentId));
            }
          }
        } else if (type == 'zoomMeeting') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const PatientNotificationPage());
                  }
                })
              : Get.to(const PatientNotificationPage());
        } else if (type == 'patientChat') {
          _userController.notificationValue.value = relationId.toString();
          log('relationId.toString()==========>>>>>${relationId.toString()}');
          List<ShortedDoctorChat> doctorChat = <ShortedDoctorChat>[];
          await addNewChatMessageController
              .getSortedChatListDoctor(doctorId: _userController.user.value.id)
              .then((value) {
            getSortedChatListDoctor = addNewChatMessageController
                .getDoctorSortedChatListApiResponse.data;

            for (var element in getSortedChatListDoctor.doctorChatList!) {
              if (relationId.toString() == element.patientId.toString()) {
                doctorChat.add(element);
              }
            }
          }).then((value) async {
            _doctorHomeScreenController.doctorChat.value = doctorChat[0];

            if (_userController.isPinScreen.value == true) {
              await Get.to(const PhoneVerification2())?.then((value) {
                if (_userController.isPinScreen.value == true) {
                  return Get.to(const DoctorMessagesDetailPage());
                }
              });
            } else {
              Get.to(const DoctorMessagesDetailPage());
            }
          });
        } else if (type == 'doctorChat') {
          _userController.notificationValue.value = relationId.toString();
          log('relationId.toString()==========>>>>>${relationId.toString()}');
          List<SortedPatientChat> patientChat = <SortedPatientChat>[];
          await patientHomeScreenController
              .getSortedPatientChatList()
              .then((value) {
            for (var element in patientHomeScreenController.newDataList) {
              if (relationId.toString() == element.doctorId.toString()) {
                patientChat.add(element);
              }
            }
          }).then((value) async {
            patientHomeScreenController.chatKey.value =
                "${patientChat[0].chatKey}";
            patientHomeScreenController.doctorName.value =
                "${patientChat[0].doctorFirstName}";
            patientHomeScreenController.doctorLastName.value =
                "${patientChat[0].doctorLastName}";
            patientHomeScreenController.doctorId.value =
                "${patientChat[0].doctorId}";
            patientHomeScreenController.toId.value =
                "${patientChat[0].doctorId}";

            patientHomeScreenController.doctorProfile =
                "${patientChat[0].doctorProfilePic}";
            patientHomeScreenController.doctorSocialProfile =
                "${patientChat[0].doctorSocialProfilePic}";

            patientHomeScreenController
                .getAllPatientChatMessages.value.patientChatList
                ?.clear();

            patientHomeScreenController
                .getAllPatientChatMessagesList(patientChat[0].chatKey);

            if (_userController.isPinScreen.value == true) {
              await Get.to(() => const PhoneVerification2());
              if (_userController.isPinScreen.value == true) {
                return Get.to(
                  MessagesDetailPage(
                    doctor: Doctor(
                      chatKey: patientChat[0].chatKey.toString(),
                    ),
                    sortedPatientChat: patientChat[0],
                  ),
                );
              }
            } else {
              return Get.to(
                MessagesDetailPage(
                  doctor: Doctor(
                    chatKey: patientChat[0].chatKey.toString(),
                  ),
                  sortedPatientChat: patientChat[0],
                ),
              );
            }
          });
        }
      },
    );

    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  ///background notification handler..
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    var data = jsonDecode(message.data['payload']);
    _userController.isScreenName.value = data['screen'];
  }

  ///call when click on notification back
  static void onMsgOpen() {
    // ignore: missing_return
    log('click notification........');

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        var data = jsonDecode(message.data['payload']);
        _userController.isScreenName.value = data['screen'];
        if (data['screen'] == 'doctorAppointment') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const MyAppointmentsDoctor());
                  }
                })
              : Get.to(const MyAppointmentsDoctor());
        } else if (data['screen'] == 'patientAppointment') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const MyAppointmentsPage());
                  }
                })
              : Get.to(const MyAppointmentsPage());
        } else if (data['screen'] == 'patientAppointmentPrescription') {
          await patientHomeScreenController.getPatientPrescriptions();
          PatientPrescriptionsModel patientPrescriptionsModel =
              patientHomeScreenController.patientPrescriptionsModelData.value;
          for (var element in patientPrescriptionsModel.data!) {
            if (element.created == data['timestamp']) {
              _userController.notificationValue.value =
                  "${element.appointmentId}";
              _userController.isPinScreen.value == true
                  ? await Get.to(const PhoneVerification2())?.then((value) {
                      if (_userController.isPinScreen.value == true) {
                        return Get.to(PrescriptionPage(
                          appointmentId: element.appointmentId,
                        ));
                      }
                    })
                  : Get.to(PrescriptionPage(
                      appointmentId: element.appointmentId,
                    ));
            }
          }
          // Get.to(PrescriptionPage());
        } else if (data['screen'] == 'zoomMeeting') {
          _userController.isPinScreen.value == true
              ? await Get.to(const PhoneVerification2())?.then((value) {
                  if (_userController.isPinScreen.value == true) {
                    return Get.to(const PatientNotificationPage());
                  }
                })
              : Get.to(const PatientNotificationPage());
        } else if (data['screen'] == 'patientChat') {
          log('patientChat======11111====>>>>>patientChatpatientChatpatientChat}');

          _userController.notificationValue.value =
              data['relationId'].toString();

          List<ShortedDoctorChat> doctorChat = <ShortedDoctorChat>[];
          await addNewChatMessageController
              .getSortedChatListDoctor(doctorId: _userController.user.value.id)
              .then((value) {
            getSortedChatListDoctor = addNewChatMessageController
                .getDoctorSortedChatListApiResponse.data;

            for (var element in getSortedChatListDoctor.doctorChatList!) {
              if (data['relationId'].toString() ==
                  element.patientId.toString()) {
                doctorChat.add(element);
              }
            }
          }).then((value) async {
            _doctorHomeScreenController.doctorChat.value = doctorChat[0];

            if (_userController.isPinScreen.value == true) {
              await Get.to(const PhoneVerification2())?.then((value) {
                if (_userController.isPinScreen.value == true) {
                  return Get.to(const DoctorMessagesDetailPage());
                }
              });
            } else {
              Get.to(const DoctorMessagesDetailPage());
            }
          });
        } else if (data['screen'] == 'doctorChat') {
          log('doctorChat======11111====>>>>>doctorChatdoctorChatdoctorChat}');

          _userController.notificationValue.value =
              data['relationId'].toString();

          List<SortedPatientChat> patientChat = <SortedPatientChat>[];
          await patientHomeScreenController
              .getSortedPatientChatList()
              .then((value) {
            for (var element in patientHomeScreenController.newDataList) {
              if (data['relationId'].toString() ==
                  element.doctorId.toString()) {
                patientChat.add(element);
              }
            }
          }).then(
            (value) async {
              await Future.delayed(const Duration(milliseconds: 500));
              if (patientChat.isNotEmpty) {
                patientHomeScreenController.chatKey.value =
                    patientChat[0].chatKey.toString();
                patientHomeScreenController.doctorName.value =
                    patientChat[0].doctorFirstName.toString();
                patientHomeScreenController.doctorLastName.value =
                    patientChat[0].doctorLastName.toString();
                patientHomeScreenController.doctorId.value =
                    patientChat[0].doctorId.toString();
                patientHomeScreenController.toId.value =
                    patientChat[0].doctorId.toString();

                patientHomeScreenController.doctorProfile =
                    patientChat[0].doctorProfilePic.toString();
                patientHomeScreenController.doctorSocialProfile =
                    patientChat[0].doctorSocialProfilePic.toString();

                patientHomeScreenController
                    .getAllPatientChatMessages.value.patientChatList
                    ?.clear();

                patientHomeScreenController
                    .getAllPatientChatMessagesList(patientChat[0].chatKey);

                if (_userController.isPinScreen.value == true) {
                  await Get.to(const PhoneVerification2())?.then((value) {
                    if (_userController.isPinScreen.value == true) {
                      return Get.to(MessagesDetailPage(
                        doctor: Doctor(
                          chatKey: patientChat[0].chatKey.toString(),
                        ),
                        sortedPatientChat: patientChat[0],
                      ));
                    }
                  });
                } else {
                  Get.to(MessagesDetailPage(
                    doctor: Doctor(
                      chatKey: patientChat[0].chatKey.toString(),
                    ),
                    sortedPatientChat: patientChat[0],
                  ));
                }
              }
            },
          );
        }
      },
    );
  }
}
