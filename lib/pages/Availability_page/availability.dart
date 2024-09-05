import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/Availability_page/select_multiple_availability.dart';
import 'package:united_natives/pages/Availability_page/update_availability.dart';
import '../../viewModel/ads_controller.dart';
import '../../utils/constants.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  static const _kTabTextStyle = TextStyle(
    color: kColorPrimaryDark,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  AdsController adsController = Get.find();
  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

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
            Translate.of(context)!.translate('availability_time_settings'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                indicatorColor: kColorPrimary,
                labelStyle: _kTabTextStyle,
                unselectedLabelStyle: _kUnselectedTabTextStyle,
                labelColor: kColorPrimary,
                unselectedLabelColor: Colors.grey,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  Tab(
                      text: Translate.of(context)
                          ?.translate('Update Availability')),
                  Tab(
                      text: Translate.of(context)
                          ?.translate('Update Multiple\nDay Availability')),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    UpdateAvailability(),
                    SelectMultipleAvailability(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
