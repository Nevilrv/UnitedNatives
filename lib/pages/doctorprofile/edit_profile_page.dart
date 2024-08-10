import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'widgets/edit_widget.dart';

class DocEditProfilePage extends StatefulWidget {
  const DocEditProfilePage({super.key});

  @override
  State<DocEditProfilePage> createState() => _DocEditProfilePageState();
}

class _DocEditProfilePageState extends State<DocEditProfilePage> {
  final UserUpdateController _userUpdateController =
      Get.put<UserUpdateController>(UserUpdateController());

  AdsController adsController = Get.find();
  @override
  void initState() {
    _userUpdateController.onInitPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
      builder: (ads) {
        return Scaffold(
          bottomNavigationBar: AdsBottomBar(
            ads: ads,
            context: context,
          ),
          appBar: AppBar(
            title: Text(
              Translate.of(context)!.translate('edit_profile'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          body: const Column(
            children: <Widget>[
              Expanded(
                child: DocEditWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// OLD CODE

/*import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../utils/constants.dart';
import 'widgets/edit_widget.dart';
import 'widgets/info_widget.dart';


class DocEditProfilePage extends StatefulWidget {
  @override
  State<DocEditProfilePage> createState() => _DocEditProfilePageState();
}

class _DocEditProfilePageState extends State<DocEditProfilePage> {
  final UserUpdateController _userUpdateController =
  Get.put<UserUpdateController>(UserUpdateController());

  AdsController adsController = Get.find();
  @override
  void initState() {
    _userUpdateController.onInitPage();
    super.initState();
  }

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
            Translate.of(context).translate('edit_profile'),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 24),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _userUpdateController.editProfile,
              icon: Obx(
                    () => Icon(
                    _userUpdateController.editProfileFlag.value
                        ? Icons.close
                        : Icons.edit,
                    color: kColorBlue),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                    () => SingleChildScrollView(
                  controller: _userUpdateController.dScrollController,
                  child: _userUpdateController.editProfileFlag.value
                      ? DocEditWidget()
                      : DocInfoWidget(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}*/
