import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/agora_repo.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:http/http.dart' as http;

class AgoraController extends GetxController {
  final _infoStrings = <String>[];
  int? uidOfUser;
  bool muted = false;
  bool isCamera = false;
  bool isLoadingMeet = false;
  List<int> remoteUsers = <int>[];
  late RtcEngine rtcEngine;

  loadingMeet() {
    isLoadingMeet = false;
    update();
  }

  Future<void> initAgora({
    required BuildContext context,
    required String token,
    required String channelId,
    required String s2,
    required String docId,
  }) async {
    rtcEngine = createAgoraRtcEngine();
    await _initAgoraRtcEngine();
    await joinChannel(channelId: channelId, token: token);
    _addAgoraEventHandlers(context: context, s2: s2, docId: docId);
  }

  joinChannel({required String token, required String channelId}) async {
    await rtcEngine.startPreview();
    await rtcEngine.joinChannel(
        token: token,
        channelId: channelId,
        options: const ChannelMediaOptions(),
        uid: 0);
    update();
  }

  leaveChannel({
    required String s2,
    required String docId,
  }) async {
    if (Prefs.getString(Prefs.USERTYPE) == "2") {
      changeMeetingStatus(docId: docId, s2: s2);
    }
    await rtcEngine.leaveChannel();
    await rtcEngine.stopPreview();
    Prefs.setString(Prefs.vcEndTime, DateTime.now().toUtc().toString());
    update();
    Get.back();
  }

  changeMeetingStatus({
    required String s2,
    required String docId,
  }) async {
    String url1 = Constants.baseUrl + Constants.doctorZoomAction;
    Map<String, dynamic> body1 = {
      "doctor_id": docId,
      "meeting_id": s2,
      "meeting_status": 'rejoin'
    };
    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response1 = await http.post(Uri.parse(url1),
        body: jsonEncode(body1), headers: header1);
    log("response1==========>>>>>$response1");
  }

  void muteAudio() {
    muted = !muted;
    update();
    rtcEngine.muteLocalAudioStream(muted);
  }

  switchCamera() {
    isCamera = !isCamera;
    update();
    rtcEngine.switchCamera();
  }

  Future<void> _initAgoraRtcEngine() async {
    await rtcEngine.initialize(const RtcEngineContext(
      appId: "bd787ed657934da982d199ffb09a7f35",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    /// APP ID ///

    rtcEngine.enableVideo();
    rtcEngine.enableAudio();
    rtcEngine.setChannelProfile(ChannelProfileType.channelProfileCommunication);

    VideoEncoderConfiguration config = const VideoEncoderConfiguration(
        orientationMode: OrientationMode.orientationModeFixedPortrait);
    rtcEngine.setVideoEncoderConfiguration(config);

    update();
  }

  void _addAgoraEventHandlers({
    required BuildContext context,
    required String s2,
    required String docId,
  }) {
    rtcEngine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        remoteUsers.clear();
        String info =
            'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
        uidOfUser = connection.localUid?.toInt();
        _infoStrings.add(info);
        update();
      },
      onLeaveChannel: (connection, stats) {
        _infoStrings.add('onLeaveChannel');
        remoteUsers.clear();
        update();
        leaveChannel(s2: s2, docId: docId);
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        String info = 'userJoined: $remoteUid';
        _infoStrings.add(info);
        remoteUsers.add(remoteUid);
        update();
      },
      onUserOffline: (connection, remoteUid, reason) {
        String info = 'userOffline: $remoteUid';
        _infoStrings.add(info);
        remoteUsers.remove(remoteUid);
        leaveChannel(docId: docId, s2: s2);
        update();
      },
      onFirstRemoteVideoFrame: (connection, remoteUid, width, height, elapsed) {
        String info = 'firstRemoteVideo: $remoteUid ${width}x$height';
        _infoStrings.add(info);
        update();
      },
    ));
    update();
  }

  ApiResponse getServicesPatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse getServicesDoctorApiResponse = ApiResponse.initial('Initial');

  Future<void> agoraController(String id) async {
    getServicesPatientApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetAgoraToken response = await AgoraRepo().agoraRepo(id);

      getServicesPatientApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getServicesPatientApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
