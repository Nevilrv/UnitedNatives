import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/get_all_doctor.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;

import '../utils/constants.dart';
import 'custom_button.dart';

class MyDoctorMessageLists extends StatelessWidget {
  final Doctor doctor;

  MyDoctorMessageLists({Key key, @required this.doctor}) : super(key: key);

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
          //     doctor.profilePic,
          //   ),
          //   onBackgroundImageError: (context, e) {
          //     return Container();
          //   },
          // ),

          Utils().patientProfile(
              doctor.profilePic ?? "", doctor.socialProfilePic ?? "", 35),

          // CircleAvatar(
          //   radius: 35,
          //   backgroundColor: Colors.transparent,
          //   // backgroundImage: NetworkImage(
          //   //   doctor.profilePic,
          //   // ),
          //   child: CachedNetworkImage(
          //     imageUrl: doctor.profilePic,
          //     imageBuilder: (context, imageProvider) {
          //       return CircleAvatar(
          //         radius: 35,
          //         backgroundImage: imageProvider,
          //       );
          //     },
          //     errorWidget: (context, url, error) {
          //       return CircleAvatar(
          //         radius: 35,
          //         backgroundImage: AssetImage(
          //           defaultProfileImage,
          //         ),
          //         backgroundColor: Colors.grey.withOpacity(0.2),
          //       );
          //     },
          //   ),
          // ),

          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (doctor?.firstName ?? "") + " " + (doctor?.lastName ?? ""),
                  style: TextStyle(
                    color: _isDark ? Colors.white : kColorPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  doctor?.education ?? "" + '\n',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                RatingBar.builder(
                  itemSize: 20,
                  initialRating: doctor.rating.toDouble(),
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          CustomButton(
            text: Translate.of(context).translate('Message'),
            textSize: 16,
            onPressed: () async {
              final patientHomeScreenController =
                  Get.find<PatientHomeScreenController>();

              print(doctor.chatKey);
              patientHomeScreenController.onDoctorTapFromDoctorList(
                  context, doctor);
              // patientHomeScreenController
              //     .getAllPatientChatMessagesList(doctor.chatKey);
              // Get.toNamed(Routes.chatDetail, arguments: doctor);
              // Navigator.of(context).pushNamed(Routes.chatDetail);
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
