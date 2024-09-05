import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/ResponseModel/visited_patient_model.dart';

class VisitedPatientListItem extends StatelessWidget {
  final VisitedPatient? patient;

  const VisitedPatientListItem({super.key, this.patient});

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDark ? Colors.grey.withOpacity(0.2) : Colors.white,
        boxShadow: const [
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
          CircleAvatar(
            radius: 30,
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: OctoImage(
                image: CachedNetworkImageProvider(patient?.patientProfilePic ??
                    'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
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
                    color: const Color(0xFF7E7D7D),
                  ),
                ),
                fit: BoxFit.fill,
                height: Get.height,
                width: Get.height,
              ),
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          Text(
            "${patient?.patientFirstName}",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            "${patient?.purposeOfVisit}",
            style: const TextStyle(
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
