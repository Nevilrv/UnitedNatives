import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';

class VideoIntro extends StatefulWidget {
  const VideoIntro({super.key});

  @override
  State<VideoIntro> createState() => _VideoIntroState();
}

class _VideoIntroState extends State<VideoIntro> {
  double? _appbarSize;
  final int _nOfpages = 3;
  final int _currentPage = 0;
  final PageController _controller = PageController(initialPage: 0);

  void _sysTemUIConfig() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void initState() {
    super.initState();
    _sysTemUIConfig(); //now we will hard reset
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Size _size = MediaQuery.of(context).size;
    _appbarSize = MediaQuery.of(context).padding.top;
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 370,
              height: 45,
              child: (_currentPage != _nOfpages - 1)
                  ? OutlinedButton(
                      style: const ButtonStyle(),
                      child: const Text(
                        'Let Start',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {},
                    )
                  : MaterialButton(
                      color: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => {},
                    ),
            )
          ],
        ),
        body: _body(),
      );
    });
  }

  Widget _body() {
    return SizedBox(
      height: 1000,
//        color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: _appbarSize!),
//                color: Colors.blue,
              child: MaterialButton(
//                  color: Colors.white,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
