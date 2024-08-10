import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

class SelfMonitering extends StatefulWidget {
  const SelfMonitering({super.key});

  @override
  State<SelfMonitering> createState() => _SelfMoniteringState();
}

class _SelfMoniteringState extends State<SelfMonitering> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: appBar(),
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400
              ? MediaQuery.of(context).size.width * 0.75
              : 350,
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  userSettings(),
                  userDocs(),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget userDocs() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.weightloss);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(FontAwesomeIcons.weightScale,
                          size: 25, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Weight tracker',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.sober);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.fileContract,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Sobriety tracker',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            20), /*Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize: 20)*/
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.food);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.football,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Food/caloric intake',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.sleep);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.bed,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Sleep',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.mood);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.cloudMoon,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Mood',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.wht);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/images/femalemenstrualcycle.png',
                            height: 27,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Female menstrual cycle',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.physicalActivity);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/images/physicalactivity.png',
                            height: 27,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Physical activity',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.medication);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/images/activitytracker.png',
                            height: 27,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Medication checklist tracker',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userSettings() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          /* InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicalManagement(),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#FF9503"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.car,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('vehicle Management'),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocmanagementScreen(),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#4BDA65"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.idCard,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('Document Management'),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.title.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),*/
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.diabetes);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.inbox,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Blood sugar tracker',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pushNamed(Routes.bp);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.prescriptionBottle,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    'Blood pressure',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 5),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
      ),
      title: Text(
        Translate.of(context)!.translate('Self-Monitoring'),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleMedium?.color,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
    );

    // return AppBar(
    //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   automaticallyImplyLeading: false,
    //   title: Row(
    //     children: <Widget>[
    //       SizedBox(
    //         // height: AppBar().preferredSize.height,
    //         // width: AppBar().preferredSize.height + 40,
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //             alignment: Alignment.centerLeft,
    //             child: GestureDetector(
    //               onTap: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Icon(
    //                 Icons.arrow_back_ios,
    //                 color: Theme.of(context).textTheme.headline1.color,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: Text(
    //           'Self-Monitoring',
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               color: Theme.of(context).textTheme.subtitle1.color,
    //               fontSize: 24),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //
    //       ///DO Not remove
    //       SizedBox(
    //         // height: AppBar().preferredSize.height,
    //         // width: AppBar().preferredSize.height + 40,
    //
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //             alignment: Alignment.centerLeft,
    //             child: Icon(
    //               Icons.arrow_back_ios,
    //               color: Colors.transparent,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
