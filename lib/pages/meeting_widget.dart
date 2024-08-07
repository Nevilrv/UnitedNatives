// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_zoom_sdk/zoom_options.dart';
// // import 'package:flutter_zoom_sdk/zoom_view.dart';
//
// class MeetingWidget extends StatefulWidget {
//   /*final meetingId;F
//   final meetingPassword;*/
//   MeetingWidget({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _MeetingWidgetState createState() => _MeetingWidgetState();
// }
//
// class _MeetingWidgetState extends State<MeetingWidget> {
//   TextEditingController meetingIdController = TextEditingController();
//   TextEditingController meetingPasswordController = TextEditingController();
//   Timer timer;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // meetingIdController.text=widget.meetingId;
//     // meetingPasswordController.text=widget.meetingPassword.toString();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // new page needs scaffolding!
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Join meeting'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8.0,
//           horizontal: 32.0,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: TextField(
//                 controller: meetingIdController,
//                 decoration: const InputDecoration(
//                     border: OutlineInputBorder(), labelText: 'Meeting ID'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: TextField(
//                 controller: meetingPasswordController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Password',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Builder(
//                 builder: (context) {
//                   // The basic Material Design action button.
//                   return ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.blue, // background
//                       onPrimary: Colors.white, // foreground
//                     ),
//                     onPressed: () {
//                       // joinMeeting(context);
//                     },
//                     child: const Text('Join'),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Builder(
//                 builder: (context) {
//                   // The basic Material Design action button.
//                   return ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.blue, // background
//                       onPrimary: Colors.white, // foreground
//                     ),
//                     onPressed: () => {
//                       // {startMeeting(context)}
//                     },
//                     child: const Text('Start Meeting'),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Builder(
//                 builder: (context) {
//                   // The basic Material Design action button.
//                   return ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.blue, // background
//                       onPrimary: Colors.white, // foreground
//                     ),
//                     onPressed: () {
//                       // startMeeting(context);
//                     },
//                     child: const Text('Start Meeting With Meeting ID'),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // startMeeting(BuildContext context) {
//   //   bool _isMeetingEnded(String status) {
//   //     var result = false;
//   //
//   //     if (Platform.isAndroid)
//   //       result = status == "MEETING_STATUS_DISCONNECTING" ||
//   //           status == "MEETING_STATUS_FAILED";
//   //     else
//   //       result = status == "MEETING_STATUS_IDLE";
//   //
//   //     return result;
//   //   }
//   //
//   //   ZoomOptions zoomOptions = new ZoomOptions(
//   //     domain: "zoom.us",
//   //     appKey: "6UolodTzvCegwhymYWspR7lAcE6YsZlQgI7v", //API KEY FROM ZOOM
//   //     // appKey: "DH2t0pFNREEirS6mvQx6DL37qREapObvlVcX", //API KEY FROM ZOOM
//   //     // appKey: "urC8O79RQYGTOwpbBnknqw", //API KEY FROM ZOOM
//   //     appSecret: "N5Zh2pHGUaMzKVMP8rZxfr357OV4u3RaCGqr",
//   //     //  appSecret: "HX9RJMrUxckaC7vyKd3rGHGiXJa6DoyO",
//   //     // "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw",
//   //   );
//   //   var meetingOptions = new ZoomMeetingOptions(
//   //       userId: 'indigenoushealthapp@gmail.com', //pass host email for zoom
//   //       // userId: 'nevilrv@gmail.com', //pass host email for zoom
//   //       userPassword: 'oikLfd5asdaD&^ihj;kl', //pass host password for zoom
//   //       // userPassword: 'Nevil@9120', //pass host password for zoom
//   //       disableDialIn: "false",
//   //       disableDrive: "false",
//   //       disableInvite: "false",
//   //       disableShare: "false",
//   //       disableTitlebar: "false",
//   //       viewOptions: "false",
//   //       noAudio: "false",
//   //       noDisconnectAudio: "false");
//   //
//   //   var zoom = ZoomView();
//   //   zoom.initZoom(zoomOptions).then((results) {
//   //     if (results[0] == 0) {
//   //       zoom.onMeetingStatus().listen((status) {
//   //         print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//   //         if (_isMeetingEnded(status[0])) {
//   //           print("[Meeting Status] :- Ended");
//   //           timer.cancel();
//   //         }
//   //         if (status[0] == "MEETING_STATUS_INMEETING") {
//   //           zoom.meetinDetails().then((meetingDetailsResult) {
//   //             print("[MeetingDetailsResult] :- " +
//   //                 meetingDetailsResult.toString());
//   //           });
//   //         }
//   //       });
//   //       zoom.startMeeting(meetingOptions).then((loginResult) {
//   //         print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
//   //         if (loginResult[0] == "SDK ERROR") {
//   //           //SDK INIT FAILED
//   //           print((loginResult[1]).toString());
//   //         } else if (loginResult[0] == "LOGIN ERROR") {
//   //           //LOGIN FAILED - WITH ERROR CODES
//   //           if (loginResult[1] ==
//   //               ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
//   //             print("Multiple Failed Login Attempts");
//   //           }
//   //           print((loginResult[1]).toString());
//   //         } else {
//   //           //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
//   //           print((loginResult[0]).toString());
//   //         }
//   //       });
//   //     }
//   //   }).catchError((error) {
//   //     print("[Error Generated] : " + error);
//   //   });
//   // }
//   //
//   // joinMeeting(BuildContext context) {
//   //   bool _isMeetingEnded(String status) {
//   //     var result = false;
//   //
//   //     if (Platform.isAndroid) {
//   //       result = status == "MEETING_STATUS_DISCONNECTING" ||
//   //           status == "MEETING_STATUS_FAILED";
//   //     } else {
//   //       result = status == "MEETING_STATUS_IDLE";
//   //     }
//   //
//   //     return result;
//   //   }
//   //
//   //   if (meetingIdController.text.isNotEmpty &&
//   //       meetingPasswordController.text.isNotEmpty) {
//   //     ZoomOptions zoomOptions = ZoomOptions(
//   //       domain: "zoom.us",
//   //       appKey: "6UolodTzvCegwhymYWspR7lAcE6YsZlQgI7v", //API KEY FROM ZOOM
//   //       // "DH2t0pFNREEirS6mvQx6DL37qREapObvlVcX", //API KEY FROM ZOOM
//   //       appSecret:
//   //           "N5Zh2pHGUaMzKVMP8rZxfr357OV4u3RaCGqr", //API SECRET FROM ZOOM
//   //       // "pcrq5KCBGVRW6savB2Kejua3Y3zqDWt7pNmw", //API SECRET FROM ZOOM
//   //     );
//   //     var meetingOptions = ZoomMeetingOptions(
//   //         userId: 'savaliyaravina5@gmail.com',
//   //
//   //         /// pass username for join meeting only --- Any name eg:- EVILRATT.
//   //         meetingId: meetingIdController.text,
//   //
//   //         /// pass meeting id for join meeting only
//   //         meetingPassword: meetingPasswordController.text,
//   //
//   //         /// pass meeting password for join meeting only
//   //         disableDialIn: "false",
//   //         disableDrive: "false",
//   //         disableInvite: "false",
//   //         disableShare: "false",
//   //         disableTitlebar: "false",
//   //         viewOptions: "false",
//   //         noAudio: "false",
//   //         noDisconnectAudio: "false");
//   //
//   //     var zoom = ZoomView();
//   //     zoom.initZoom(zoomOptions).then((results) {
//   //       print('result $results');
//   //       if (results[0] == 0) {
//   //         zoom.onMeetingStatus().listen((status) {
//   //           if (kDebugMode) {
//   //             print(
//   //                 "[Meeting Status Stream] : " + status[0] + " - " + status[1]);
//   //           }
//   //           if (_isMeetingEnded(status[0])) {
//   //             if (kDebugMode) {
//   //               print("[Meeting Status] :- Ended");
//   //             }
//   //             timer.cancel();
//   //           }
//   //         });
//   //         if (kDebugMode) {
//   //           print("listen on event channel");
//   //         }
//   //         zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
//   //           timer = Timer.periodic(const Duration(seconds: 2), (timer) {
//   //             zoom.meetingStatus(meetingOptions.meetingId).then((status) {
//   //               if (kDebugMode) {
//   //                 print("[Meeting Status Polling] : " +
//   //                     status[0] +
//   //                     " - " +
//   //                     status[1]);
//   //               }
//   //             });
//   //           });
//   //         });
//   //       }
//   //     });
//   //   } else {
//   //     if (meetingIdController.text.isEmpty) {
//   //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//   //         content: Text("Enter a valid meeting id to continue."),
//   //       ));
//   //     } else if (meetingPasswordController.text.isEmpty) {
//   //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//   //         content: Text("Enter a meeting password to start."),
//   //       ));
//   //     }
//   //   }
//   // }
// }
