import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/services_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
import 'package:doctor_appointment_booking/pages/services/service_detail_screen.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorServices extends StatefulWidget {
  @override
  _DoctorServicesState createState() => _DoctorServicesState();
}

class _DoctorServicesState extends State<DoctorServices> {
  ServicesDataController servicesController = Get.put(ServicesDataController());

  @override
  void initState() {
    servicesController.getServicesDoctor();
    // TODO: implement initState
    super.initState();
  }

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          title: Text('Services',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.subtitle1.color,
                  fontSize: 24),
              textAlign: TextAlign.center),
        ),
        body: GetBuilder<ServicesDataController>(
          builder: (controller) {
            if (controller.getServicesDoctorApiResponse.status ==
                Status.LOADING) {
              return Center(
                child: Utils.circular(),
              );
            }
            if (controller.getServicesDoctorApiResponse.status ==
                Status.ERROR) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text("Server error")),
              );
            }
            ServicesResponseModel response =
                controller.getServicesDoctorApiResponse.data;
            if (response.data.length == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text("No services found")),
              );
            }
            return ListView.builder(
              itemCount: response.data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => ServiceDetailScreen(
                          image: response.data[index].featuredImage,
                          title: response.data[index].title,
                          description: response.data[index].description,
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: h * 0.2,
                    child: servicesCard(context, response, index),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  Stack servicesCard(
      BuildContext context, ServicesResponseModel responseModel, int index) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: responseModel.data[index].featuredImage == null ||
                    responseModel.data[index].featuredImage == ''
                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJUHNY8udnX0Rb5RUn9a3IVLHm1yGY4UQHBw&usqp=CAU'
                : responseModel.data[index].featuredImage,
            imageBuilder: (context, imageProvider) => Container(
              // width: 420.0,
              // height: 400.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Container(
          height: h,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),
        Container(
          width: w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${responseModel.data[index].title ?? ""}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
