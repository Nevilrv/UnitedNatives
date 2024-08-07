import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientDetailSCreen extends StatefulWidget {
  final String profilePic;
  final String fullName;
  final String lastName;
  final String email;
  final String bloodGroup;
  final String gender;
  final String insuranceStatus;
  final String tribalStatus;

  const PatientDetailSCreen(
      {Key key,
      this.profilePic,
      this.fullName,
      this.lastName,
      this.email,
      this.bloodGroup,
      this.gender,
      this.insuranceStatus,
      this.tribalStatus})
      : super(key: key);

  @override
  State<PatientDetailSCreen> createState() => _PatientDetailSCreenState();
}

class _PatientDetailSCreenState extends State<PatientDetailSCreen> {
  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text(
            'Client Detail',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 30),

            Utils().patientProfile(widget.profilePic ?? "", "", 70),

            // CircleAvatar(
            //   radius: 70,
            //   backgroundColor: Colors.transparent,
            //   child: CachedNetworkImage(
            //     imageUrl: widget.profilePic,
            //     imageBuilder: (context, imageProvider) {
            //       return CircleAvatar(
            //           radius: 70, backgroundImage: imageProvider);
            //     },
            //     errorWidget: (context, url, error) {
            //       return CircleAvatar(
            //         radius: 70,
            //         backgroundImage: AssetImage(defaultProfileImage),
            //         backgroundColor: Colors.grey.withOpacity(0.2),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              '${widget.fullName} ${widget.lastName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
            SizedBox(height: 5),
            Text(
              '${widget.email}' ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade500),
            ),
            SizedBox(height: 5),
            Divider(thickness: 1),
            Container(
              height: 90,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/gender.png',
                            height: 30, width: 30),
                        SizedBox(height: 5),
                        Text(
                          widget.gender ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 90,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/blood.png',
                            height: 30, width: 30),
                        SizedBox(height: 5),
                        Text(widget.bloodGroup ?? 'A+',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Insurance Eligibility :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    ' ${widget.insuranceStatus.capitalize ?? ""}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Tribal Status :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    ' ${widget.tribalStatus.capitalize ?? ""}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
