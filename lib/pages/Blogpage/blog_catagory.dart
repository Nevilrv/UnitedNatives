import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/model/patient_homepage_model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../routes/routes.dart';

class CategoryView extends StatelessWidget {
  final ResearchDocs data;

  CategoryView({Key key, this.data}) : super(key: key);

  final PatientHomeScreenController _patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getResearchDocument();

  @override
  Widget build(BuildContext context) {
    print('DEMO..');
    final screenWidth = MediaQuery.of(context).size.width;
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context).translate('Project List'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.30),
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
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.20,
                      left: MediaQuery.of(context).size.width * 0.40),
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
                    "Current \t Research",
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
          Flexible(
            child: Hero(
              transitionOnUserGestures: true,
              child: _buildMyCourses(screenWidth),
              tag: "Reseatch information",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCourses(double screenWidth) {
    // final titles = ['Examining Socio-Cultural Influences, Knowledge... read more', 'Examining Health and Social Indicators ... read more', 'Identifying Sociocultural Levels of Attitudes ... read more','Examining Socio-Cultural Influences, Knowledge... read more', 'Examining Health and Social Indicators ... read more', 'Identifying Sociocultural Levels of Attitudes ... read more'];
    // final values = [7, 3, 1,7, 3, 1];
    final gradientColors = [
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)],
      [Color(0xFF606BFF), Color(0xFF58D1FF)]
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Text('Project List',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        Flexible(
          child: Obx(() {
            if (_patientHomeScreenController
                    .researchDocumentModelData?.value?.apiState ==
                APIState.COMPLETE) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: _patientHomeScreenController
                        .researchDocumentModelData?.value?.data?.length ??
                    0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.blogdetailedview,
                          arguments: _patientHomeScreenController
                              .researchDocumentModelData
                              ?.value
                              ?.data[index]
                              .id);
                    },
                    child: Container(
                      width: screenWidth * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  "${_patientHomeScreenController.researchDocumentModelData?.value?.data[index].researchTitle}",
                                  style: TextStyle(
                                      fontSize: 22,
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
              );
            } else if (_patientHomeScreenController
                    .researchDocumentModelData?.value?.apiState ==
                APIState.COMPLETE_WITH_NO_DATA) {
              return Container(
                child: Center(
                  child: Text(
                    'No data to show!',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              );
            } else if (_patientHomeScreenController
                    .researchDocumentModelData?.value?.apiState ==
                APIState.ERROR) {
              return Container(
                child: Center(
                  child: Text('Error'),
                ),
              );
            } else if (_patientHomeScreenController
                    .researchDocumentModelData?.value?.apiState ==
                APIState.PROCESSING) {
              return Container(
                  child: /*Center(
                  child: CircularProgressIndicator(),
                ),*/
                      Center(
                child: Utils.circular(),
              ));
            } else {
              return Container(
                child: Center(
                  child: Text(
                    'No Data!',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              );
            }
          }),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
