import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Future upcomingEventData() async {
    http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Constants.upcomingEvent),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {}
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
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Upcoming Event',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: upcomingEventData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data == null
                  ? Center(
                      child: Text(
                        "Server Error",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            // Container(
                            //   height: MediaQuery.of(context).size.height * 0.35,
                            //   width: MediaQuery.of(context).size.width,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(15),
                            //     image: DecorationImage(
                            //         image: NetworkImage('${snapshot.data['data']['image_url']}'),
                            //         fit: BoxFit.cover),
                            //     color: Colors.orange,
                            //   ),
                            // ),
                            CachedNetworkImage(
                              imageUrl: '${snapshot.data['data']['image_url']}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const SizedBox(height: 40),

                            const Text(
                              'Upcoming Event',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 15),

                            HtmlWidget(
                              snapshot.data['data']['content'].toString(),
                              textStyle: const TextStyle(fontSize: 20),
                            ),

                            // Html(
                            //   data: snapshot.data['data']
                            //       ['content'], //html string to be parsed
                            //   style: {
                            //     "br": Style(
                            //       color: Colors.green,
                            //       fontSize: FontSize(22),
                            //     ),
                            //   },
                            // ),
                            // Text(
                            //   '${snapshot.data['data']['image']}',
                            //   textAlign: TextAlign.justify,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w400,
                            //     fontSize: 18,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
            } else {
              return Center(
                child: Utils.circular(),
              );
            }
          },
        ),
      );
    });
  }
}

///RefreshController refreshController=RefreshCOntroller() SmartRefresher(controller,onRefresh(api no call controller.onCompletedisData))
