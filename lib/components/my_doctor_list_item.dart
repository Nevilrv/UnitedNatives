import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/appointment.dart';
import 'package:united_natives/utils/utils.dart';
import '../routes/routes.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

class MyDoctorListItem extends StatefulWidget {
  final Appointment? doctor;

  const MyDoctorListItem({super.key, @required this.doctor});

  @override
  State<MyDoctorListItem> createState() => _MyDoctorListItemState();
}

class _MyDoctorListItemState extends State<MyDoctorListItem> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  BookAppointmentController controller = Get.put(BookAppointmentController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _isDark ? Colors.grey.withOpacity(0.2) : const Color(0xffEBF2F5),
      ),
      child: Row(
        children: <Widget>[
          // CircleAvatar(
          //   radius: 35,
          //   backgroundColor: Colors.transparent,
          //   backgroundImage: NetworkImage("${doctor.doctorProfilePic}"),
          //   onBackgroundImageError: (context, error) {
          //     return Container();
          //   },
          // ),
          Utils().patientProfile(widget.doctor?.doctorProfilePic ?? "",
              widget.doctor?.doctorSocialProfilePic ?? "", 30),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${widget.doctor?.doctorFirstName} ${widget.doctor?.doctorLastName}",
                  style: TextStyle(
                    color: _isDark ? Colors.white : kColorPrimaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${widget.doctor?.doctorSpeciality}",
                  // doctor.doctorSpeciality + '\n' ,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                RatingBar.builder(
                  itemSize: 20,
                  initialRating: widget.doctor!.doctorRating!.toDouble(),
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
            text: Translate.of(context)!.translate('details'),
            textSize: 16,
            onPressed: () {
              Get.toNamed(Routes.doctorProfile2, arguments: widget.doctor);
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
