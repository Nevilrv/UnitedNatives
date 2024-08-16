import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';

class MyVideoCall extends StatefulWidget {
  final String? channelName, token;
  final dynamic s1, s2;
  final String? docId;

  const MyVideoCall(
      {super.key, this.channelName, this.token, this.s1, this.s2, this.docId});
  @override
  State<MyVideoCall> createState() => _MyAppsState();
}

class _MyAppsState extends State<MyVideoCall> {
  AgoraController agoraController = Get.find();
  final UserController userController = Get.find();

  @override
  void initState() {
    agoraController.initAgora(
        context: context,
        token: "${widget.token}",
        channelId: "${widget.channelName}",
        docId: "${widget.docId}",
        s2: "${widget.s2}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetBuilder<AgoraController>(builder: (controller) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _viewRows(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.muteAudio();
                      },
                      child: Container(
                        height: 65,
                        width: 65,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: !controller.muted
                            ? const Icon(Icons.mic, color: Colors.white)
                            : const Icon(Icons.mic_off, color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.loadingMeet();
                        controller.leaveChannel(
                            s2: "${widget.s2}", docId: "${widget.docId}");
                      },
                      child: Container(
                        height: 65,
                        width: 65,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.switchCamera();
                      },
                      child: Container(
                        height: 65,
                        width: 65,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: controller.isCamera
                            ? const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.cameraswitch,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _viewRows() {
    return Column(
      children: <Widget>[
        for (final widget in _renderWidget)
          Expanded(
            child: Container(
              child: widget,
            ),
          )
      ],
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    yield AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: agoraController.rtcEngine,
        canvas: const VideoCanvas(
            uid: 0, renderMode: RenderModeType.renderModeHidden),
      ),
    );

    for (final uid in agoraController.remoteUsers) {
      yield AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraController.rtcEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    }
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:united_natives/controller/user_controller.dart';
// import 'package:united_natives/utils/constants.dart';
// import 'package:united_natives/viewModel/agora_view_model.dart';
//
// import '../data/pref_manager.dart';
//
// class MyVideoCall extends StatefulWidget {
//   final String? channelName, token;
//   final dynamic s1, s2;
//   final String? docId;
//
//   const MyVideoCall(
//       {super.key, this.channelName, this.token, this.s1, this.s2, this.docId});
//   @override
//   State<MyVideoCall> createState() => _MyAppsState();
// }
//
// class _MyAppsState extends State<MyVideoCall> {
//   AgoraController agoraController = Get.find();
//   final UserController userController = Get.find();
//   final _infoStrings = <String>[];
//   int? uidOfUser;
//   bool muted = false;
//   bool isCamera = false;
//   bool isLoadingMeet = false;
//   final _remoteUsers = <int>[];
//   late RtcEngine rtcEngine;
//   @override
//   void initState() {
//     initAgora();
//     super.initState();
//   }
//
//   Future<void> initAgora() async {
//     rtcEngine = createAgoraRtcEngine();
//     await _initAgoraRtcEngine();
//     await joinChannel();
//     if (!mounted) return;
//     _addAgoraEventHandlers(context);
//   }
//
//   joinChannel() async {
//     await rtcEngine.startPreview();
//     await rtcEngine.joinChannel(
//         token: widget.token!,
//         channelId: widget.channelName!,
//         options: const ChannelMediaOptions(),
//         uid: 0);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {});
//     });
//   }
//
//   leaveChannel() async {
//     if (Prefs.getString(Prefs.USERTYPE) == "2") {
//       changeMeetingStatus();
//     }
//     await rtcEngine.leaveChannel();
//     await rtcEngine.stopPreview();
//     Prefs.setString(Prefs.vcEndTime, DateTime.now().toUtc().toString());
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   changeMeetingStatus() async {
//     String url1 = Constants.baseUrl + Constants.doctorZoomAction;
//
//     Map<String, dynamic> body1 = {
//       "doctor_id": widget.docId,
//       "meeting_id": widget.s2,
//       "meeting_status": 'rejoin'
//     };
//
//     Map<String, String> header1 = {
//       "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
//     };
//     http.Response response1 = await http.post(Uri.parse(url1),
//         body: jsonEncode(body1), headers: header1);
//
//     debugPrint('response1==========>>>>>$response1');
//   }
//
//   void muteAudio() {
//     setState(() {
//       muted = !muted;
//     });
//     rtcEngine.muteLocalAudioStream(muted);
//   }
//
//   switchCamera() {
//     rtcEngine.switchCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             _viewRows(),
//             Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       muteAudio();
//                     },
//                     child: Container(
//                       height: 65,
//                       width: 65,
//                       decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.red),
//                       child: !muted
//                           ? const Icon(Icons.mic, color: Colors.white)
//                           : const Icon(Icons.mic_off, color: Colors.white),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       setState(() {
//                         isLoadingMeet = false;
//                       });
//                       // Navigator.pop(context);
//                       leaveChannel();
//                     },
//                     child: Container(
//                       height: 65,
//                       width: 65,
//                       decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.red),
//                       child: const Icon(
//                         Icons.call_end,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isCamera = !isCamera;
//                       });
//                       switchCamera();
//                     },
//                     child: Container(
//                       height: 65,
//                       width: 65,
//                       decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.red),
//                       child: isCamera
//                           ? const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                             )
//                           : const Icon(
//                               Icons.cameraswitch,
//                               color: Colors.white,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _initAgoraRtcEngine() async {
//     await rtcEngine.initialize(const RtcEngineContext(
//       appId: "bd787ed657934da982d199ffb09a7f35",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     /// APP ID ///
//
//     rtcEngine.enableVideo();
//     rtcEngine.enableAudio();
//     rtcEngine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
//
//     VideoEncoderConfiguration config = const VideoEncoderConfiguration(
//         orientationMode: OrientationMode.orientationModeFixedPortrait);
//     rtcEngine.setVideoEncoderConfiguration(config);
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {});
//     });
//   }
//
//   void _addAgoraEventHandlers(context) {
//     rtcEngine.registerEventHandler(RtcEngineEventHandler(
//       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           if (mounted) {
//             setState(() {
//               String info =
//                   'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
//               uidOfUser = connection.localUid?.toInt();
//               _infoStrings.add(info);
//             });
//           }
//         });
//       },
//       onLeaveChannel: (connection, stats) {
//         if (mounted) {
//           setState(() {
//             _infoStrings.add('onLeaveChannel');
//             _remoteUsers.clear();
//             Navigator.pop(context);
//           });
//         }
//         leaveChannel();
//         // Get.back();
//       },
//       onUserJoined: (connection, remoteUid, elapsed) {
//         if (mounted) {
//           setState(() {
//             String info = 'userJoined: $remoteUid';
//             _infoStrings.add(info);
//             _remoteUsers.add(remoteUid);
//           });
//         }
//       },
//       onUserOffline: (connection, remoteUid, reason) {
//         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           if (mounted) {
//             setState(() {
//               String info = 'userOffline: $remoteUid';
//               _infoStrings.add(info);
//               _remoteUsers.remove(remoteUid);
//             });
//           }
//         });
//         Navigator.pop(context);
//         leaveChannel();
//         // Get.back();
//       },
//       onFirstRemoteVideoFrame: (connection, remoteUid, width, height, elapsed) {
//         if (mounted) {
//           setState(() {
//             String info = 'firstRemoteVideo: $remoteUid ${width}x$height';
//             _infoStrings.add(info);
//           });
//         }
//       },
//     ));
//     if (mounted) {
//       setState(() {});
//     }
//     setState(() {});
//   }
//
//   Widget _viewRows() {
//     return Column(
//       children: <Widget>[
//         for (final widget in _renderWidget)
//           Expanded(
//             child: Container(
//               child: widget,
//             ),
//           )
//       ],
//     );
//   }
//
//   Iterable<Widget> get _renderWidget sync* {
//     yield AgoraVideoView(
//       controller: VideoViewController(
//         rtcEngine: rtcEngine,
//         canvas: const VideoCanvas(
//             uid: 0, renderMode: RenderModeType.renderModeHidden),
//       ),
//     );
//
//     for (final uid in _remoteUsers) {
//       yield AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: rtcEngine,
//           canvas: VideoCanvas(uid: uid),
//         ),
//       );
//     }
//   }
// }
