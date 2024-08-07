import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/model/patient_homepage_model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';

class VisitedDoctorListItem extends StatelessWidget {
  final UpcomingAppointments doctor;
  final bool isHome;

  VisitedDoctorListItem({Key key, @required this.doctor, this.isHome = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Container(
      width: 140,
      height: 140,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _isDark ? Colors.grey.withOpacity(0.2) : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0c000000),
              offset: Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 0),
          BoxShadow(
              color: Color(0x0c000000),
              offset: Offset(0, -5),
              blurRadius: 5,
              spreadRadius: 0),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // CircleAvatar(
          //   radius: 30,
          //   backgroundColor: Colors.grey,
          //   backgroundImage:NetworkImage("${doctor.doctorProfilePic}") ,
          //   onBackgroundImageError: (ex, st){
          //     print("ex ==> $ex");
          //
          //     return Center(child: Text("${doctor.doctorFirstName?.runes?.first}"));
          //
          //   },
          // ),

          Utils().patientProfile(doctor?.doctorProfilePic ?? "",
              doctor?.doctorSocialProfilePic ?? "", 30),

          SizedBox(
            height: 15,
          ),
          Text(
            "${doctor.doctorFirstName} ${doctor.doctorLastName}",
            style: TextStyle(
              fontSize: 18,
              color: _isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            isHome
                ? doctor.purposeOfVisit ?? ""
                : doctor.doctorSpeciality ?? "",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
