import 'package:united_natives/data/pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

typedef OnChangeString = void Function(String value);
String? verificationCode, smsCode;
int? resendingTokenID;
FirebaseAuth auth = FirebaseAuth.instance;

class CommonTextField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final TextStyle? style;
  final bool? isValidate;
  final bool? readOnly;
  final bool? isChange;
  final TextInputType? textInputType;
  final String? validationType;
  final String? regularExpression;
  final int? inputLength;
  final String? hintText;
  final String? validationMessage;
  final int? maxLine;
  final Widget? sIcon;
  final String? isBottomLabel;
  final bool? obscureValue;
  final OnChangeString? onChange;
  final Function? isBottomFunction;
  final TextEditingController? textEditingController;
  const CommonTextField(
      {super.key,
      this.labelText,
      this.isChange,
      this.isValidate,
      this.textInputType,
      this.validationType,
      this.regularExpression,
      this.inputLength,
      this.hintText,
      this.validationMessage,
      this.maxLine,
      this.sIcon,
      this.readOnly = false,
      this.onChange,
      this.initialValue,
      this.obscureValue,
      this.isBottomLabel,
      this.isBottomFunction,
      this.textEditingController,
      this.style});

  /// PLEASE IMPORT GETX PACKAGE
  static InputBorder outLineRed = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.red, width: 1.0),
  );
  static InputBorder outLineGrey = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.black38, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText == null || labelText!.isEmpty
              ? const SizedBox()
              : Text(
                  labelText ?? '',
                  // style: FontTextStyle.nunito600Black3dS14Style,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: Get.height * 0.022),
                ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: textEditingController,
            keyboardType: textInputType,
            maxLines: maxLine ?? 1,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [
              LengthLimitingTextInputFormatter(inputLength),
              FilteringTextInputFormatter.allow(RegExp(regularExpression!))
            ],
            obscureText: validationType! == 'password' ? obscureValue! : false,
            onChanged: onChange,
            readOnly: readOnly!,
            validator: (value) {
              print("isValidate  $value");

              return isValidate == true
                  ? value!.isEmpty
                      ? 'required...'
                      : null
                  : null;
            },
            style: TextStyle(fontSize: Get.height * 0.024),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hintText ?? '',

              contentPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              enabledBorder: outLineGrey,
              focusedErrorBorder: outLineRed,
              focusedBorder: outLineGrey,
              disabledBorder: outLineGrey,

              // fillColor: ColorPicker.greyF3,
              errorBorder: outLineGrey,
              filled: true,

              border: InputBorder.none,
              // this is new
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
