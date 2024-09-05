import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/pages/Blogpage/Participate_catagory.dart';
import 'package:united_natives/utils/utils.dart';
import '../../utils/constants.dart';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  String? email, password, authPIN, webViewUrl, secretPin;
  @override
  void initState() {
    email = Config.getEmail();
    password = Config.getPassword();
    authPIN = Prefs.getString(Prefs.BEARER);
    secretPin = Prefs.getString(Prefs.SecretPin);
    webViewUrl =
        "${Constants.webUrl}?userEmail=$email&userPassword=$password&securePinInp=$secretPin";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Survey'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewLoad(url: webViewUrl.toString()),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                    bottom: Get.height * 0.012,
                    top: Get.height * 0.01,
                    right: Get.width * 0.03,
                    left: Get.width * 0.03),
                height: Get.height * 0.2,
                child: mentalHealthSurvey(context),
              ),
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewLoad(url: webViewUrl.toString()),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Get.height * 0.012,
                  top: Get.height * 0.01,
                  right: Get.width * 0.03,
                  left: Get.width * 0.03,
                ),
                height: Get.height * 0.2,
                child: healthBehaviorsSurvey(context),
              ),
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewLoad(url: webViewUrl.toString()),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Get.height * 0.012,
                  top: Get.height * 0.01,
                  right: Get.width * 0.03,
                  left: Get.width * 0.03,
                ),
                height: Get.height * 0.2,
                child: sexualViolenceSurvey(context),
              ),
            ),
          ],
        )));
  }

  Stack mentalHealthSurvey(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJUHNY8udnX0Rb5RUn9a3IVLHm1yGY4UQHBw&usqp=CAU',
            imageBuilder: (context, imageProvider) => Container(
              // width: 420.0,
              // height: 400.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                // Center(child: CircularProgressIndicator()),
                Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        /*Container(
          height: Get.height,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),*/
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'mental health survey',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: Get.width * 0.11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  Stack healthBehaviorsSurvey(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbwYQrWi7g-vDKZQpeVVePL9WKSRRds9WUBA&usqp=CAU',
            imageBuilder: (context, imageProvider) => Container(
              // width: 420.0,
              // height: 400.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                // Center(child: CircularProgressIndicator()),
                Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          height: Get.height,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'health behaviors survey',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: Get.width * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  Stack sexualViolenceSurvey(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPBQeTza4XPSPLcbYhjHd3hHmCIfbwCtQ6cg&usqp=CAU',
            imageBuilder: (context, imageProvider) => Container(
              // width: 420.0,
              // height: 400.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                // Center(child: CircularProgressIndicator()),
                Center(
              child: Utils.circular(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          height: Get.height,
          decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'sexual violence survey',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: Get.width * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
