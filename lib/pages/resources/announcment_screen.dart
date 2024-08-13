import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AnnoucMentScreen extends StatefulWidget {
  const AnnoucMentScreen({super.key});

  @override
  State<AnnoucMentScreen> createState() => _AnnoucMentScreenState();
}

var tempData = [];

class _AnnoucMentScreenState extends State<AnnoucMentScreen> {
  Future announce() async {
    http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Constants.allAnnouncement),
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
          backgroundColor: Colors.white,
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Announcement',
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
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'Earlier This Year',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${snapshot.data['data'][0]['image_url']}',
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
                        ),
                        const SizedBox(height: 20),
                        snapshot.data['data'].isEmpty
                            ? const Center(
                                child: Text(
                                  'NO DATA FOUND',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 21),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    (snapshot.data['data'] as List).length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Builder(builder: (context) {
                                            var document = parse(
                                                snapshot.data['data'][index]
                                                    ['content']);
                                            return Text(document.body!.text);
                                          }),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                    DateTime.parse(snapshot
                                                            .data['data'][index]
                                                        ['created_at'])),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${snapshot.data['data'][index]['author']}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  // return  Container(
                                  //         // height: 150,
                                  //         width: MediaQuery.of(context).size.width,
                                  //         decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(10),
                                  //             // color: Color(0xff2e83f8),
                                  //             color: Colors.white,
                                  //             boxShadow: [
                                  //               BoxShadow(
                                  //                   color: Color(0xffe8e8e8),
                                  //                   blurRadius: 5.0,
                                  //                   offset: Offset(0, 5)),
                                  //               BoxShadow(
                                  //                   color: Colors.white,
                                  //                   offset: Offset(-5, 0)),
                                  //               BoxShadow(
                                  //                   color: Colors.white,
                                  //                   offset: Offset(5, 0)),
                                  //             ]),
                                  //         margin: EdgeInsets.symmetric(
                                  //             horizontal: 10, vertical: 8),
                                  //         padding: EdgeInsets.symmetric(horizontal: 10),
                                  //         child: Flexible(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 15, vertical: 20),
                                  //             child: Column(
                                  //               children: [
                                  //                 Text(
                                  //                   'IPL 2023: Chennai Super Kings are preparing to take on Gujarat Titans in the first match of the 16th edition of IPL. The match will be played at the Narendra Modi Stadium, Ahmedabad. ',
                                  //                   textAlign: TextAlign.justify,
                                  //                   style: TextStyle(
                                  //                     color: Colors.black,
                                  //                     fontSize: 17,
                                  //                     fontWeight: FontWeight.w600,
                                  //                   ),
                                  //                 ),
                                  //                 SizedBox(height: 15),
                                  //                 Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment.spaceBetween,
                                  //                   children: [
                                  //                     Text(
                                  //                       '24-Apr-2012',
                                  //                       style: TextStyle(
                                  //                         color: Colors.grey,
                                  //                         fontSize: 17,
                                  //                         fontWeight: FontWeight.w600,
                                  //                       ),
                                  //                     ),
                                  //                     Text(
                                  //                       'img.jpg',
                                  //                       style: TextStyle(
                                  //                         color: Colors.grey,
                                  //                         fontSize: 17,
                                  //                         fontWeight: FontWeight.w600,
                                  //                       ),
                                  //                     ),
                                  //                     Text(
                                  //                       'Vikas Sharma',
                                  //                       style: TextStyle(
                                  //                         color: Colors.grey,
                                  //                         fontSize: 17,
                                  //                         fontWeight: FontWeight.w600,
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                },
                              ),
                        // SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        //   child: Text(
                        //     'Earlier This Year',
                        //     style: TextStyle(
                        //       color: Colors.grey,
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w800,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   itemCount: 3,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return Container(
                        //       // height: 150,
                        //       width: MediaQuery.of(context).size.width,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           // color: Color(0xff2e83f8),
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //                 color: Color(0xffe8e8e8),
                        //                 blurRadius: 5.0,
                        //                 offset: Offset(0, 5)),
                        //             BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                        //             BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                        //           ]),
                        //       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        //       padding: EdgeInsets.symmetric(horizontal: 10),
                        //       child: Flexible(
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 15, vertical: 20),
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 'IPL 2023: Chennai Super Kings are preparing to take on Gujarat Titans in the first match of the 16th edition of IPL. The match will be played at the Narendra Modi Stadium, Ahmedabad. ',
                        //                 textAlign: TextAlign.justify,
                        //                 style: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 17,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //               SizedBox(height: 15),
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   Text(
                        //                     '24-Apr-2012',
                        //                     style: TextStyle(
                        //                       color: Colors.grey,
                        //                       fontSize: 17,
                        //                       fontWeight: FontWeight.w600,
                        //                     ),
                        //                   ),
                        //                   Text(
                        //                     'img.jpg',
                        //                     style: TextStyle(
                        //                       color: Colors.grey,
                        //                       fontSize: 17,
                        //                       fontWeight: FontWeight.w600,
                        //                     ),
                        //                   ),
                        //                   Text(
                        //                     'Vikas Sharma',
                        //                     style: TextStyle(
                        //                       color: Colors.grey,
                        //                       fontSize: 17,
                        //                       fontWeight: FontWeight.w600,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
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
            future: announce(),
          ));
    });
  }
}
