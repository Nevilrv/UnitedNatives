import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/viewModel/agora_view_model.dart';

import '../data/pref_manager.dart';

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
  final _infoStrings = <String>[];
  int? uidOfUser;
  bool muted = false;
  bool isCamera = false;
  bool isLoadingMeet = false;
  final _remoteUsers = <int>[];

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers(context);
    joinChannel();
  }

  joinChannel() async {
    await AgoraRtcEngine.startPreview();
    await AgoraRtcEngine.joinChannel(widget.token, widget.channelName, null, 0);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  leaveChannel() async {
    if (Prefs.getString(Prefs.USERTYPE) == "2") {
      changeMeetingStatus();
    }
    await AgoraRtcEngine.leaveChannel();
    await AgoraRtcEngine.stopPreview();
    Prefs.setString(Prefs.vcEndTime, DateTime.now().toUtc().toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  changeMeetingStatus() async {
    String url1 = Constants.baseUrl + Constants.doctorZoomAction;

    Map<String, dynamic> body1 = {
      "doctor_id": widget.docId,
      "meeting_id": widget.s2,
      "meeting_status": 'rejoin'
    };

    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response1 = await http.post(Uri.parse(url1),
        body: jsonEncode(body1), headers: header1);
  }

  void muteAudio() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  switchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      muteAudio();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: !muted
                          ? const Icon(Icons.mic, color: Colors.white)
                          : const Icon(Icons.mic_off, color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoadingMeet = false;
                      });
                      Navigator.pop(context);
                      leaveChannel();
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
                      setState(() {
                        isCamera = !isCamera;
                      });
                      switchCamera();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: isCamera
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
      ),
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('bd787ed657934da982d199ffb09a7f35');

    /// APP ID ///

    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);

    VideoEncoderConfiguration config = const VideoEncoderConfiguration();
    config.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    AgoraRtcEngine.setVideoEncoderConfiguration(config);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  void _addAgoraEventHandlers(context) {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {
            String info = 'onJoinChannel: $channel, uid: $uid';
            uidOfUser = uid.toInt();
            _infoStrings.add(info);
          });
        }
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {
            _infoStrings.add('onLeaveChannel');
            _remoteUsers.clear();
            Navigator.pop(context);
          });
        }
      });
      leaveChannel();

      // Get.back();
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      if (mounted) {
        setState(() {
          String info = 'userJoined: $uid';
          _infoStrings.add(info);
          _remoteUsers.add(uid);
        });
      }
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      log("--------user offline");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {
            String info = 'userOffline: $uid';
            _infoStrings.add(info);
            _remoteUsers.remove(uid);
          });
        }
      });
      Navigator.pop(context);
      leaveChannel();
      // Get.back();
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      if (mounted) {
        setState(() {
          String info = 'firstRemoteVideo: $uid ${width}x$height';
          _infoStrings.add(info);
        });
      }
    };
    if (mounted) {
      setState(() {});
    }
    setState(() {});
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
    yield AgoraRenderWidget(0, local: true, preview: false);

    for (final uid in _remoteUsers) {
      yield AgoraRenderWidget(uid);
    }
  }
}
