import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/progress_indicator.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';

class DirectAppointmentScreen extends StatefulWidget {
  const DirectAppointmentScreen({super.key});

  @override
  _DirectAppointmentScreenState createState() =>
      _DirectAppointmentScreenState();
}

class _DirectAppointmentScreenState extends State<DirectAppointmentScreen> {
  final BookAppointmentController _bookAppointmentController = Get.find();
  final RxBool _isLoading = false.obs;

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    /// HELLO WORLD ///

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
                  color: Theme.of(context).textTheme.titleMedium?.color,
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
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            Translate.of(context)!
                                .translate('choose_health_concern'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Obx(
                          () => MasonryGridView.count(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            crossAxisCount: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _bookAppointmentController
                                    .specialitiesModelData
                                    .value
                                    .specialities
                                    ?.length ??
                                0,

                            /// NEW CODE COMMENT

                            // staggeredTileBuilder: (int index) =>
                            //     StaggeredTile.fit(2),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            backgroundImage: NetworkImage(
                                                "${_bookAppointmentController.specialitiesModelData.value.specialities![index].specialityIcon}"),
                                            radius: 25),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                              "${_bookAppointmentController.specialitiesModelData.value.specialities?[index].specialityName}",
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
                        const SizedBox(height: 20),
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
              child: _isLoading.value
                  ? const ProgressIndicatorScreen()
                  : Container()),
        ),
      ],
    );
  }
}
