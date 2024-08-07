import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/patient_detail_model.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../utils/constants.dart';
import 'custom_button.dart';

class MyPatientListItem extends StatelessWidget {
  final PatientData patient;

  MyPatientListItem({Key key, @required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _isDark ? Colors.grey.withOpacity(0.2) : Color(0xffEBF2F5),
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

          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${patient.patientFirstName} ${patient.patientLastName}",
                  style: TextStyle(
                    color: _isDark ? Colors.white : kColorPrimaryDark,
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
          SizedBox(
            width: 5,
          ),
          CustomButton(
            text: Translate.of(context).translate('details'),
            textSize: 16,
            onPressed: () {
              Get.toNamed(Routes.patientListVisitPage, arguments: patient);
            },
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
          )
        ],
      ),
    );
  }
}
