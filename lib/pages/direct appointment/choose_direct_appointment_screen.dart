import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/doctor_item.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_direct_doctor_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/direct%20appointment/time_slot_page_direct_appointment.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/direct_doctor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class ChooseDirectAppointmentScreen extends StatefulWidget {
  ChooseDirectAppointmentScreen({Key key}) : super(key: key);

  @override
  _ChooseDirectAppointmentScreenState createState() =>
      _ChooseDirectAppointmentScreenState();
}

class _ChooseDirectAppointmentScreenState
    extends State<ChooseDirectAppointmentScreen> {
  DirectDoctorController directDoctorController =
      Get.put(DirectDoctorController());

  AdsController adsController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    directDoctorController.getDirectDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  Translate.of(context).translate('doctor'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.subtitle1.color,
                      fontSize: 24),
                ),
                // actions: <Widget>[
                //   Obx(
                //     () => _bookAppointmentController.isFiltered.value
                //         ? IconButton(
                //             onPressed: () {
                //               // Get.toNamed(Routes.filter, arguments: id);
                //               // Navigator.of(context).pushNamed(Routes.filter);
                //             },
                //             icon: Icon(
                //               Icons.filter_list,
                //             ),
                //           )
                //         : IconButton(
                //             onPressed: () {
                //               _bookAppointmentController.getDoctorSpecialities(
                //                   id, context);
                //               // _bookAppointmentController.getFilteredDoctor(widget.id, _userController.user.value.id, '${_availability.index}', _male == true ? 'male' : 'female', '${_consultationFee.index}');
                //               // _bookAppointmentController.isFiltered.isFalse;
                //               // Get.toNamed(Routes.filter, arguments: id);
                //               // Navigator.of(context).pushNamed(Routes.filter);
                //             },
                //             icon: Icon(
                //               Icons.close,
                //             ),
                //           ),
                //   )
                // ],
              ),
              body: GetBuilder<DirectDoctorController>(
                builder: (controller) {
                  if (controller.getDirectDoctorApiResponse.status ==
                      Status.LOADING) {
                    // return Center(child: CircularProgressIndicator());
                    return Center(
                      child: Utils.circular(),
                    );
                  }
                  if (controller.getDirectDoctorApiResponse.status ==
                      Status.ERROR) {
                    return Center(
                      child: Text("Server error"),
                    );
                  }
                  GetDirectDoctorResponseModel responseModel =
                      controller.getDirectDoctorApiResponse.data;
                  if (responseModel.data == null) {
                    return Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(fontSize: 21),
                      ),
                    );
                  } else if (responseModel.data.length <= 0) {
                    return Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(fontSize: 21),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, indent: 15, endIndent: 15),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: responseModel.data.length,
                          itemBuilder: (context, index) {
                            String doctorName =
                                "${responseModel.data[index].firstName ?? "Dr."}" +
                                    " ${responseModel.data[index].lastName ?? "Lee"}";
                            return DoctorItem(
                                doctorAvatar:
                                    responseModel.data[index].profilePic ??
                                        "assets/images/Doctor_lee.png",
                                doctorName: doctorName,
                                doctorPrice: responseModel
                                        .data[index].perAppointmentCharge ??
                                    "100",
                                doctorSpeciality:
                                    responseModel.data[index].speciality,
                                rating:
                                    responseModel.data[index].rating.toString(),
                                // onTap: () => Get.toNamed(Routes.bookingStep3, arguments: _bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities[index]),
                                onTap: () {
                                  // _bookAppointmentController
                                  //   ..selectedIndex.value = (-1)
                                  //   ..items.clear()
                                  //   ..getPatientAppointment(
                                  //       _bookAppointmentController
                                  //           .doctorBySpecialitiesModelData
                                  //           .value
                                  //           .doctorSpecialities[index]
                                  //           .userId,
                                  //       context);
                                  Get.to(TimeSlotPageDirectPage(
                                    doctorDetails: responseModel.data[index],
                                  ));
                                  // Get.toNamed(Routes.bookingStep3,
                                  //     arguments: _bookAppointmentController
                                  //         .doctorBySpecialitiesModelData
                                  //         .value
                                  //         .doctorSpecialities[index]);
                                });
                          },
                        )
                      ],
                    ),
                  );
                },
              ));
        }),
      ],
    );
  }
}
