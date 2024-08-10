import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/appointment.dart';

import '../../components/custom_profile_item.dart';
import '../../utils/utils.dart';

class VisitDetailPage extends StatefulWidget {
  // PastAppointments doctorDetails;
  final Appointment doctorDetails;
  const VisitDetailPage({super.key, required this.doctorDetails});
  @override
  State<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends State<VisitDetailPage> {
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
          title: Text(Translate.of(context)!.translate('visit_detail'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
              textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(4),
                  //   border: Border.all(width: 1, color: Colors.grey[200]),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30,
                              backgroundImage: NetworkImage(
                                widget.doctorDetails.doctorProfilePic!,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${widget.doctorDetails.doctorFirstName} ${widget.doctorDetails.doctorLastName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.doctorDetails.doctorSpeciality!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Text(
                                  // '${widget.doctorDetails.appointmentTime} ${DateFormat('EEEE, dd MMM yyyy'
                                  // ).format(DateTime.parse(widget.doctorDetails.appointmentDate))}',
                                  DateFormat('EEEE, dd MMM yyyy, hh:mm a')
                                      .format(Utils.formattedDate(
                                          '${DateTime.parse('${widget.doctorDetails.appointmentDate} ${widget.doctorDetails.appointmentTime}')}')),
                                  // 'Thu. 17:00 - 14 February 2019',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Text(
                                  // '${widget.doctorDetails.appointmentDate}',
                                  'St. Anthony Street 15A. Moscow',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        Translate.of(context)!.translate('diagnosis'),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.keyboard_arrow_up,
                        color: Theme.of(context).textTheme.titleLarge?.color),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'The most possible cause of your pain is Acute Pharyngitis. This is more commonly known as \'sore throat\'. It\'s a chort-term infection of pharynx (throat) caused by different viruses or bacteria',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                CustomProfileItem(
                  onTap: () {},
                  title:
                      Translate.of(context)!.translate('physical_examination'),
                  subTitle: '14/02/2019',
                  buttonTitle: Translate.of(context)!.translate('see_reports'),
                  imagePath: 'assets/images/icon_examination.png',
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        Translate.of(context)!.translate('recommendation'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Most cases of Acute Pharyngitis are self-limited, meaning they\'ll resolve independently. In those cases, medical care is primarily supportive and includes pain relievers',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
