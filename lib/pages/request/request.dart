import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_request_list_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/pages/request/maintenace%20req.dart';
import 'package:united_natives/pages/request/requset_list_screen.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/patient_request_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  RequestController requestController = Get.find();
  List<String> title = [
    'maintenance requests',
    'medical transportation requests',
    'social services requests',
    'meeting with provider'
  ];
  List<String> image = [
    'https://www.thepowerscompany.com/wp-content/uploads/2020/10/117160191_m.jpg',
    'https://pharmashots.com/wp-content/uploads/2020/07/Image20200708114456.jpg',
    'https://pbs.twimg.com/media/CwYxwnRVQAApSkp.jpg',
    'https://www.eatthis.com/wp-content/uploads/sites/4/2017/09/patient-meeting-doctor.jpg?quality=82&strip=1&resize=640%2C360'
  ];
  @override
  void initState() {
    // TODO: implement initState
    requestController.getRequestList();
    super.initState();
  }

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
            'Request',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (val) async {
                  if (val == 1) {
                    await requestController.allRequest();
                    Get.to(RequestListScreen());
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  size: Get.height * 0.03,
                ),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Text("All Request"),
                      ),
                    ])
          ],
        ),
        body: SafeArea(
          child: GetBuilder<RequestController>(
            builder: (controller) {
              if (controller.getRequestListApiResponse.status ==
                  Status.LOADING) {
                // return Center(child: CircularProgressIndicator());
                return Center(
                  child: Utils.circular(),
                );
              }
              if (controller.getRequestListApiResponse.status == Status.ERROR) {
                return const Center(child: Text('Server error'));
              }
              RequestListResponseModel responseModel =
                  controller.getRequestListApiResponse.data;
              if (responseModel.data!.isEmpty) {
                return const Center(child: Text('No request found'));
              }
              return ListView.builder(
                itemCount: responseModel.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: Get.height * 0.012,
                          top: Get.height * 0.01,
                          right: Get.width * 0.03,
                          left: Get.width * 0.03,
                        ),
                        height: Get.height * 0.2,
                        child: GestureDetector(
                            onTap: () {
                              /* index == 3
                                    ? Get.to(DoctorScreen())
                                    :*/
                              Get.to(MaintenanceRequestScreen(
                                categoryId: responseModel.data?[index].id,
                              ));
                            },
                            child: requestContainer(
                                index, context, responseModel)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }

  Stack requestContainer(
      int index, BuildContext context, RequestListResponseModel model) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: model.data?[index].featuredImage == null ||
                    model.data?[index].featuredImage == ''
                ? 'https://www.thepowerscompany.com/wp-content/uploads/2020/10/117160191_m.jpg'
                : model.data![index].featuredImage!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                // Center(child: CircularProgressIndicator()),
                Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          height: Get.height,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                model.data?[index].title ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: Get.height * 0.03,
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
