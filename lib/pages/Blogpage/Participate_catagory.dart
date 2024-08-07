import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PCategoryView extends StatelessWidget {
  const PCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context).translate('Survey List'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24)),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: h * 0.30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(width: 30, height: 1, color: Colors.brown),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Learn more",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: h * 0.20, left: w * 0.40),
                  child: Text(
                    "01",
                    style: TextStyle(
                        fontSize: 59,
                        color: _isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey[200],
                        fontFamily: "Bubble"),
                    textScaleFactor: 2.5,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70),
                  child: Text(
                    "Current \t Survey",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isDark ? Colors.white : Colors.black,
                      fontSize: 36,
                    ),
                    textScaleFactor: 2,
                  ),
                )
              ],
            ),
          ),
          Hero(
            transitionOnUserGestures: true,
            child: _buildMyCourses(w),
            tag: "Research information",
          ),
        ],
      ),
    );
  }

  Widget _buildMyCourses(double w) {
    final titles = [
      'MENTAL HEALTH SURVEY',
      'HEALTH BEHAVIORS SURVEY',
      'SEXUAL VIOLENCE SURVEY'
    ];
    // final values = [7, 3, 1];
    final gradientColors = [
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)]
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Text('Survey List',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 500,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: titles.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewLoad(
                        url:
                            'https://qfreeaccountssjc1.az1.qualtrics.com/jfe/preview/SV_9BHguySouHLUT7n?Q_CHL',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: w * 0.35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // List: [gradientColors[index]],
                      colors: gradientColors[index],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(titles[index],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class WebViewLoad extends StatefulWidget {
  // final String title;
  final String url;

  const WebViewLoad({Key key /*, this.title*/, this.url}) : super(key: key);
  WebViewLoadUI createState() => WebViewLoadUI();
}

class WebViewLoadUI extends State<WebViewLoad> {
  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    print('webURL ${widget.url}');
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            'Survey',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.subtitle1.color,
              fontSize: 24,
            ),
          ),
          // title: Text('Current survey'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
      );
    });
  }
}
