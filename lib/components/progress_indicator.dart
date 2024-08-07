import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ProgressBar {
//   OverlayEntry _progressOverlayEntry;
//
//   void show(BuildContext context) {
//
//     print("Context ====> $context");
//     _progressOverlayEntry = _createdProgressEntry(context);
//     Overlay.of(context).insert(_progressOverlayEntry);
//   }
//
//   void hide() {
//     if (_progressOverlayEntry != null) {
//       _progressOverlayEntry.remove();
//       _progressOverlayEntry = null;
//     }
//   }
//
//   OverlayEntry _createdProgressEntry(BuildContext context) => OverlayEntry(
//         builder: (BuildContext context) => Stack(
//           children: <Widget>[
//             Container(
//               color: Colors.black45.withOpacity(0.5),
//             ),
//             Center(
//               child: CircularProgressIndicator(
//                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           ],
//         ),
//       );
//
//   double screenHeight(BuildContext context) =>
//       MediaQuery.of(context).size.height;
//
//   double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
// }

class ProgressIndicatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Utils.circular(),
      ),
    );
  }
}
