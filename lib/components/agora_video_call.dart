import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/viewModel/agora_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../data/pref_manager.dart';

class MyVideoCall extends StatefulWidget {
  final String channelName, token;
  final dynamic s1, s2;
  final String docId;

  MyVideoCall(
      {Key key, this.channelName, this.token, this.s1, this.s2, this.docId})
      : super(key: key);
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyVideoCall> {
  // bool _isInChannel = false;
  // static final _sessions = <VideoSession>[];
  AgoraController agoraController = Get.find();
  final UserController userController = Get.find();
  final _infoStrings = <String>[];
  int uidOfUser;
  bool muted = false;
  bool isCamera = false;
  bool isLoadingMeet = false;
  // String data1 = 'tt';
  // String data3 = '36d57189bd00417f8f336b5b6d3b6293';
  // String data2 =
  //     "007eJxTYNj0Uezxv6wnnpevmcl1WiX9Ya0Rv/TrBouE+oRr6nvXX0lUYDA2SzE1N7SwTEoxMDAxNE+zSDM2NksyTTJLMU4yM7I0zpA5mtwQyMjAYMbGysgAgSA+E0NJCQMDAEs7HfU=";
  //
  // final List<String> voices = [
  //   'Off',
  //   'Oldman',
  //   'BabyBoy',
  //   'BabyGirl',
  //   'Zhubajie',
  //   'Ethereal',
  //   'Hulk'
  // ];

  /// remote user list
  final _remoteUsers = <int>[];

  @override
  void initState() {
    super.initState();
    //  microPhonePermission();
    _initAgoraRtcEngine();
    _addAgoraEventHandlers(context);
    joinChannel();
  }

  // microPhonePermission() async {
  //   PermissionStatus microPhoneStatus = await Permission.microphone.request();
  //   if (microPhoneStatus == PermissionStatus.granted) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Permission Granted')));
  //   }
  //   if (microPhoneStatus == PermissionStatus.denied) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('You need to provide a MicroPhone Permission'),
  //     ));
  //   }
  //   if (microPhoneStatus == PermissionStatus.permanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  joinChannel() async {
    await AgoraRtcEngine.startPreview();
    await AgoraRtcEngine.joinChannel(widget.token, widget.channelName, null, 0);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });

    log('CANNEL NAME :::: ${widget.channelName} -- AGORA TOKEN :::: ${widget.token}');
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
    String url1 = '${Constants.baseUrl + Constants.doctorZoomAction}';

    Map<String, dynamic> body1 = {
      "doctor_id": widget.docId,
      // "id": widget.s1,
      "meeting_id": widget.s2,
      // "meeting_status": 'ended'
      "meeting_status": 'rejoin'
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

  // controller.addVideoConference(body: {
  //   "patient_id": 3,
  //   "doctor_id": 4,
  //   "meeting_date": "06-07-2023",
  //   "meeting_time": "16:30",
  //   "meeting_duration": "5m30s",
  //   "meeting_details": "any short description"
  // });

  // muteAudio({bool value, int id}) {
  //   AgoraRtcEngine.muteLocalAudioStream(muted);
  // }

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
                      // setState(() {
                      //   muted = !muted;
                      //   print('mute AFTER $muted');
                      //   print('mute uid $uidOfUser');
                      //   muteAudio(id: uidOfUser, value: muted);
                      // });
                      muteAudio();
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: !muted
                          ? Icon(Icons.mic, color: Colors.white)
                          : Icon(Icons.mic_off, color: Colors.white),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //   ;
                  // }),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: isCamera
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            )
                          : Icon(
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

/* Widget _voiceDropdown() {
    return Scaffold(
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              VoiceChanger voice =
                  VoiceChanger.values[(voices.indexOf(dropdownValue))];
              AgoraRtcEngine.setLocalVoiceChanger(voice);
            });
          },
          items: voices.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }*/

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('bd787ed657934da982d199ffb09a7f35');

    /// APP ID ///

    AgoraRtcEngine.enableVideo();
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);

    VideoEncoderConfiguration config = VideoEncoderConfiguration();
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
            String info =
                'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
            uidOfUser = uid.toInt();
            _infoStrings.add(info);
          });
        }
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      log("--------user leave channel");
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
          String info = 'userJoined: ' + uid.toString();
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
            String info = 'userOffline: ' + uid.toString();
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
          String info = 'firstRemoteVideo: ' +
              uid.toString() +
              ' ' +
              width.toString() +
              'x' +
              height.toString();
          _infoStrings.add(info);
        });
      }
    };
    if (mounted) {
      setState(() {});
    }
    setState(() {});
  }

  /*void _toggleChannel() async {
    if (_isInChannel) {
      _isInChannel = false;
      await AgoraRtcEngine.leaveChannel();
      await AgoraRtcEngine.stopPreview();
    } else {
      _isInChannel = true;
      await AgoraRtcEngine.startPreview();
      await AgoraRtcEngine.joinChannel(
          widget.token, widget.channelName, null, 0);
    }
    setState(() {});
  }*/

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

  /*VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }*/

  /*List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }*/

  // static TextStyle textStyle = TextStyle(fontSize: 20, color: Colors.blue);

  /*Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    );
  }*/
}

// class VideoSession {
//   int uid;
//   Widget view;
//   int viewId;
//
//   VideoSession(int uid, Widget view) {
//     this.uid = uid;
//     this.view = view;
//   }
// }
