import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientDetailSCreen extends StatefulWidget {
  final String? profilePic;
  final String? fullName;
  final String? lastName;
  final String? email;
  final String? bloodGroup;
  final String? gender;
  final String? insuranceStatus;
  final String? tribalStatus;

  const PatientDetailSCreen(
      {super.key,
      this.profilePic,
      this.fullName,
      this.lastName,
      this.email,
      this.bloodGroup,
      this.gender,
      this.insuranceStatus,
      this.tribalStatus});

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
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),

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
            const SizedBox(height: 20),
            Text(
              '${widget.fullName} ${widget.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.email}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade500),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1),
            SizedBox(
              height: 90,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/gender.png',
                            height: 30, width: 30),
                        const SizedBox(height: 5),
                        Text(
                          widget.gender ?? '',
                          style: const TextStyle(
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
                        const SizedBox(height: 5),
                        Text(widget.bloodGroup ?? 'A+',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Insurance Eligibility :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    ' ${widget.insuranceStatus?.capitalize ?? ""}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Tribal Status :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    ' ${widget.tribalStatus?.capitalize ?? ""}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 22),
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
