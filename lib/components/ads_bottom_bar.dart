import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsBottomBar extends StatefulWidget {
  final BuildContext context;

  final AdsController ads;

  const AdsBottomBar(
      {key,  this.ads, this.context});

  @override
  State<AdsBottomBar> createState() => _AdsBottomBarState();
}

class _AdsBottomBarState extends State<AdsBottomBar> {
  @override
  Widget build(BuildContext context) {

    int randomAd = Random().nextInt(tempList.length == 0 ? 1 : tempList.length) ?? 0;


    final h = MediaQuery.of(widget.context).size.height;
    final w = MediaQuery.of(widget.context).size.width;
    return tempList.isEmpty || widget.ads.adShow == false
        ? SizedBox()
        : Container(
            height: h * 0.1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () async {
                      print('data');

                      await launchUrl(
                        Uri.parse(
                            '${tempList[randomAd]['url'] ?? tempList[0]['url']}'),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          '${tempList[randomAd]['image_url'] ?? tempList[0]['image_url']}',
                      fit: BoxFit.fill,
                      height: h * 0.1,
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: h * 0.15,
                            width: w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () {
                      widget.ads.adShow = false;
                      setState(() {});
                      widget.ads.timer();
                    },
                    icon: CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.grey.shade700,
                      child: Icon(Icons.clear),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
