import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/data/pref_manager.dart';

import 'ActionButton.dart';
import 'sizeConfig.dart';

class BehaviourTeleHealth extends StatefulWidget {
  const BehaviourTeleHealth({
    super.key,
  });

  @override
  State<BehaviourTeleHealth> createState() => _BehaviourTeleHealthState();
}

class _BehaviourTeleHealthState extends State<BehaviourTeleHealth>
    with SingleTickerProviderStateMixin {
  bool isContainerCollapsed = true;
  bool isDateAndTimeVisible = false;
  bool isUserProfileImageVisible = false;
  bool isPhoneLogoVisible = false;
  bool areDetailsvisible = false;
  AnimationController? animationController;
  Tween<double>? tweenedValue;
  Animation? tweenAnimation;
  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  void initState() {
    super.initState();
    initiateAnimation();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
    );
    tweenedValue = Tween(begin: 50, end: 0);
    tweenAnimation = tweenedValue?.animate(animationController!);
    animationController?.addListener(
      () {
        setState(() {});
      },
    );
  }

  ///The animation here are staged
  void initiateAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isContainerCollapsed = false;
      });
    }).then(
      (f) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            isDateAndTimeVisible = true;
          });
        }).then((f) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              isUserProfileImageVisible = true;
            });
          }).then((f) {
            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() {
                isPhoneLogoVisible = true;
              });
            }).then((f) {
              Future.delayed(const Duration(milliseconds: 150), () {
                setState(() {
                  areDetailsvisible = true;
                });
                animationController?.forward();
              });
            });
          });
        });
      },
    );
  }

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AnimatedContainer(
                    curve: isContainerCollapsed
                        ? Curves.elasticIn
                        : Curves.elasticOut,
                    duration: const Duration(seconds: 1),
                    height: isContainerCollapsed
                        ? 0
                        : SizeConfig.safeBlockVertical * 45,
                    width: isContainerCollapsed
                        ? 0
                        : SizeConfig.safeBlockHorizontal * 100,
                    decoration: const BoxDecoration(
                      color: Color(0xff2C8BFF),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(145),
                      ),
                    ),
                  ),
                  SizedBox(
                    // color: Colors.red,
                    height: SizeConfig.safeBlockVertical * 50,
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: Row(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: AnimatedOpacity(
                              opacity: isUserProfileImageVisible ? 1 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: _isdark
                                          ? const AssetImage(
                                              'assets/images/neww_b_Logo.png')
                                          : const AssetImage(
                                              'assets/images/neww_w_Logo.png') /*CachedNetworkImageProvider(
                                            'https://www.sataware.com/wp-content/uploads/2020/08/logoo.png')*/
                                      ,
                                      fit: BoxFit.contain),
                                  color:
                                      _isdark ? Colors.black : Colors.grey[100],
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                height: SizeConfig.safeBlockVertical * 13,
                                width: SizeConfig.safeBlockHorizontal * 26,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 18),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () async {},
                                child: AnimatedOpacity(
                                  opacity: isPhoneLogoVisible ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        borderRadius:
                                            BorderRadius.circular(35)),
                                    height: SizeConfig.safeBlockVertical * 8.66,
                                    width:
                                        SizeConfig.safeBlockHorizontal * 17.33,
                                    child: Icon(
                                      Icons.phone,
                                      size:
                                          SizeConfig.safeBlockHorizontal * 8.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 25, left: 10),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 10.0),
                        child: SizedBox(
                          //color: Colors.white,
                          height: SizeConfig.safeBlockVertical * 19,
                          width: SizeConfig.safeBlockHorizontal * 80,
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(seconds: 1),
                              opacity: isDateAndTimeVisible ? 1 : 0,
                              child: Text(
                                'Behavioral Tele-Health',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65.0, top: 8, right: 22),
                child: Transform.translate(
                  offset: Offset(0, tweenAnimation?.value),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 235),
                    opacity: areDetailsvisible ? 1 : 0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 80,
                          height: SizeConfig.safeBlockVertical * 9,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Don't hesitate",
                              style: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                            //color: Colors.yellow,
                            width: SizeConfig.safeBlockHorizontal * 80,
                            height: SizeConfig.safeBlockVertical * 9,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Call Now',
                                style: TextStyle(
                                    fontSize: 38, fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 230),
                opacity: isContainerCollapsed ? 0 : 1,
                child: ActionButton(
                  onDecinePressed: () {
                    reverseAnimation();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void reverseAnimation() {
    Future.delayed(const Duration(milliseconds: 00), () {
      setState(() {
        isContainerCollapsed = true;
      });
    }).then((f) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          isDateAndTimeVisible = false;
        });
      }).then((f) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            isUserProfileImageVisible = false;
          });
        }).then((f) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              isPhoneLogoVisible = false;
            });
          }).then((f) {
            Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                areDetailsvisible = false;
              });
              animationController?.reverse().then((f) {
                Navigator.pop(context);
              });
            });
          });
        });
      });
    });
  }
}
