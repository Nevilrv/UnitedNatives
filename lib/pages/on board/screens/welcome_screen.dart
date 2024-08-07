import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VideoIntro extends StatefulWidget {
  @override
  _VideoIntroState createState() => _VideoIntroState();
}

class _VideoIntroState extends State<VideoIntro> {
  double _appbarSize;
  int _nOfpages = 3;
  int _currentPage = 0;
  PageController _controller = PageController(initialPage: 0);

  // List<Widget> _buildIndicators() {
  //   List<Widget> wlist = [];
  //   for (int i = 0; i < _nOfpages; i++) {
  //     wlist.add((i == _currentPage) ? _indicator(true) : _indicator(false));
  //   }
  //
  //   return wlist;
  // }

  // Widget _indicator(bool isActive) {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 150),
  //     height: 8.0,
  //     width: 8.0,
  //     margin: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //         color: isActive ? Colors.white : Colors.white54,
  //         borderRadius: BorderRadius.all(Radius.circular(12.0))),
  //   );
  // }

  // void _setPageState(int page) {
  //   setState(() {
  //     _currentPage = page;
  //   });
  // }

  // void _moveToNextPage() {
  //   _controller.jumpToPage(_currentPage + 1);
  // }

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
        floatingActionButton: Container(
//                    color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              ButtonTheme(
                minWidth: 370,
                height: 45,
                child: (_currentPage != _nOfpages - 1)
                    ? OutlinedButton(
                        style: ButtonStyle(),
                        child: Text(
                          'Let Start',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {},
                      )
                    : FlatButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        ),
                        child: Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => {},
                      ),
              )
            ],
          ),
        ),
        body: _body(),
      );
    });
  }

  Widget _body() {
    return Container(
      height: 1000,
//        color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: _appbarSize),
//                color: Colors.blue,
              child: FlatButton(
//                  color: Colors.white,
                child: Text(
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
