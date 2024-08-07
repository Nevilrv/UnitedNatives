import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/model/visited_patient_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class VisitedPatientListItem extends StatelessWidget {
  final VisitedPatient patient;

  const VisitedPatientListItem({Key key, @required this.patient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Container(
      width: 140,
      // height: 140,
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
          //   backgroundImage: NetworkImage('${patient.patientProfilePic}'),
          // ),

          CircleAvatar(
            radius: 30,
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: OctoImage(
                image: CachedNetworkImageProvider(patient.patientProfilePic ??
                    'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                // placeholderBuilder: OctoPlaceholder.blurHash(
                //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                // ),
                progressIndicatorBuilder: (context, progress) {
                  double? value;
                  var expectedBytes = progress?.expectedTotalBytes;
                  if (progress != null && expectedBytes != null) {
                    value = progress.cumulativeBytesLoaded / expectedBytes;
                  }
                  return CircularProgressIndicator(value: value);
                },
                errorBuilder: OctoError.circleAvatar(
                  backgroundColor: Colors.white,
                  text: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                    color: Color(0xFF7E7D7D),
                  ),
                ),
                fit: BoxFit.fill,
                height: Get.height,
                width: Get.height,
              ),
            ),
          ),
          SizedBox(
            height: 17,
          ),
          Text(
            "${patient.patientFirstName}",
            style: TextStyle(
              color: _isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "${patient.purposeOfVisit}",
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
