import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import '../../components/custom_profile_item.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with AutomaticKeepAliveClientMixin<TestPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomProfileItem(
              onTap: () {},
              title:
                  Translate.of(context).translate('monthly_medical_check_up'),
              subTitle: '01/02/2019',
              buttonTitle: Translate.of(context).translate('see_reports'),
              imagePath: 'assets/images/icon_medical_check_up.png',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomProfileItem(
              onTap: () {},
              title:
                  Translate.of(context).translate('monthly_medical_check_up'),
              subTitle: '01/01/2019',
              buttonTitle: Translate.of(context).translate('see_reports'),
              imagePath: 'assets/images/icon_medical_check_up.png',
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
