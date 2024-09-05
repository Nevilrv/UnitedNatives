import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_all_request_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/patient_request_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  RequestController requestController = Get.put(RequestController());

  List<String> title = [
    'maintenance requests',
    'medical transportation requests',
    'social services requests',
    'meeting with provider'
  ];
  @override
  void initState() {
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
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Request List',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
          ),
        ),
        body: GetBuilder<RequestController>(
          builder: (controller) {
            if (controller.allRequestApiResponse.status == Status.LOADING) {
              // return Center(child: CircularProgressIndicator());
              return Center(
                child: Utils.circular(),
              );
            }
            if (controller.allRequestApiResponse.status == Status.ERROR) {
              return const Center(child: Text('Server error'));
            }
            AllRequestResponseModel responseModel =
                controller.allRequestApiResponse.data;
            if (responseModel.data!.isEmpty) {
              return const Center(child: Text('No request found'));
            }
            return SizedBox(
              height: Get.height,
              child: ListView.builder(
                itemCount: responseModel.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(Get.height * 0.014),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Get.height * 0.014),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  responseModel.data?[index].categoryTitle ??
                                      "",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: Get.height * 0.028,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                // Icon(
                                //   Icons.delete,
                                //   color: Colors.blue,
                                //   size: Get.width * 0.055,
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Time: ',
                                  style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: Get.width * 0.01,
                                ),
                                Text(
                                  responseModel.data?[index].time ?? "",
                                  style:
                                      TextStyle(fontSize: Get.height * 0.025),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Date: ',
                                  style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: Get.width * 0.01,
                                ),
                                Text(
                                  responseModel.data?[index].date ?? "",
                                  style: TextStyle(
                                    fontSize: Get.height * 0.025,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Note: ',
                                  style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: Get.width * 0.01,
                                ),
                                Flexible(
                                  child: Text(
                                    responseModel.data?[index].notes ?? '',
                                    style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status: ',
                                  style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: Get.width * 0.01,
                                ),
                                Flexible(
                                  child: Text(
                                    responseModel.data?[index].statusDisplay ??
                                        "",
                                    style: TextStyle(
                                      fontSize: Get.height * 0.025,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}
