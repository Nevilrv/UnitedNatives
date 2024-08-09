import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:united_natives/medicle_center/lib/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSwipe extends StatelessWidget {
  final double? height;
  final List<String>? images;

  const HomeSwipe({
    super.key,
    this.images,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (images != null) {
      return Stack(
        children: [
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                imageUrl: images![index],
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      color: Colors.white,
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      color: Colors.white,
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              );
            },
            autoplayDelay: 3000,
            autoplayDisableOnInteraction: false,
            autoplay: true,
            itemCount: images!.length,
            pagination: const SwiperPagination(
              alignment: Alignment(
                0.0,
                0.5,
              ),
              builder: SwiperPagination.dots,
            ),
          ),
          Positioned(
            top: 0,
            // top: 30,
            left: 20,

            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(
                    0.3,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    log('tap............');
                    // Get.to(Home());
                    Get.back();
                  },
                ),
              ),
            ),

            // child: GestureDetector(
            //   onTap: () {
            //     log('tap....');
            //     // Get.to(Home());
            //     Get.back();
            //   },
            //   child: CircleAvatar(
            //     backgroundColor: Colors.black26,
            //     child: Icon(
            //       Icons.arrow_back_sharp,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          )
        ],
      );
    }

    ///Loading
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: AppPlaceholder(
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          color: Colors.white,
        ),
      ),
    );
  }
}
