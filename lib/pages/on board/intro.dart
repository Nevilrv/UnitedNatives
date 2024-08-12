import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:united_natives/pages/login/login_page_auth.dart';
import 'package:united_natives/utils/constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPageA()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/images/$assetName', width: 350.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 21.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              title: "Search a Medical Center near you",
              body:
                  "Search more than 15,000 clinics to find the best Medical Center near you",
              image: _buildImage('on_boarding_image_1.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Self Monitor Your Health",
              body:
                  "Self-monitoring is a personality trait that captures differences in the extent to which people control the image they present to others in social situations",
              image: _buildImage('on_boarding_image_2.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Find the Right Provider",
              body:
                  "Find the right doctor, right now with UNH. Read reviews from verified clients and book an appointment with a nearby, in-network doctor",
              image: _buildImage('on_boarding_image_3.png'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipOrBackFlex: 0,

          nextFlex: 0,
          skip: Text(
            'Skip',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: kColorBlue),
          ),
          next: Icon(
            Icons.arrow_forward,
            size: Theme.of(context).textTheme.headlineSmall?.fontSize,
          ),
          done: Text('Done',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: kColorBlue)),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        );
      },
    );
  }
}
