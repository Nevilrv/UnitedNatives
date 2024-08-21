import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/newModel/apiModel/responseModel/services_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/services/service_detail_screen.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/services_view_model.dart';

class PatientServices extends StatefulWidget {
  const PatientServices({super.key});

  @override
  State<PatientServices> createState() => _PatientServicesState();
}

class _PatientServicesState extends State<PatientServices> {
  ServicesDataController servicesController = Get.put(ServicesDataController());

  @override
  void initState() {
    servicesController.getServicesPatient();

    super.initState();
  }

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Services',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: h * 0.02),
              GetBuilder<ServicesDataController>(
                builder: (controller) {
                  if (controller.getServicesPatientApiResponse.status ==
                      Status.LOADING) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Utils.circular(),
                        ));
                  }
                  if (controller.getServicesPatientApiResponse.status ==
                      Status.ERROR) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("Server error")),
                    );
                  }
                  ServicesResponseModel response =
                      controller.getServicesPatientApiResponse.data;
                  if (response.data == null) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("No services found")),
                    );
                  } else if (response.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("No services found")),
                    );
                  }
                  return ListView.builder(
                    itemCount: response.data?.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => ServiceDetailScreen(
                              image: response.data![index].featuredImage
                                  .toString(),
                              title: response.data![index].title.toString(),
                              description: response.data![index].description
                                  .toString()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: h * 0.012,
                            top: h * 0.01,
                            right: w * 0.03,
                            left: w * 0.03,
                          ),
                          height: h * 0.2,
                          child: servicesCard(context, response, index),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
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
            imageUrl: responseModel.data?[index].featuredImage == null ||
                    responseModel.data?[index].featuredImage == ''
                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJUHNY8udnX0Rb5RUn9a3IVLHm1yGY4UQHBw&usqp=CAU'
                : "${responseModel.data?[index].featuredImage.toString()}",
            imageBuilder: (context, imageProvider) => Container(
              // width: 420.0,
              // height: 400.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          height: h,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),
        SizedBox(
          width: w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                responseModel.data?[index].title ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: w * 0.1,
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
