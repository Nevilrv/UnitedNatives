import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  Future health() async {
    http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Constants.healthRecommendation),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      Map<String, dynamic> temp = result;
      var a = temp['data']['id'];

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
              'Health Recommendation',
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
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
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
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Health Recommendation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Builder(builder: (context) {
                          var document =
                              parse(snapshot.data['data']['content']);
                          return Text(document.body!.text);
                        }),

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
                        const SizedBox(height: 15),
                        // Text(
                        //   'Though instances of doctors and patients entering romantic relationships are indeed rare, it does sometimes happen. Physicians sometimes have sexual relationships with patients, or with former patients. Sometimes the initiator is the physician, and sometimes it is the patient. Every allopathic doctor in India, the Commission had estimated, caters to at least 1,511 people, much higher than the WHO norm of one doctor for every 1,000 people. The shortage of trained nurses is more dire, with a nurse-to-population ratio of 1:670 against the WHO norm of 1:300.',
                        //   textAlign: TextAlign.justify,
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w400,fontSize: 18,
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
            future: health(),
          ));
    });
  }
}
