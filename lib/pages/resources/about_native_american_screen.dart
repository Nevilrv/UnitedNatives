import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AboutNativeAmericanScreen extends StatefulWidget {
  const AboutNativeAmericanScreen({Key key}) : super(key: key);

  @override
  State<AboutNativeAmericanScreen> createState() =>
      _AboutNativeAmericanScreenState();
}

class _AboutNativeAmericanScreenState extends State<AboutNativeAmericanScreen> {
  Future aboutNativeAmerican() async {
    http.Response response = await http.get(
      Uri.parse('${Constants.baseUrl + Constants.aboutAmericanNatives}'),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print('response--------${jsonDecode(response.body)}');
      return result;
    } else {}
  }

  int randomAd;

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'About Native American',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          body: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
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
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'About Native American ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Html(
                          data: snapshot.data['data']
                              ['content'], //html string to be parsed
                          style: {
                            "br": Style(
                              color: Colors.green,
                              fontSize: FontSize(22),
                            ),
                          },
                        ),
                        SizedBox(height: 15),
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
            future: aboutNativeAmerican(),
          ));
    });
  }
}
