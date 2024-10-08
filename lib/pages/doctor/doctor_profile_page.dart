import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/doctor_by_specialities.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:url_launcher/url_launcher.dart';
import '../../components/round_icon_button.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class DoctorProfilePage extends StatelessWidget {
  final DoctorSpecialities doctor;

  DoctorProfilePage({super.key, required this.doctor});
  final BookAppointmentController _bookAppointmentController =
      Get.find<BookAppointmentController>();
  @override
  Widget build(BuildContext context) {
    void launchCaller(String number) async {
      var url = "tel:${number.toString()}";
      if (await canLaunchUrl(Uri.parse(url))) {
        // await launch(url);
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not place call';
      }
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              //backgroundColor: Colors.white,
              elevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Utils().patientProfile(doctor.profilePic ?? '',
                      doctor.socialProfilePic ?? '', 130,
                      fit: BoxFit.contain),
                ).paddingOnly(top: 25),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   'available_now'.tr().toUpperCase(),
                          //   style: TextStyle(
                          //     color: Color(0xff40E58C),
                          //     fontSize: 8,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                          Text(
                            '${doctor.firstName}'
                            ' '
                            '${doctor.lastName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            "${doctor.education}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: doctor.rating?.toDouble() ?? 0,
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
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[350],
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'about'.tr(),
                //   style: Theme.of(context).textTheme.headline6.copyWith(
                //         fontWeight: FontWeight.w700,
                //       ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'Doctor Tawfiq Bahri, is a Doctor primarily located in New York, with another office in Atlantic City, New Jersey. He has 16 years of experience. His specialities include Family Medicine and Cardiology.',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    RoundIconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icons.message,
                      elevation: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RoundIconButton(
                      onPressed: () {
                        launchCaller(doctor.contactNumber!);
                      },
                      icon: Icons.phone,
                      elevation: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          if (doctor == null) {
                            Get.toNamed(Routes.bookingStep2,
                                arguments: _bookAppointmentController
                                    .specialitiesModelData
                                    .value
                                    .specialities?[0]
                                    .id);
                          } else {
                            _bookAppointmentController
                              ..selectedIndex.value = (-1)
                              ..items = <Map<String, dynamic>>[].obs
                              ..getPatientAppointment(doctor.id ?? "", context);
                            Get.toNamed(Routes.bookingStep3, arguments: doctor);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: SizedBox(
                          height: 48,
                          child: Center(
                            child: Text(
                              Translate.of(context)!
                                  .translate('book_an_appointment')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
