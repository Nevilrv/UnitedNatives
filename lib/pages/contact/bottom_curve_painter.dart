import 'package:united_natives/utils/constants.dart';
import 'package:flutter/material.dart';

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    path.moveTo(0.0, size.height / 1.75);

    var firstControlPoint = Offset(10, size.height * .95);
    var firstEndPoint = Offset(size.width / 2, size.height * .95);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 1.25, size.height * .95);
    var secondEndPoint = Offset(size.width - 20, size.height);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();

    paint.color = kColorPrimary;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0.0, size.height / 1.75);

    var firstControlPoint = Offset(10, size.height * .95);
    var firstEndPoint = Offset(size.width / 2, size.height * .95);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 1.25, size.height * .95);
    var secondEndPoint = Offset(size.width - 20, size.height);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
