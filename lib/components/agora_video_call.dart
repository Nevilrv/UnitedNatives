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
  AgoraController agoraController = Get.put(AgoraController());
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
          backgroundColor: Colors.black,
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
      if (agoraController.remoteUsers.length != 1) {
        break;
      }
    }
  }
}
