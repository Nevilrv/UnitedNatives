import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/patient_detail_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';
import 'custom_button.dart';

class MyPatientListItem extends StatelessWidget {
  final PatientData? patient;

  const MyPatientListItem({super.key, @required this.patient});

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? Colors.grey.withOpacity(0.2) : const Color(0xffEBF2F5),
      ),
      child: Row(
        children: <Widget>[
          // CircleAvatar(
          //   radius: 35,
          //   backgroundColor: Colors.transparent,
          //   backgroundImage: NetworkImage(
          //     '${patient.patientProfilePic}',
          //   ),
          //   onBackgroundImageError: (context, error) {
          //     return Container(
          //       color: Colors.green,
          //       width: 100,
          //       height: 100,
          //     );
          //   },
          // ),

          Utils().patientProfile(patient?.patientProfilePic ?? "",
              patient?.patientProfilePic ?? "", 35),

          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${patient?.patientFirstName} ${patient?.patientLastName}",
                  style: TextStyle(
                    color: isDark ? Colors.white : kColorPrimaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // if (patient.purposeOfVisit.isNotEmpty)
                //   Text(
                //     "${patient.purposeOfVisit}",
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w400,
                //     ),
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //   ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          CustomButton(
            text: Translate.of(context)!.translate('details'),
            textSize: 16,
            onPressed: () {
              Get.toNamed(Routes.patientListVisitPage, arguments: patient);
            },
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
          )
        ],
      ),
    );
  }
}
