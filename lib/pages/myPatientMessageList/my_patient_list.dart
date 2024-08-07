import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/controller/doctor_homescreen_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/get_all_patient_response_model.dart';
import 'package:doctor_appointment_booking/pages/myPatientMessageList/patient_message_detail_page.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class MyPatientLists extends StatefulWidget {
  final Patient patient;

  MyPatientLists({
    Key key,
    @required this.patient,
  }) : super(key: key);

  @override
  _MyPatientListsState createState() => _MyPatientListsState();
}

class _MyPatientListsState extends State<MyPatientLists> {
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final DoctorHomeScreenController doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _isDark ? Colors.grey.withOpacity(0.2) : Color(0xffEBF2F5),
      ),
      child: Row(
        children: <Widget>[
          // widget.patient.socialProfilePic != null
          // ? CircleAvatar(
          //     radius: 35,
          //     backgroundColor: Colors.transparent,
          //     backgroundImage: NetworkImage(
          //       widget.patient.socialProfilePic,
          //     ),
          //   )
          // : CircleAvatar(
          //     radius: 35,
          //     backgroundColor: Colors.transparent,
          //     backgroundImage: NetworkImage(
          //       widget.patient.profilePic,
          //     ),
          //   ),

          Utils().patientProfile(widget.patient.profilePic ?? "",
              widget.patient.socialProfilePic ?? "", 35),

          // CircleAvatar(
          //   radius: 35,
          //   backgroundColor: Colors.transparent,
          //   child: CachedNetworkImage(
          //     imageUrl: widget.patient.socialProfilePic != null
          //         ? widget.patient.socialProfilePic
          //         : widget.patient.profilePic,
          //     imageBuilder: (context, imageProvider) {
          //       return CircleAvatar(radius: 35, backgroundImage: imageProvider);
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
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (widget.patient?.firstName ?? "") +
                      " " +
                      (widget.patient?.lastName ?? ""),
                  style: TextStyle(
                      color: _isDark ? Colors.white : kColorPrimaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                /*Text(
                  patient?. ?? "" + '\n',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),*/
                // RatingBar.builder(
                //   itemSize: 20,
                //   initialRating: doctor.rating.toDouble(),
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   ignoreGestures: true,
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //   ),
                //   onRatingUpdate: (rating) {
                //     print(rating);
                //   },
                // ),
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
              // _doctorHomeScreenController.doctorChat.value = shortedDoctorChat;
              // await Navigator.of(context).pushNamed(Routes.doctorchatDetail);

              // _doctorHomeScreenController.onPatientTapFromDoctorList(
              //     context, patient);
              print('ChatKey ${widget.patient.chatKey}');
              // _doctorHomeScreenController.getAllChatMessagesDoctor(
              //     isAll: true, chatKey: widget.patient.chatKey);
              Get.to(
                () => DoctorMessagesDetailPage2(
                  chatKey: widget.patient.chatKey,
                  fullName: widget.patient.firstName,
                  lastName: widget.patient.lastName,
                  profilePic: widget.patient.socialProfilePic != null
                      ? widget.patient.socialProfilePic
                      : widget.patient.profilePic,
                  bloodGroup: widget.patient.bloodGroup,
                  email: widget.patient.email,
                  gender: widget.patient.gender,
                  insuranceStatus: widget.patient.insuranceEligibility,
                  tribalStatus: widget.patient.tribalStatus,
                  patientId: widget.patient.id,
                ),
              );

              // final patientHomeScreenController =
              // Get.find<PatientHomeScreenController>();
              // patientHomeScreenController.onDoctorTapFromDoctorList(
              //     context, doctor);
              // patientHomeScreenController
              //     .getAllPatientChatMessagesList(doctor.chatKey);
              // Get.toNamed(Routes.chatDetail, arguments: doctor);
              // Navigator.of(context).pushNamed(Routes.chatDetail);
            },
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          )
        ],
      ),
    );
  }
}
