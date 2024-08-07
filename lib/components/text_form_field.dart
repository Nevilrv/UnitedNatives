import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintTextStyle;
  final bool obscureText;
  final bool enabled;
  final Widget suffixIcon;
  final bool suffixIconTap;
  final bool readOnly;
  final String error;
  final TextInputType keyboardType;
  final Function validator;
  final TextInputAction textInputAction;
  final Function onChanged;
  final Function onTap;
  final FocusNode focusNode;
  final int maxLines;
  final int minLines;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextFormField({
    Key key,
    this.controller,
    @required this.hintText,
    this.hintTextStyle,
    this.inputFormatters,
    this.keyboardType,
    this.obscureText,
    this.enabled,
    this.suffixIcon,
    this.suffixIconTap,
    this.readOnly,
    this.error,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText;
  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      autocorrect: false,
      inputFormatters: widget.inputFormatters,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText ?? false,
      controller: widget.controller,
      enabled: widget.enabled ?? true,
      readOnly: widget.readOnly ?? false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintTextStyle ??
            TextStyle(
              fontSize: 20,
              color: Color(0xffbcbcbc),
              fontFamily: 'NunitoSans',
            ),
        errorText: widget.error ?? null,
        suffixIcon: (widget.obscureText != null && widget.obscureText)
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    !_obscureText ? Icons.visibility : Icons.visibility_off,
                    size: 25,
                  ),
                ),
              )
            : widget.suffixIcon,
      ),
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).textTheme.subtitle1.color,
      ),
      cursorColor: kColorBlue,
      cursorWidth: 1,
      maxLines: widget.maxLines,
      validator: widget.validator,
    );
  }
}

/// OUTER-LINE

class CustomOuterLineTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintTextStyle;
  final bool enabled;
  final Widget suffixIcon;
  final bool suffixIconTap;
  final bool readOnly;
  final String error;
  final TextInputType keyboardType;
  final Function validator;
  final TextInputAction textInputAction;
  final Function onChanged;
  final Function onTap;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final int minLines;
  const CustomOuterLineTextFormField(
      {key,
      this.controller,
      this.inputFormatters,
      this.hintText,
      this.hintTextStyle,
      this.enabled,
      this.suffixIcon,
      this.suffixIconTap,
      this.readOnly,
      this.error,
      this.keyboardType,
      this.validator,
      this.textInputAction,
      this.onChanged,
      this.onTap,
      this.focusNode,
      this.maxLines,
      this.minLines});

  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      enableSuggestions: false,
      autocorrect: false,
      minLines: minLines,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: controller,
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(13),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: _isDark ? Colors.grey.shade600 : Colors.blueGrey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color:
                    _isDark ? Colors.grey.shade300 : Colors.blueGrey.shade700)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color:
                    _isDark ? Colors.grey.shade300 : Colors.blueGrey.shade700)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red)),
        hintText: hintText,
        hintStyle: hintTextStyle ??
            TextStyle(
              fontSize: 19.5,
              color: _isDark ? Colors.grey.shade600 : Colors.blueGrey.shade400,
              fontFamily: 'NunitoSans',
            ),
        errorText: error ?? null,
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(
        fontSize: 19.5,
        color: Theme.of(context).textTheme.subtitle1.color,
        fontFamily: 'NunitoSans',
      ),
      cursorColor: kColorBlue,
      cursorWidth: 1,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
