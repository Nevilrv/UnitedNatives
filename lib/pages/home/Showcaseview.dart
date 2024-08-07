// import 'package:bubble_showcase/bubble_showcase.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speech_bubble/speech_bubble.dart';
//
// import 'home.dart';
//
//
//
//
// class BubbleShowcaseDemoWidget extends StatelessWidget {
//   static const PREFERENCES_IS_FIRST_LAUNCH_STRING = "PREFERENCES_IS_FIRST_LAUNCH_STRING";
//   /// The title text global key.
//   final GlobalKey _titleKey = GlobalKey();
//
//   /// The first button global key.
//   final GlobalKey _firstButtonKey = GlobalKey();
//
//   final GlobalKey _fourthButtonKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = Theme.of(context).textTheme.body1.copyWith(
//       color: Colors.white,
//     );
//     return BubbleShowcase(
//       bubbleShowcaseId: 'my_bubble_showcase',
//       bubbleShowcaseVersion: 2,
//       bubbleSlides: [
//         _firstSlide(textStyle),
//         _thirdSlide(textStyle),
//       ],
//       child: _BubbleShowcaseDemoChild(_titleKey, _firstButtonKey, ),
//     );
//   }
//
//   /// Creates the first slide.
//   BubbleSlide _firstSlide(TextStyle textStyle) => RelativeBubbleSlide(
//     widgetKey: _titleKey,
//     child: RelativeBubbleSlideChild(
//       widget: Padding(
//         padding: const EdgeInsets.only(top: 8),
//         child: SpeechBubble(
//           nipLocation: NipLocation.TOP,
//           color: Colors.blue,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'There is Your History / Past Appoinments',
//                   style: textStyle.copyWith(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '',
//                   style: textStyle,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
//
//
//   /// Creates the second slide.
//
//
//   /// Creates the third slide.
//   BubbleSlide _thirdSlide(TextStyle textStyle) => RelativeBubbleSlide(
//     widgetKey: _firstButtonKey,
//     shape: const Oval(
//       spreadRadius: 15,
//     ),
//     child: RelativeBubbleSlideChild(
//       widget: Padding(
//         padding: const EdgeInsets.only(top: 23),
//         child: SpeechBubble(
//           nipLocation: NipLocation.TOP,
//           color: Colors.purple,
//
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 5),
//                   child: Icon(
//                     Icons.info_outline,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     'As said, this button is new.\nOh, and this one is oval by the way.',
//                     style: textStyle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// /// The main demo widget child.
// class _BubbleShowcaseDemoChild extends StatelessWidget {
//   /// The title text global key.
//   final GlobalKey _titleKey;
//
//   /// The first button global key.
//   final GlobalKey _firstButtonKey;
//
//
//   /// Creates a new bubble showcase demo child instance.
//   _BubbleShowcaseDemoChild(this._titleKey, this._firstButtonKey,);
//   final bool _noAppoints = false;
//
//   @override
//   Widget build(BuildContext context) {
//     print('Enter home page');
//     return Scaffold(
//       body: Home(),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
// // Future<bool> _BubbleShowcaseDemoWidget() async{
// //   final sharedPreferences = await SharedPreferences.getInstance();
// //   bool isFirstLaunch = sharedPreferences.getBool(BubbleShowcaseDemoWidget.PREFERENCES_IS_FIRST_LAUNCH_STRING) ?? true;
// //
// //   if(isFirstLaunch)
// //     sharedPreferences.setBool(BubbleShowcaseDemoWidget.PREFERENCES_IS_FIRST_LAUNCH_STRING, false);
// //
// //   return isFirstLaunch;
// // }
