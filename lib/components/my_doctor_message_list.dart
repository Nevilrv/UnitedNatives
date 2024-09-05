import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/get_all_doctor.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';
import 'custom_button.dart';

class MyDoctorMessageLists extends StatelessWidget {
  final Doctor? doctor;

  const MyDoctorMessageLists({super.key, @required this.doctor});

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
          //     doctor.profilePic,
          //   ),
          //   onBackgroundImageError: (context, e) {
          //     return Container();
          //   },
          // ),

          Utils().patientProfile(
              doctor?.profilePic ?? "", doctor?.socialProfilePic ?? "", 35),

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

          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${doctor?.firstName ?? ""} ${doctor?.lastName ?? ""}",
                  style: TextStyle(
                    color: isDark ? Colors.white : kColorPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  doctor?.education ?? "" '\n',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                RatingBar.builder(
                  itemSize: 20,
                  initialRating: doctor!.rating!.toDouble(),
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CustomButton(
            text: Translate.of(context)!.translate('Message'),
            textSize: 16,
            onPressed: () async {
              final patientHomeScreenController =
                  Get.find<PatientHomeScreenController>();

              patientHomeScreenController.onDoctorTapFromDoctorList(
                  context, doctor!);
              // patientHomeScreenController
              //     .getAllPatientChatMessagesList(doctor.chatKey);
              // Get.toNamed(Routes.chatDetail, arguments: doctor);
              // Navigator.of(context).pushNamed(Routes.chatDetail);
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
