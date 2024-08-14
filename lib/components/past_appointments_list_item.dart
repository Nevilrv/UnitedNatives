import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';

class PastAppointmentListItem extends StatelessWidget {
  final Appointment patientAppoint;

  const PastAppointmentListItem(this.patientAppoint, {super.key});
  @override
  Widget build(BuildContext context) {
    final time = Utils.formattedDate(
        '${DateTime.parse('${patientAppoint.appointmentDate} ${patientAppoint.appointmentTime}')}');
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.prescriptionpage, arguments: patientAppoint.id);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('date'),
                      subtitle: DateFormat('EEEE, dd MMM yyyy').format(time),
                      // subtitle: ,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('time'),
                      subtitle: DateFormat('hh:mm a').format(time),
                      // subtitle: '${patientAppoint.appointmentTime.toString()}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (patientAppoint.vcStartTime != null &&
                patientAppoint.vcEndTime != null &&
                patientAppoint.vcStartTime != "00:00:00" &&
                patientAppoint.vcEndTime != "00:00:00" &&
                (patientAppoint.vcDuration.toString() != "null" &&
                    int.parse(patientAppoint.vcDuration ?? "0") > 0)) ...[
              const Divider(
                height: 1,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Builder(builder: (context) {
                        String finalTime =
                            DateTime.now().toString().split(" ").first;
                        String temp =
                            "$finalTime ${patientAppoint.vcStartTime}";
                        String time = DateFormat('hh:mm:ss')
                            .format(Utils.formattedDate(temp));

                        return _buildColumn(
                          context: context,
                          title:
                              Translate.of(context)!.translate('Start Meeting'),
                          subtitle: time,
                        );
                      }),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        String finalTime =
                            DateTime.now().toString().split(" ").first;
                        String temp = "$finalTime ${patientAppoint.vcEndTime}";
                        String time = DateFormat('hh:mm:ss')
                            .format(Utils.formattedDate(temp));

                        return _buildColumn(
                          context: context,
                          title:
                              Translate.of(context)!.translate('End Meeting'),
                          subtitle: time,
                        );
                      }),
                    ),
                    Expanded(
                      child: _buildColumn(
                        context: context,
                        title: Translate.of(context)!.translate('Duration'),
                        subtitle: '${patientAppoint.vcDuration ?? ""} Minutes',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('doctor'),
                      subtitle:
                          '${patientAppoint.doctorFirstName} ${patientAppoint.doctorLastName}',
                    ),
                  ),
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('speciality'),
                      subtitle: patientAppoint.doctorSpeciality ?? "",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15)
                  .copyWith(bottom: 15),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.prescriptionpage,
                      arguments: patientAppoint.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See Prescription',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 18, color: kColorBlue),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _buildColumn({
    required BuildContext context,
    required String title,
    required subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
