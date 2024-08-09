import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/utils.dart';

class PastAppointmentListItemDoctor extends StatelessWidget {
  final PatientAppoint patientAppoint;

  const PastAppointmentListItemDoctor(this.patientAppoint, {super.key});
  @override
  Widget build(BuildContext context) {
    final time = Utils.formattedDate(
        '${patientAppoint.appointmentDate} ${patientAppoint.appointmentTime}');

    return GestureDetector(
      onTap: () {
        VisitedPatient patientData = VisitedPatient(
            appointmentId: patientAppoint.id,
            patientId: patientAppoint.patientId);
        Navigator.of(context)
            .pushNamed(Routes.doctorprescriptionpage, arguments: patientData);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('date'),
                      subtitle: DateFormat('EEEE, dd MMM yyyy').format(time),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: Translate.of(context)!.translate('time'),
                      subtitle: DateFormat('hh:mm a').format(time),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: 'Client Name',
                      subtitle:
                          '${patientAppoint.patientFirstName} ${patientAppoint.patientLastName}',
                    ),
                  ),
                  Expanded(
                    child: _buildColumn(
                      context: context,
                      title: 'Purpose of Visit',
                      subtitle: patientAppoint.purposeOfVisit ?? "",
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
                  VisitedPatient patientData = VisitedPatient(
                      appointmentId: patientAppoint.id,
                      patientId: patientAppoint.patientId);
                  Navigator.of(context).pushNamed(Routes.doctorprescriptionpage,
                      arguments: patientData);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See Prescription',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 18),
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
            fontSize: 18,
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
