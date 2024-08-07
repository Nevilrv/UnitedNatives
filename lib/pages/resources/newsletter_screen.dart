import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class NewsLetterScreen extends StatefulWidget {
  const NewsLetterScreen({Key key}) : super(key: key);

  @override
  State<NewsLetterScreen> createState() => _NewsLetterScreenState();
}

class _NewsLetterScreenState extends State<NewsLetterScreen> {
  Future newsLetterGetData() async {
    http.Response response = await http.get(
      Uri.parse('${Constants.baseUrl + Constants.allNewsLetter}'),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);
      return result;
    } else {}
  }

  AdsController adsController = Get.find();

  int randomAd;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'News Letter',
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
          body: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // Container(
                        //   height: MediaQuery.of(context).size.height * 0.3,
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //       color: Colors.green,
                        //       image: DecorationImage(
                        //           image: AssetImage('assets/images/news.png'),
                        //           fit: BoxFit.fill)),
                        // ),
                        // SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${snapshot.data['data'][0]['image_url']}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.28,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: snapshot.data['data'].isEmpty
                              ? Center(
                                  child: Text(
                                    'NO DATA FOUND',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 21),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      (snapshot.data['data'] as List).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          Html(
                                            data:
                                                '${snapshot.data['data'][index]['content']}',
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                '${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data['data'][index]['created_at']))}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${snapshot.data['data'][index]['author']}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                    // return Container(
                                    //   height: MediaQuery.of(context).size.height * 0.2,
                                    //   width: MediaQuery.of(context).size.width,
                                    //   child: Row(
                                    //     children: [
                                    //       Container(
                                    //         height: MediaQuery.of(context).size.height * 0.16,
                                    //         width: MediaQuery.of(context).size.width * 0.3,
                                    //         decoration: BoxDecoration(
                                    //           // color: Colors.blue,
                                    //             image: DecorationImage(
                                    //                 image:
                                    //                 AssetImage('assets/images/ipl_news.jpeg'),
                                    //                 fit: BoxFit.fill)),
                                    //       ),
                                    //       SizedBox(
                                    //           width: MediaQuery.of(context).size.width * 0.04),
                                    //       Expanded(
                                    //         child: Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             SizedBox(
                                    //                 height: MediaQuery.of(context).size.height *
                                    //                     0.02),
                                    //             Text(
                                    //               'Chennai Super Kings are preparing to take on Gujarat Titans in the first match of the 16th edition of IPL.',
                                    //               textAlign: TextAlign.justify,
                                    //               style: TextStyle(
                                    //                 color: Colors.black,
                                    //                 fontSize: 20,
                                    //                 fontWeight: FontWeight.w800,
                                    //               ),
                                    //             ),
                                    //             SizedBox(
                                    //                 height: MediaQuery.of(context).size.height *
                                    //                     0.03),
                                    //             Text('By Malik Sheravat,on 4/2/2023')
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   margin: EdgeInsets.all(12),
                                    //   // color: Colors.green,
                                    // );
                                  },
                                ),
                        ),
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
            future: newsLetterGetData(),
          ));
    });
  }
}
