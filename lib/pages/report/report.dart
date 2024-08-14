import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/utils/constants.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ContactState();
}

class _ContactState extends State<Report> {
  List<String> attachment = <String>[];
  final UserController userController = Get.find();
  final TextEditingController _subjectController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: 'contact@sataware.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  final TextEditingController _bodyController = TextEditingController(text: '');
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> send() async {
    String url =
        '${Constants.baseUrl + Constants.patientContactForm}/${userController.user.value.id}';

    String url1 =
        '${Constants.baseUrl + Constants.doctorContactForm}/${userController.user.value.id}';
    Map<String, dynamic> body1 = {
      "name": _subjectController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "text": _bodyController.text
    };

    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };

    http.Response response1 = await http.post(
        Uri.parse(Prefs.getString(Prefs.USERTYPE) == '1' ? url : url1),
        body: jsonEncode(body1),
        headers: header1);
    var data = jsonDecode(response1.body);
    log('data==========>>>>>$data');

    if (Platform.isIOS) {
      final bool canSend = await FlutterMailer.canSendMail();
      if (!canSend) {
        const SnackBar snackBar =
            SnackBar(content: Text('no Email App Available'));

        ScaffoldMessenger.of(_scafoldKey.currentState!.context)
            .showSnackBar(snackBar);

        return;
      }
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    final MailOptions mailOptions = MailOptions(
      body:
          "Contact Number : ${_phoneController.text}\n${_bodyController.text}",
      subject: _subjectController.text,
      recipients: <String>['satawaretechnologies@gmail.com'],
      isHTML: true,
      ccRecipients: <String>['satawaretechnologies@gmail.com'],
      attachments: attachment,
    );

    String platformResponse;

    try {
      await FlutterMailer.send(mailOptions);
      platformResponse = 'success';
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      if (!mounted) {
        return;
      }
      await showDialog<void>(
          context: _scafoldKey.currentContext!,
          builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Message c',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(error.message!),
                  ],
                ),
                contentPadding: const EdgeInsets.all(26),
                title: Text(error.code),
              ));
    } catch (error) {
      platformResponse = error.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(_scafoldKey.currentState!.context)
        .showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));

    _subjectController.clear();
    _phoneController.clear();
    _bodyController.clear();
  }

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Widget imagePath =
        Column(children: attachment.map((String file) => Text(file)).toList());

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        key: _scafoldKey,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          title: Text(
            Translate.of(context)!.translate('Report a Problem'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // new AppBar(surfaceTintColor: Colors.transparent,
        //   backgroundColor: Theme.of(context).hintColor,
        //   title: const Text(
        //     'Contact Us',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 24,
        //     ),
        //   ),
        //   actions: <Widget>[
        //     /* IconButton(
        //         onPressed: send,
        //         icon: const Icon(Icons.send),
        //       color: Colors.white,)*/
        //   ],
        // ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       right: 10, left: 10, top: 10, bottom: 7),
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     controller: _emailController,
                        //     decoration: InputDecoration(
                        //       fillColor: _isDark
                        //           ? Colors.white.withOpacity(0.4)
                        //           : Colors.grey.withOpacity(0.1),
                        //       border: InputBorder.none,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(8.0)),
                        //         borderSide:
                        //             BorderSide(color: Colors.grey.shade400),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(8.0)),
                        //         borderSide: BorderSide(
                        //             color: _isDark
                        //                 ? Colors.white
                        //                 : Colors.grey.shade800),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(8.0)),
                        //         borderSide: BorderSide(
                        //             color: _isDark ? Colors.red : Colors.red),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(8.0)),
                        //         borderSide: BorderSide(
                        //             color: _isDark
                        //                 ? Colors.white
                        //                 : Colors.grey.shade800),
                        //       ),
                        //       filled: true,
                        //       contentPadding: EdgeInsets.all(15.0),
                        //       hintText: 'contact@sataware.com',
                        //       hintStyle: TextStyle(
                        //           color: _isDark ? Colors.white : Colors.black),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          child: buildTextFormField(
                            digitCount: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            hintText: 'Enter your contact number',
                            controller: _phoneController,
                            textInputType: TextInputType.phone,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: buildTextFormField(
                              hintText: 'Enter subject',
                              controller: _subjectController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'This field is required';
                                } else {
                                  return null;
                                }
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          child: buildTextFormField(
                            hintText: 'Enter description',
                            min: 8,
                            max: 15,
                            controller: _bodyController,
                            textInputType: TextInputType.text,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 8),
                          child: CustomButton(
                              textSize: 22,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  send();
                                }
                              },
                              text: 'Submit'),
                        ),
                        imagePath,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  TextFormField buildTextFormField(
      {validator,
      TextInputType? textInputType,
      TextEditingController? controller,
      int? min,
      int? max,
      String? hintText,
      List<TextInputFormatter>? digitCount}) {
    return TextFormField(
      validator: validator,
      textInputAction: TextInputAction.done,
      inputFormatters: digitCount,
      keyboardType: textInputType,
      controller: controller,
      minLines: min,
      maxLines: max,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        fillColor: _isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),

        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide:
              BorderSide(color: _isDark ? Colors.white : Colors.grey.shade800),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: _isDark ? Colors.red : Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide:
              BorderSide(color: _isDark ? Colors.white : Colors.grey.shade800),
        ),
        filled: true,
        contentPadding: const EdgeInsets.only(
            top: 15.0, left: 15.0, right: 15.0, bottom: 15),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),

        // labelText: 'Text',
        // labelStyle:
        //     TextStyle(color: Colors.black, fontSize: 20),
        alignLabelWithHint: true,
      ),
    );
  }

  // ImagePicker imagePicker = ImagePicker();
  // void _picker() async {
  //   final pick = await imagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     attachment.add(pick!.path);
  //   });
  // }
  //
  // /// create a text file in Temporary Directory to share.
  // void _onCreateFile(BuildContext context) async {
  //   final TempFile tempFile =  _showDialog(context);
  //   final File newFile = await writeFile(tempFile.content, tempFile.name);
  //   setState(() {
  //     attachment.add(newFile.path);
  //   });
  // }

  // /// some A simple dialog and return fileName and content
  // Future<TempFile?> _showDialog(BuildContext context) {
  //   return showDialog<TempFile>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       String content = '';
  //       String fileName = '';
  //
  //       return SimpleDialog(
  //         title: const Text('write something to a file'),
  //         contentPadding: const EdgeInsets.all(8.0),
  //         children: <Widget>[
  //           TextField(
  //             onChanged: (String str) => fileName = str,
  //             autofocus: true,
  //             decoration: const InputDecoration(
  //                 suffix: Text('.txt'), labelText: 'file name'),
  //           ),
  //           TextField(
  //             decoration: const InputDecoration(
  //               floatingLabelBehavior: FloatingLabelBehavior.auto,
  //               labelText: 'Content',
  //             ),
  //             onChanged: (String str) => content = str,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: <Widget>[
  //               MaterialButton(
  //                 color: Theme.of(context).colorScheme.secondary,
  //                 child: const Icon(Icons.save),
  //                 onPressed: () {
  //                   final TempFile tempFile =
  //                       TempFile(content: content, name: fileName);
  //                   // Map.from({'content': content, 'fileName': fileName});
  //                   Navigator.of(context).pop<TempFile>(tempFile);
  //                 },
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<String> get _localPath async {
    final Directory directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final String path = await _localPath;
    return File('$path/$fileName.txt');
  }

  Future<File> writeFile(String text, [String fileName = '']) async {
    fileName = fileName.isNotEmpty ? fileName : 'fileName';
    final File file = await _localFile(fileName);

    // Write the file
    return file.writeAsString(text);
  }
}

class TempFile {
  TempFile({required this.name, required this.content});
  final String name, content;
}
