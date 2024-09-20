import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/custom_button.dart';
import 'package:united_natives/components/text_form_field.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';

import '../../ResponseModel/user.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

enum Gender { male, female }

enum BestTutorSite { ihDoctor, otherDoctor }

bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

class DocSignupPage extends StatefulWidget {
  const DocSignupPage({super.key});

  @override
  State<DocSignupPage> createState() => _DocSignupPageState();
}

class _DocSignupPageState extends State<DocSignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();
  AdsController adsController = Get.find();

  final sController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _certificateController = TextEditingController();
  final _educationController = TextEditingController();
  final _providerTypeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _perAppointmentChargeController = TextEditingController(text: "0");
  final cityController = TextEditingController();
  final specialityController = TextEditingController();
  final tribalRecognizedYesController = TextEditingController();
  final tribalRecognizedNoController = TextEditingController();
  final docDigitController = TextEditingController();

  List categoryOfStates = [];
  List categoryOfCity = [];
  List categoryOfMedicalCenter = [];

  File? _image;
  ImagePicker imagePicker = ImagePicker();

  String? categoryOfCitiesDropDown;
  String? categoryOfMedicalCenterDropDown;
  String? categoryOfStatesDropDown;
  String? getIds1;
  String? getIds;
  String? getMedicalCenterID;
  String? doctorsTypes;
  String dropdownValue = 'Alabama';
  dynamic selector;

  bool dateValidate = true;
  bool stateValidate = true;
  bool cityValidate = true;
  bool specialityValidate = true;
  bool stateLoader = false;
  bool medicalCenterLoader = false;
  bool cityLoader = false;
  bool isDoctorVerify = false;

  @override
  void initState() {
    getSpecialityData();
    getStates();
    getMedicalCenter();
    super.initState();
  }

  getSpecialityData() {
    if (_userController.dropDownSpeciality.isEmpty) {
      _userController.getSpecialities();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _userController.onDispose();
    categoryOfStatesDropDown = null;
    categoryOfCitiesDropDown = null;
    categoryOfMedicalCenterDropDown = null;
    getIds1 = null;
    getIds = null;
    getMedicalCenterID = null;
    doctorsTypes = null;
    categoryOfStates = [];
    categoryOfCity = [];
    categoryOfMedicalCenter = [];
    sController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _contactController.clear();
    _certificateController.clear();
    _educationController.clear();
    _providerTypeController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _perAppointmentChargeController.clear();
    cityController.clear();
    specialityController.clear();
    tribalRecognizedYesController.clear();
    tribalRecognizedNoController.clear();
    docDigitController.clear();
    super.dispose();
  }

  Future getStates() async {
    setState(() {
      stateLoader = true;
    });

    http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Constants.getAllStates),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      setState(() {
        categoryOfStates = result;
        stateLoader = false;
      });
      return result;
    } else {
      setState(() {
        stateLoader = false;
      });
    }
  }

  Future<void> _getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: imageSource);

      if (pickedFile != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: "",
                showCropGrid: true,
                toolbarColor: _isDark ? Colors.grey.shade600 : Colors.white,
                hideBottomControls: true,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
                backgroundColor: Colors.black),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: "",
              aspectRatioLockEnabled: true,
            )
          ],
          aspectRatio: const CropAspectRatio(ratioX: 1.1, ratioY: 1.1),
        );
        if (croppedImage != null) {
          setState(() {
            final croppedFile = File(croppedImage.path);
            _image = croppedFile;
          });
        }
      }
    } catch (e) {
      log('e==========>>>>>$e');
    }
  }

  String? validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please Enter Mobile Number';
    } else if (value.length != 10) {
      return 'Mobile Number Should be 10 Digit';
    } else if (!regExp.hasMatch(value)) {
      return 'Please Enter Valid Mobile Number';
    }
    return null;
  }

  Future getImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future getCities({required String stateId}) async {
    setState(() {
      cityLoader = true;
    });
    http.Response response = await http.get(
      Uri.parse('${Constants.baseUrl + Constants.getAllCityByState}/$stateId'),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      setState(() {
        categoryOfCity = result;
        cityLoader = false;
      });
      return result;
    } else {
      setState(() {
        cityLoader = false;
      });
    }
  }

  Future getMedicalCenter({String? location}) async {
    setState(() {
      medicalCenterLoader = true;
    });

    String url;
    url = '${Constants.medicalCenterURL}listar/v1/active-centres';

    Map<String, String> header = {"Content-Type": "application/json"};

    http.Response response = await http.get(Uri.parse(url), headers: header);

    if (response.statusCode == 200) {
      if (response.body != "") {
        var result = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            categoryOfMedicalCenter = result['data']['locations'];
            if (categoryOfMedicalCenter.isNotEmpty) {
              for (var element in categoryOfMedicalCenter) {
                if (element['post_title'].toString().toLowerCase() ==
                    "united natives") {
                  getMedicalCenterID = element["ID"].toString();
                  categoryOfMedicalCenterDropDown = element['post_title'];
                }
              }
            }
            medicalCenterLoader = false;
          });
        }
        return result;
      }
    } else {
      setState(() {
        medicalCenterLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          Translate.of(context)!.translate('sign_up'),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _openBottomSheet(context);
                                    },
                                    child: _image != null
                                        ? Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.file(
                                                _image!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                            const Positioned.fill(
                                                child: Icon(Icons.camera_alt,
                                                    color: Colors.white)),
                                          ])
                                        : const CircleAvatar(
                                            radius: 50,
                                            child: Icon(Icons.camera_alt,
                                                size: 30, color: Colors.white),
                                          ),
                                  ),
                                ).paddingSymmetric(vertical: 30),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('first_name_dot')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _firstNameController,
                                    hintText: 'John',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Enter First Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('last_name_dot')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _lastNameController,
                                    hintText: 'Doe',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Enter Last Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('gender_dot')} *"),
                                  Obx(
                                    () => DropdownButtonFormField(
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color,
                                      ),
                                      focusNode: FocusNode(),
                                      validator: (value) => value == null
                                          ? 'Please Select Gender'
                                          : null,
                                      isExpanded: true,
                                      value: _userController
                                              .selectedGender.value.isEmpty
                                          ? null
                                          : _userController
                                              .selectedGender.value,
                                      hint: Text(
                                        Translate.of(context)!
                                            .translate('add_gender'),
                                        style: hintStyle,
                                      ),
                                      onChanged: _userController.onChangeGender,
                                      items: _userController.dropDownGender,
                                    ),
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('email_dot')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _emailController,
                                    hintText: 'contact@sataware.com',
                                    validator: (value) =>
                                        EmailValidator.validate(value!)
                                            ? null
                                            : "Please Enter a Valid Email.",
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Contact number')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    controller: _contactController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    validator: validateMobile,
                                    hintText: '+1 520 44 54 661',
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('date_of_birth_dot')} *"),
                                  _selectBirthDate(context),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('License No.')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _certificateController,
                                    hintText: 'DFGBV784959F0',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Please Enter License Number';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Per Appointment Charge')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: _perAppointmentChargeController,
                                    hintText: '\$100',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Please Enter Per Appointment Charge';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Speciality')} *"),
                                  _selectSpeciality(context, h),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Education')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _educationController,
                                    hintText: 'MBBS , MD',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Please Enter Your Education';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Provider Type')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _providerTypeController,
                                    hintText: 'Enter Provider Type',
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Enter Provider Type';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(Translate.of(context)!
                                      .translate('Racial/ethnic background *')),
                                  _racialEthnicBackground(context),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('password_dot')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.next,
                                    controller: _passwordController,
                                    hintText: '* * * * * *',
                                    obscureText: true,
                                    validator: (text) {
                                      if (text.toString().length < 8 ||
                                          text!.isEmpty) {
                                        return 'Password Should be Greater Than 8 Digit';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('confirm_password_dot')} *"),
                                  CustomTextFormField(
                                    focusNode: FocusNode(),
                                    textInputAction: TextInputAction.done,
                                    controller: _confirmPasswordController,
                                    hintText: '* * * * * *',
                                    obscureText: true,
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'Enter Confirm Password';
                                      } else if (_passwordController.text !=
                                          _confirmPasswordController.text) {
                                        return 'Confirm Password Does Not Match';
                                      }
                                      return null;
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('State')} *"),
                                  dropDownView(
                                    category: 's',
                                    colorCon: categoryOfStates == [] ||
                                        categoryOfStates.isEmpty,
                                    textStyleCon:
                                        categoryOfStatesDropDown == null,
                                    text: categoryOfStatesDropDown != null
                                        ? '$categoryOfStatesDropDown'
                                        : 'Select State',
                                    onTap: () {
                                      if (categoryOfStates.isNotEmpty) {
                                        stateCityDropDown(
                                            category: 's', h: h, w: w);
                                      }
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('city')} *"),
                                  dropDownView(
                                    category: 'c',
                                    colorCon: categoryOfCity == [] ||
                                        categoryOfCity.isEmpty,
                                    textStyleCon:
                                        categoryOfCitiesDropDown == null,
                                    text: categoryOfCitiesDropDown != null
                                        ? '$categoryOfCitiesDropDown'
                                        : 'Select City',
                                    onTap: () {
                                      if (categoryOfCity.isNotEmpty) {
                                        stateCityDropDown(
                                            category: 'c', h: h, w: w);
                                      }
                                    },
                                  ),
                                  _labelWidget(
                                      "${Translate.of(context)!.translate('Medical Center')} *"),
                                  dropDownView(
                                    category: 'm',
                                    colorCon: categoryOfMedicalCenter == [] ||
                                        categoryOfMedicalCenter.isEmpty,
                                    textStyleCon:
                                        categoryOfMedicalCenterDropDown == null,
                                    text:
                                        categoryOfMedicalCenterDropDown != null
                                            ? '$categoryOfMedicalCenterDropDown'
                                            : 'Select Medical Center',
                                    onTap: () {
                                      if (categoryOfMedicalCenter.isNotEmpty) {
                                        stateCityDropDown(
                                            category: 'm', h: h, w: w);
                                      }
                                    },
                                  ),
                                  _signUpButton(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${Translate.of(context)!.translate('Already a Provider')} ?',
                                style: const TextStyle(
                                    color: Color(0xffbcbcbc),
                                    fontSize: 20,
                                    fontFamily: 'NunitoSans'),
                              ),
                              const Text('  '),
                              InkWell(
                                borderRadius: BorderRadius.circular(2),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    Translate.of(context)!.translate('login'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ).paddingOnly(top: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  _labelWidget(String text) {
    return Text(
      text,
      style: kInputTextStyle,
    ).paddingOnly(top: 18);
  }

  /// SELECT BIRTH DATE

  _selectBirthDate(BuildContext context) {
    return Obx(
      () => ListTile(
        contentPadding: const EdgeInsets.all(0),
        // title: Text(_userController.dateOfBirth.value),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userController.dateOfBirth.value.isEmpty
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: !dateValidate
                                ? Colors.red.shade900
                                : Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tap to Select BirthDate",
                          style: hintStyle,
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      DateFormat('EEEE, dd MMMM, yyyy').format(
                        DateTime.parse(_userController.dateOfBirth.value),
                      ),
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                  ),
            dateValidate
                ? const SizedBox()
                : Text(
                    "Please Select Birthdate",
                    style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize),
                  ).paddingOnly(top: 6)
          ],
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((DateTime? value) {
            if (value != null) {
              _userController.onDateOfBirth(value.toString());
            }
          });
        },
      ),
    );
  }

  /// SELECT SPECIALITY

  _selectSpeciality(BuildContext context, double h) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              if (_userController.dropDownSpeciality.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PopScope(
                      canPop: false,
                      child: StatefulBuilder(
                        builder: (context, setState234) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: h * 0.6, maxWidth: 550),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: h * 0.015,
                                    left: h * 0.015,
                                    right: h * 0.005,
                                    bottom: 0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: _isDark
                                                    ? Colors.grey.shade800
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              height: 48,
                                              child: Center(
                                                child: TextField(
                                                  controller: sController,
                                                  onChanged: (value) {
                                                    setState234(() {});
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 16),
                                                          suffixIcon: Icon(
                                                              Icons.search),
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Search...'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              sController.clear();
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                              size: 25,
                                            ),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Builder(
                                          builder: (context) {
                                            int index = _userController
                                                .dropDownSpeciality
                                                .indexWhere((element) =>
                                                    element["speciality_name"]
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(sController
                                                            .text
                                                            .toString()
                                                            .toLowerCase()));
                                            if (index < 0) {
                                              return Center(
                                                child: Text(
                                                  'No Speciality !',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.color,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            }

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _userController
                                                  .dropDownSpeciality.length,
                                              itemBuilder: (context, index) {
                                                if (_userController
                                                    .dropDownSpeciality[index]
                                                        ['speciality_name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(sController.text
                                                        .toString()
                                                        .toLowerCase())) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        title: Text(
                                                          _userController
                                                              .dropDownSpeciality[
                                                                  index][
                                                                  'speciality_name']
                                                              .toString()
                                                              .trim(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.color,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);

                                                          _userController
                                                              .onChangeSpeciality(
                                                            _userController
                                                                .dropDownSpeciality[
                                                                    index][
                                                                    'speciality_name']
                                                                .toString()
                                                                .trim(),
                                                          );

                                                          sController.clear();
                                                        },
                                                      ),
                                                      Divider(
                                                        height: 0,
                                                        color: Colors
                                                            .grey.shade400,
                                                      ).paddingOnly(right: 6)
                                                    ],
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _userController.selectedSpeciality.value.isEmpty
                              ? "Select Speciality"
                              : _userController.selectedSpeciality.value,
                          overflow: TextOverflow.ellipsis,
                          style:
                              _userController.selectedSpeciality.value.isEmpty
                                  ? const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xffbcbcbc),
                                      fontFamily: 'NunitoSans',
                                    )
                                  : TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color,
                                    ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _isDark
                            ? _userController.dropDownSpeciality.isEmpty
                                ? Colors.grey.shade800
                                : Colors.grey.shade100
                            : _userController.dropDownSpeciality.isEmpty
                                ? Colors.grey
                                : Colors.grey.shade800,
                      )
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 1,
                      width: double.infinity,
                      color: !specialityValidate
                          ? Colors.red.shade900
                          : Colors.grey.shade500),
                  specialityValidate
                      ? const SizedBox()
                      : Text(
                          "Please Select Speciality",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.fontSize),
                        ).paddingOnly(top: 6)
                ],
              ).paddingOnly(top: 12),
            ),
          ),
          if (_userController.selectedSpeciality.value == "Other") ...[
            Text(
              "${Translate.of(context)!.translate('Enter Speciality')} *",
              style: kInputTextStyle,
            ).paddingOnly(top: 18),
            CustomTextFormField(
              focusNode: FocusNode(),
              textInputAction: TextInputAction.next,
              controller: specialityController,
              hintText: 'Speciality',
              validator: (text) {
                if (text!.isEmpty) {
                  return 'Please Enter Your Speciality';
                }
                return null;
              },
            ),
          ]
        ],
      ),
    );
  }

  /// RACIAL/ETHNIC BACKGROUND

  _racialEthnicBackground(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            focusNode: FocusNode(),
            validator: (value) =>
                value == null ? 'Please select racial/ethnic background' : null,
            isExpanded: true,
            value: _userController.tribalBackgroundStatus.value.isEmpty
                ? null
                : _userController.tribalBackgroundStatus.value,
            hint: Text(
                Translate.of(context)!
                    .translate('Select racial/ethnic background'),
                style: hintStyle),
            onChanged: _userController.onChangeTribalBackgroundStatus,
            items: _userController.dropDownTribal3,
          ),
          if (_userController.tribalBackgroundStatus.value ==
                  "Native American" ||
              _userController.tribalBackgroundStatus.value == "Alaska Native")
            Column(
              children: [
                Text(
                  "${Translate.of(context)!.translate('Are you enrolled in a federally recognized tribe?')} *",
                  style: kInputTextStyle,
                ).paddingOnly(top: 18),
                DropdownButtonFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  focusNode: FocusNode(),
                  validator: (value) => value == null ? 'Please Select' : null,
                  isExpanded: true,
                  value: _userController.fedRecognizedTribe.value.isEmpty
                      ? null
                      : _userController.fedRecognizedTribe.value,
                  hint: Text(
                    Translate.of(context)!.translate(
                        'Select enrolled in a federally recognized tribe or not'),
                    style: hintStyle,
                  ),
                  onChanged: _userController.onChangeFedRecognizedTribe,
                  items: _userController.dropDownFedRecognizedTribe,
                ),
                if (_userController.fedRecognizedTribe.value == "Yes")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Translate.of(context)!.translate('What tribal affiliation are you enrolled in?')} *",
                        style: kInputTextStyle,
                      ).paddingOnly(top: 18),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        controller: tribalRecognizedYesController,
                        hintText: 'Enter...',
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter tribal affiliation are you enrolled in';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                if (_userController.fedRecognizedTribe.value == "No")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Translate.of(context)!.translate('What tribal descendency do you affiliate with?')} *",
                        style: kInputTextStyle,
                      ).paddingOnly(top: 18),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        textInputAction: TextInputAction.next,
                        controller: tribalRecognizedNoController,
                        hintText: 'Enter...',
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter tribal descendency do you affiliate with';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
              ],
            ),
        ],
      ),
    );
  }

  /// BOTTOM SHEET FOR SELECT IMAGES FROM

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  size: 20,
                ),
                title: Text(
                  Translate.of(context)!.translate('take_a_photo'),
                  style: const TextStyle(
                    color: Color(0xff4a4a4a),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  size: 20,
                ),
                title: Text(
                  Translate.of(context)!.translate('choose_a_photo'),
                  style: const TextStyle(
                    color: Color(0xff4a4a4a),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  /// STATE CITY MEDICAL CENTER DROP DOWN

  Widget dropDownView({
    required void Function() onTap,
    required String text,
    required String category,
    required bool textStyleCon,
    required bool colorCon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleCon
                        ? const TextStyle(
                            fontSize: 20,
                            color: Color(0xffbcbcbc),
                            fontFamily: 'NunitoSans',
                          )
                        : TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                  ).paddingOnly(top: 12),
                ),
                (category == 'm' && medicalCenterLoader == true) ||
                        (category == 'c' && cityLoader == true) ||
                        (category == 's' && stateLoader == true)
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                        ),
                      ).paddingOnly(right: 5)
                    : Icon(
                        Icons.arrow_drop_down,
                        color: _isDark
                            ? colorCon
                                ? Colors.grey.shade800
                                : Colors.grey.shade100
                            : colorCon
                                ? Colors.grey
                                : Colors.grey.shade800,
                      )
              ],
            ),
            Container(
                height: 1,
                margin: const EdgeInsets.only(top: 15),
                width: double.infinity,
                color: category == 's'
                    ? !stateValidate
                        ? Colors.red.shade900
                        : Colors.grey.shade500
                    : category == 'c'
                        ? !cityValidate
                            ? Colors.red.shade900
                            : Colors.grey.shade500
                        : Colors.grey.shade500),
            category == 's'
                ? stateValidate
                    ? const SizedBox()
                    : Text(
                        "Please Select State",
                        style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.fontSize),
                      ).paddingOnly(top: 6)
                : category == 'c'
                    ? cityValidate
                        ? const SizedBox()
                        : Text(
                            "Please Select City",
                            style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize),
                          ).paddingOnly(top: 6)
                    : const SizedBox()
          ],
        ),
      ),
    );
  }

  stateCityDropDown(
      {required double h, required double w, required String category}) async {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setState234) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: h * 0.6, maxWidth: 550),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDark ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: h * 0.015,
                        left: h * 0.015,
                        right: h * 0.005,
                        bottom: 0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isDark
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  height: 48,
                                  child: Center(
                                    child: TextField(
                                      controller: sController,
                                      onChanged: (value) {
                                        setState234(() {});
                                      },
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 10, left: 16),
                                          suffixIcon: Icon(Icons.search),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: 'Search...'),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (category == "s") {
                                    Navigator.pop(
                                        context, categoryOfStatesDropDown);
                                  } else if (category == 'c') {
                                    Navigator.pop(
                                        context, categoryOfCitiesDropDown);
                                  } else {
                                    Navigator.pop(context,
                                        categoryOfMedicalCenterDropDown);
                                  }

                                  sController.clear();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                int index = category == "s"
                                    ? categoryOfStates.indexWhere((element) =>
                                        element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase()))
                                    : category == 'c'
                                        ? categoryOfCity.indexWhere((element) =>
                                            element['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(sController.text
                                                    .toString()
                                                    .toLowerCase()))
                                        : categoryOfMedicalCenter.indexWhere(
                                            (element) => element['post_title']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    sController.text.toString().toLowerCase()));
                                if (index < 0) {
                                  return Center(
                                    child: Text(
                                      category == "s"
                                          ? 'No States !'
                                          : category == 'c'
                                              ? 'No City !'
                                              : 'No Medical Centers !',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: category == "s"
                                      ? categoryOfStates.length
                                      : category == 'c'
                                          ? categoryOfCity.length
                                          : categoryOfMedicalCenter.length,
                                  itemBuilder: (context, index) {
                                    if (category == "s"
                                        ? categoryOfStates[index]['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase())
                                        : category == 'c'
                                            ? categoryOfCity[index]['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(sController.text
                                                    .toString()
                                                    .toLowerCase())
                                            : categoryOfMedicalCenter[index]
                                                    ['post_title']
                                                .toString()
                                                .toLowerCase()
                                                .contains(sController.text
                                                    .toString()
                                                    .toLowerCase())) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              category == "s"
                                                  ? categoryOfStates[index]
                                                          ['name']
                                                      .toString()
                                                  : category == 'c'
                                                      ? categoryOfCity[index]
                                                              ['name']
                                                          .toString()
                                                      : categoryOfMedicalCenter[
                                                                  index]
                                                              ['post_title']
                                                          .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.color,
                                              ),
                                            ),
                                            onTap: () async {
                                              if (category == "s") {
                                                Navigator.pop(
                                                    context,
                                                    categoryOfStates[index]
                                                            ['name']
                                                        .toString());

                                                getIds = categoryOfStates[index]
                                                    ['id'];

                                                getIds1 = null;
                                                categoryOfCitiesDropDown = null;
                                                categoryOfCity = [];
                                                getCities(
                                                    stateId: getIds ?? "");
                                                // getMedicalCenter(
                                                //     location:
                                                //         categoryOfStates[index]
                                                //             ['name']);

                                                setState(() {});
                                              } else if (category == 'c') {
                                                Navigator.pop(
                                                    context,
                                                    categoryOfCity[index]
                                                            ['name']
                                                        .toString());

                                                getIds1 = categoryOfCity[index]
                                                        ['id']
                                                    .toString();

                                                categoryOfCitiesDropDown =
                                                    categoryOfCity[index]
                                                            ['name']
                                                        .toString();

                                                setState(() {});
                                              } else {
                                                Navigator.pop(
                                                    context,
                                                    categoryOfMedicalCenter[
                                                            index]['post_title']
                                                        .toString());

                                                getMedicalCenterID =
                                                    categoryOfMedicalCenter[
                                                            index]["ID"]
                                                        .toString();

                                                categoryOfMedicalCenterDropDown =
                                                    categoryOfMedicalCenter[
                                                        index]['post_title'];

                                                setState(() {});
                                              }
                                              sController.clear();
                                            },
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Colors.grey.shade400,
                                          ).paddingOnly(right: 6)
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then((value) {
      sController.clear();
      if (category == "s") {
        categoryOfStatesDropDown = value;
        setState(() {});
      } else if (category == 'c') {
        categoryOfCitiesDropDown = value;
        setState(() {});
      } else {
        categoryOfMedicalCenterDropDown = value;
        setState(() {});
      }
    });
  }

  /// SIGN UP BUTTON

  _signUpButton(BuildContext context) {
    return CustomButton(
      textSize: 24,
      onPressed: () async {
        dateValidate = _userController.dateOfBirth.value == "" ? false : true;
        specialityValidate =
            _userController.selectedSpeciality.value == "" ? false : true;
        stateValidate = (categoryOfStatesDropDown.toString().isEmpty ||
                categoryOfStatesDropDown == null)
            ? false
            : true;
        cityValidate = (categoryOfCitiesDropDown.toString().isEmpty ||
                categoryOfCitiesDropDown == null)
            ? false
            : true;

        setState(() {});

        if (_formKey.currentState!.validate() &&
            dateValidate &&
            stateValidate &&
            cityValidate &&
            specialityValidate &&
            _userController.tribalBackgroundStatus.value.isNotEmpty) {
          if (selector == 0 && isDoctorVerify == true) {
            _userController.registerData = User(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              gender: _userController.selectedGender.value,
              email: _emailController.text,
              password: _passwordController.text,
              perAppointmentCharge: _perAppointmentChargeController.text,
              profilePic: _image?.path ?? "",
              certificateNo: _certificateController.text,
              speciality: _userController.selectedSpeciality.value == "Other"
                  ? specialityController.text.trim()
                  : _userController.selectedSpeciality.value,
              tribalBackgroundStatus:
                  _userController.tribalBackgroundStatus.value,
              userType: "2",
              dateOfBirth: DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_userController.dateOfBirth.value)),
              contactNumber: _contactController.text,
              education: _educationController.text,
              state: getIds ?? "",
              city: getIds1 ?? "",
              medicalCenterID: getMedicalCenterID ?? "",
              isIhUser: categoryOfMedicalCenterDropDown == "United Natives"
                  ? 0.toString()
                  : 1.toString(),
              providerType: _providerTypeController.text,
              federallyRecognizedTribe:
                  _userController.tribalBackgroundStatus.value ==
                              "Native American" ||
                          _userController.tribalBackgroundStatus.value ==
                              "Alaska Native"
                      ? _userController.fedRecognizedTribe.value.toString()
                      : "",
              tribal_affiliation_enrolled:
                  _userController.fedRecognizedTribe.value == "Yes"
                      ? tribalRecognizedYesController.text.trim()
                      : "",
              tribal_descendancy_affiliate:
                  _userController.fedRecognizedTribe.value == "No"
                      ? tribalRecognizedNoController.text.trim()
                      : "",
            );
            if (_image != null) {
              _userController.registerUserProfile = _image!;
            }
            Get.toNamed(Routes.phoneAuthScreen);
          } else {
            _userController.registerData = User(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              gender: _userController.selectedGender.value,
              email: _emailController.text,
              password: _passwordController.text,
              dateOfBirth: DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_userController.dateOfBirth.value)),
              perAppointmentCharge: _perAppointmentChargeController.text,
              profilePic: _image?.path ?? "",
              certificateNo: _certificateController.text,
              speciality: _userController.selectedSpeciality.value == "Other"
                  ? specialityController.text.trim()
                  : _userController.selectedSpeciality.value,
              tribalBackgroundStatus:
                  _userController.tribalBackgroundStatus.value,
              userType: "2",
              isAdmin: '2',
              contactNumber: _contactController.text,
              education: _educationController.text,
              state: getIds ?? "",
              city: getIds1 ?? "",
              medicalCenterID: getMedicalCenterID ?? "",
              isIhUser: categoryOfMedicalCenterDropDown == "United Natives"
                  ? 0.toString()
                  : 1.toString(),
              providerType: _providerTypeController.text,
              federallyRecognizedTribe:
                  _userController.tribalBackgroundStatus.value ==
                              "Native American" ||
                          _userController.tribalBackgroundStatus.value ==
                              "Alaska Native"
                      ? _userController.fedRecognizedTribe.value.toString()
                      : "",
              tribal_affiliation_enrolled:
                  _userController.fedRecognizedTribe.value == "Yes"
                      ? tribalRecognizedYesController.text.trim()
                      : "",
              tribal_descendancy_affiliate:
                  _userController.fedRecognizedTribe.value == "No"
                      ? tribalRecognizedNoController.text.trim()
                      : "",
            );
            if (_image != null) {
              _userController.registerUserProfile = _image!;
            }
            Get.toNamed(Routes.phoneAuthScreen);
          }
        }
      },
      text: Translate.of(context)!.translate('sign_up'),
    ).paddingOnly(top: 40);
  }
}
