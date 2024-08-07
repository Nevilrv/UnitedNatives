import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/progress_indicator.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart' hide Trans;

class DirectAppointmentScreen extends StatefulWidget {
  @override
  _DirectAppointmentScreenState createState() =>
      _DirectAppointmentScreenState();
}

class _DirectAppointmentScreenState extends State<DirectAppointmentScreen> {
  BookAppointmentController _bookAppointmentController = Get.find();
  RxBool _isLoading = false.obs;

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    _bookAppointmentController.getSpecialities(_isLoading);
    return Stack(
      children: [
        GetBuilder<AdsController>(builder: (ads) {
          return Scaffold(
            bottomNavigationBar: AdsBottomBar(
              ads: ads,
              context: context,
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Direct Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.subtitle1.color,
                  fontSize: 24,
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            Translate.of(context)
                                .translate('choose_health_concern'),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Obx(
                          () => StaggeredGridView.countBuilder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            crossAxisCount: 4,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _bookAppointmentController
                                    .specialitiesModelData
                                    .value
                                    .specialities
                                    ?.length ??
                                0,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(2),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            itemBuilder: (context, index) {
                              // return HealthConcernItem(
                              //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
                              //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
                              //   onTap: () {
                              //     Navigator.of(context).pushNamed(Routes.bookingStep2);
                              //   },
                              // );
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    // Get.to(ChooseDirectAppointmentScreen(
                                    //   id: _bookAppointmentController
                                    //       .specialitiesModelData
                                    //       .value
                                    //       .specialities[index]
                                    //       .id,
                                    // ));
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            backgroundImage: NetworkImage(
                                                    "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
                                                AssetImage(
                                                    'assets/images/medicine.png'),
                                            radius: 25),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                              "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}" ??
                                                  Translate.of(context).translate(
                                                          'Women\'s Health') +
                                                      '\n',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        Obx(
          () => Container(
              child:
                  _isLoading.value ? ProgressIndicatorScreen() : Container()),
        ),
      ],
    );
  }
}
