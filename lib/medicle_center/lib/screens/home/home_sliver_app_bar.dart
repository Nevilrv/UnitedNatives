import 'package:doctor_appointment_booking/medicle_center/lib/screens/home/home_swiper.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/screens/home/search_bar.dart';
import 'package:flutter/material.dart';

class AppBarHomeSliver extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<String> banners;
  final VoidCallback onSearch;
  final VoidCallback onScan;
  final VoidCallback onFilter;

  AppBarHomeSliver({
    this.expandedHeight,
    this.onSearch,
    this.onScan,
    this.onFilter,
    this.banners,
  });

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        HomeSwipe(
          images: banners,
          height: expandedHeight,
        ),
        Container(
          height: 32,
          color: Theme.of(context).backgroundColor,
        ),
        SearchBar(
          onSearch: onSearch,
          onScan: onScan,
          onFilter: onFilter,
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
