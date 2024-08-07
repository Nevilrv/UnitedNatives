import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/model/patient_homepage_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/model/patient_homepage_model.dart';
import '../../components/custom_recipe_item.dart';

class PrescriptionDetailPage extends StatefulWidget {
  final List<Prescriptions>? patientPrescription;

  const PrescriptionDetailPage({super.key, this.patientPrescription});

  @override
  State<PrescriptionDetailPage> createState() => _PrescriptionDetailPageState();
}

class _PrescriptionDetailPageState extends State<PrescriptionDetailPage> {
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
          actions: <Widget>[],
          title: Text(
            Translate.of(context).translate('prescription_detail'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Builder(builder: (context) {
                  widget.patientPrescription
                      .sort((a, b) => a.created.compareTo(b.created));
                  return ListView.builder(
                    itemCount: widget.patientPrescription?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      Prescriptions _prescription =
                          widget.patientPrescription[index];

                      return Column(
                        children: [
                          CustomRecipeItem(
                            purpose: "${_prescription?.purposeOfVisit ?? ""}",
                            title:
                                "${_prescription?.medicineName ?? "Cipla X524"}",
                            subTitle:
                                "${_prescription?.additionalNotes ?? "Pain Killer"}",
                            days:
                                '${_prescription?.treatmentDays ?? "2"} ${Translate.of(context).translate('days')}',
                            pills:
                                '${_prescription?.pillsPerDay ?? ""} ${Translate.of(context).translate('pills')}',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
