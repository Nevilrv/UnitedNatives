import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sizeConfig.dart';

class ActionButton extends StatelessWidget {
  final Function() onDecinePressed;
  const ActionButton({
    super.key,
    required this.onDecinePressed,
  });

  void _launchCaller(int number) async {
    var url = "tel:${number.toString()}";
    if (await canLaunchUrl(Uri.parse(url))) {
      // await launch(url);
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not place call';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22, bottom: 8),
      child: SizedBox(
        height: SizeConfig.safeBlockVertical * 10,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: SizedBox(
                height: SizeConfig.safeBlockVertical * 6.6,
                child: MaterialButton(
                  disabledElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text(
                    'Call',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 6,
                    ),
                  ),
                  onPressed: () async {
                    _launchCaller(15204454661);
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: SizeConfig.safeBlockVertical * 6.6,
                child: MaterialButton(
                    disabledElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    textColor: Colors.black26,
                    color: const Color(0xffEBEFFB),
                    onPressed: onDecinePressed,
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        color: const Color(0xff878FA6),
                        fontSize: SizeConfig.safeBlockHorizontal * 6,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
