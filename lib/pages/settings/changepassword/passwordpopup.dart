import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'signin_button.dart';
import 'teddy_controller.dart';
import 'tracking_input.dart';

class PasswordPopup extends StatefulWidget {
  PasswordPopup({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PasswordPopupState createState() => _PasswordPopupState();
}

class _PasswordPopupState extends State<PasswordPopup> {
  TeddyController _teddyController;
  @override
  initState() {
    _teddyController = TeddyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Container(
        child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 200,
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: FlareActor(
                          "assets/images/settings.gif",
                          shouldClip: true,
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          controller: _teddyController,
                        )),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TrackingTextInput(
                                  label: "New Password",
                                  hint: "Type a New Password",
                                  onCaretMoved: (Offset caret) {
                                    _teddyController.lookAt(caret);
                                  }),
                              TrackingTextInput(
                                label: "Confirm Password",
                                hint: "Type a New Password",
                                isObscured: true,
                                onCaretMoved: (Offset caret) {
                                  _teddyController.coverEyes(caret != null);
                                  _teddyController.lookAt(null);
                                },
                                onTextChanged: (String value) {
                                  _teddyController.setPassword(value);
                                },
                              ),
                              SigninButton(
                                  child: Text("Okay",
                                      style: TextStyle(
                                          fontFamily: "RobotoMedium",
                                          fontSize: 18,
                                          color: Colors.white)),
                                  onPressed: () {
                                    _teddyController.submitPassword();
                                  })
                            ],
                          )),
                        )),
                  ])),
        ),
      ],
    ));
  }
}
