import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:url_launcher/url_launcher.dart';

Color orangeColors = const Color(0xff2C8BFF);
Color orangeLightColors = const Color(0xff2C8BFF);

class TeleHealth extends StatefulWidget {
  static const String path = "lib/src/pages/login/login14.dart";

  const TeleHealth({super.key});
  @override
  State<TeleHealth> createState() => _TeleHealthState();
}

class _TeleHealthState extends State<TeleHealth> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        backgroundColor: _isDark ? Colors.black : Colors.white,
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        body: Column(
          children: <Widget>[
            const HeaderContainer(text: "Technical-Assistance"),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      MaterialButton(
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () async {
                          // final String subject = "Subject:";
                          // final String stringText = "Same Message:";
                          String uri = 'mailto:contact@sataware.com';
                          // await launch(uri);
                          await launchUrl(Uri.parse(uri));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => BehaviourTeleHealth()),
                          // );
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            width: Get.width,
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'For any technical assistance, please email on ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            fontSize: 20, color: Colors.black),
                                  ),
                                  TextSpan(
                                      text: 'contact@sataware.com',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize: 20,
                                              color: orangeColors,
                                              decoration:
                                                  TextDecoration.underline)),
                                ],
                              ),
                            )
                            // Text(
                            //     'For any technical assistance, please email on demo@gmail.com',
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: Get.height * 0.02,
                            //         fontWeight: FontWeight.bold)),
                            ),
                      ),
                      // RaisedButton(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 30, horizontal: 10),
                      //     width: Get.width,
                      //     alignment: Alignment.center,
                      //     child: Text('Behavioral Technical-Assistance',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: Get.height * 0.03,
                      //             fontWeight: FontWeight.bold)),
                      //   ),
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(50.0))),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => BehaviourTeleHealth()),
                      //     );
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // RaisedButton(
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 30, horizontal: 10),
                      //       width: Get.width,
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         'Mental Technical-Assistance',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: Get.height * 0.03,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //     color: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(50.0))),
                      //     onPressed: () => {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => MentalTeleHealth(),
                      //             ),
                      //           ),
                      //         }),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // RaisedButton(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 30, horizontal: 10),
                      //     width: Get.width,
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       'Allied Technical-Assistance',
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: Get.height * 0.03,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(50.0))),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => AlliedTeleHealthScreen()),
                      //     );
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // RaisedButton(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 30, horizontal: 10),
                      //     width: Get.width,
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       'Tele-Medicine',
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: Get.height * 0.03,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(50.0))),
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => TeleHealthScreen()),
                      //     );
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget textInput({controller, hint, icon}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  final String text;

  const HeaderContainer({super.key, this.text = "Tele Health"});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [orangeColors, orangeLightColors],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter),
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(100))),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 43,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Monday to Friday (9 Am - 4 Pm PST)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
}
