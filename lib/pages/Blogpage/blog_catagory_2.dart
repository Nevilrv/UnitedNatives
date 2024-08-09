import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/research_document_model.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../routes/routes.dart';

class CategoryViewDoctor extends StatelessWidget {
  final ResearchDocument ?data;



  CategoryViewDoctor({super.key, this.data});

  // final PatientHomeScreenController _patientHomeScreenController = Get.find();
  final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>()..getDoctorResearchDocument();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translate.of(context)!.translate('Project List'),
        ),
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(width: 30, height: 1, color: Colors.brown),
                      const SizedBox(width: 10),
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
                  child: Text("01",
                      style: TextStyle(
                          fontSize: 59,
                          color: isDark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey[200],
                          fontFamily: "Bubble"),
                      textScaleFactor: 2.5),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: Text("Current \t Research",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 36,
                      ),
                      textScaleFactor: 2),
                )
              ],
            ),
          ),
          Hero(
              transitionOnUserGestures: true,
              tag: "Reseatch information",
              child: _buildMyCourses(screenWidth)),
        ],
      ),
    );
  }

  Widget _buildMyCourses(double screenWidth) {
    // final titles = ['Examining Socio-Cultural Influences, Knowledge... read more', 'Examining Health and Social Indicators ... read more', 'Identifying Sociocultural Levels of Attitudes ... read more','Examining Socio-Cultural Influences, Knowledge... read more', 'Examining Health and Social Indicators ... read more', 'Identifying Sociocultural Levels of Attitudes ... read more'];
    // final values = [7, 3, 1,7, 3, 1];
    final gradientColors = [
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)],
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)],
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)],
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)],
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)],
      [const Color(0xFF606BFF), const Color(0xFF58D1FF)]
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Text('Project List',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        Obx(() {
          if (_doctorHomeScreenController
                  .doctorResearchDocumentModelData.value.apiState ==
              APIState.COMPLETE) {
            return ListView.separated(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: _doctorHomeScreenController
                      .doctorResearchDocumentModelData
                      .value
                      .doctorResearchDocument
                      ?.length ??
                  0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.blogdetailedviewdoctor,
                        arguments: _doctorHomeScreenController
                            .doctorResearchDocumentModelData
                            .value
                            .doctorResearchDocument?[index]
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
                                "${_doctorHomeScreenController.doctorResearchDocumentModelData.value.doctorResearchDocument?[index].researchTitle}",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (_doctorHomeScreenController
                  .doctorResearchDocumentModelData.value.apiState ==
              APIState.COMPLETE_WITH_NO_DATA) {
            return const Center(
              child: Text(
                'No data to show!',
                style: TextStyle(fontSize: 21),
              ),
            );
          } else if (_doctorHomeScreenController
                  .doctorResearchDocumentModelData.value.apiState ==
              APIState.ERROR) {
            return const Center(
              child: Text('Error'),
            );
          } else if (_doctorHomeScreenController
                  .doctorResearchDocumentModelData.value.apiState ==
              APIState.PROCESSING) {
            return Center(
                            child: Utils.circular(),
                          );
          } else {
            return const Center(
              child: Text(
                'No Data!',
                style: TextStyle(fontSize: 21),
              ),
            );
          }
        }),
        const SizedBox(height: 5),
      ],
    );
  }
}
