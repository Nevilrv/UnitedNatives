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
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import '../../data/pref_manager.dart';
import '../../model/user.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

enum Gender { male, female }

String? text;
String? dropdownValuesState;
String? dropdownValuesStateID;
List categoryItemListState = [];
bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
bool stateLoader = false;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserController userController = Get.find();
  final digitController = TextEditingController();

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
        categoryItemListState = result;
        stateLoader = false;
      });
      return result;
    } else {
      setState(() {
        stateLoader = false;
      });
    }
  }

  int? getId;

  @override
  void initState() {
    getStates();
    super.initState();
  }

  @override
  void dispose() {
    dropdownValuesState = null;
    categoryItemListState.clear();
    userController.onDispose();
    super.dispose();
  }

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        key: _scaffoldKey,
        appBar: AppBar(
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
                      const Expanded(
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38),
                        child: Text(
                          Translate.of(context).translate('sign_up'),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      WidgetSignUp(scaffoldKey: _scaffoldKey),
                      const Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${Translate.of(context).translate('Already a Client')} ?',
                                style: const TextStyle(
                                  color: Color(0xffbcbcbc),
                                  fontSize: 20,
                                  fontFamily: 'NunitoSans',
                                ),
                              ),
                              const Text(' '),
                              InkWell(
                                borderRadius: BorderRadius.circular(2),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    Translate.of(context).translate('login'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
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
}

class WidgetSignUp extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const WidgetSignUp({super.key, this.scaffoldKey});

  @override
  State<WidgetSignUp> createState() => _WidgetSignUpState();
}

class _WidgetSignUpState extends State<WidgetSignUp> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final sController = TextEditingController();
  final insuranceCompanyName = TextEditingController();
  final howDidYouHearAboutUs = TextEditingController();
  final allergiesController = TextEditingController();
  final whatTribe1Controller = TextEditingController();
  final whatTribe2Controller = TextEditingController();

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final currentCaseContactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();

  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String? dropdownValuesCity;
  String? dropdownValuesCityID;
  List categoryItemListCity = [];

  bool cityLoader = false;
  Future getCities(String id) async {
    setState(() {
      cityLoader = true;
    });
    http.Response response = await http.get(
      Uri.parse('${Constants.baseUrl + Constants.getAllCityByState}/$id'),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      setState(() {
        categoryItemListCity = result;
        cityLoader = false;
      });
      return result;
    } else {
      setState(() {
        cityLoader = false;
      });
    }
  }

  Future<void> _getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: imageSource);

      if (pickedFile != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1.1, ratioY: 1.1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "",
              showCropGrid: true,
              toolbarColor: _isDark ? Colors.grey.shade600 : Colors.white,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              backgroundColor: Colors.black,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: "",
              aspectRatioLockEnabled: true,
            )
          ],
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

  String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please Enter Mobile Number';
    } else if (value.length != 10) {
      return 'Mobile Number Should be 10 Digit';
    } else if (!regExp.hasMatch(value)) {
      return 'Please Enter Valid Mobile Number';
    }
    return null;
  }

  String? doctorsTypes;
  final digitController = TextEditingController();

  @override
  void dispose() {
    dropdownValuesState = null;
    dropdownValuesCity = null;
    categoryItemListCity.clear();
    categoryItemListState.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _contactController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    cityController.clear();
    sController.clear();
    _userController.selectedGender = ''.obs;
    _userController.dateOfBirth = ''.obs;
    _userController.selectedBloodGroup = ''.obs;
    _userController.selectedMaritalStatus = ''.obs;
    _userController.selectedInsuranceEligibility = ''.obs;
    _userController.tribalFederallyMember = ''.obs;
    _userController.tribalFederallyState = ''.obs;
    _userController.tribalBackgroundStatus = ''.obs;
    super.dispose();
  }

  dynamic radioSelector;
  bool isVerify = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Form(
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
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const Positioned.fill(
                              child:
                                  Icon(Icons.camera_alt, color: Colors.white))
                        ])
                      : const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.camera_alt,
                              size: 30, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${Translate.of(context).translate('first_name_dot')} *",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  controller: _firstNameController,
                  hintText: 'John',
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Enter First Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('last_name_dot')} *",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  controller: _lastNameController,
                  hintText: 'Doe',
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Enter Last Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('gender_dot')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    validator: (value) =>
                        value == null ? 'Please Select Gender' : null,
                    isExpanded: true,
                    value: _userController.selectedGender.value.isEmpty
                        ? null
                        : _userController.selectedGender.value,
                    hint: Text(
                      Translate.of(context).translate('add_gender'),
                      style: hintStyle,
                    ),
                    onChanged: _userController.onChangeGender,
                    items: _userController.dropDownGender,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${Translate.of(context).translate('email_dot')} *",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  hintText: 'contact@sataware.com',
                  validator: (value) => EmailValidator.validate(value)
                      ? null
                      : "Please Enter a Valid Email.",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Contact number')} *",
                  style: kInputTextStyle,
                ),
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('date_of_birth_dot')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: _userController.dateOfBirth.value.isEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              DateFormat('EEEE, dd MMMM, yyyy').format(
                                DateTime.parse(
                                    _userController.dateOfBirth.value),
                              ),
                              style: const TextStyle(fontSize: 20),
                            ),
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('height_dot')} (Optional)",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: heightController,
                  hintText: Translate.of(context).translate('in_cm'),
                ),
                const SizedBox(height: 20),
                Text(
                  "${Translate.of(context).translate('weight_dot')} (Optional)",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: weightController,
                  hintText: Translate.of(context).translate('in_kg'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Emergency Contact (Optional)',
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: emergencyContactController,
                  hintText: '+1 5204454661',
                  // validator: validateMobile,
                ),
                const SizedBox(height: 20),
                Text(
                  "${Translate.of(context).translate('Current Case Manger info')} (Optional)",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  controller: currentCaseContactController,
                  hintText: '+1 5204454661',
                ),
                const SizedBox(height: 20),
                Text(
                  "${Translate.of(context).translate('Blood Group')} (Optional)",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    isExpanded: true,
                    value: _userController.selectedBloodGroup.value.isEmpty
                        ? null
                        : _userController.selectedBloodGroup.value,
                    hint: Text(
                      Translate.of(context).translate('add_blood_group'),
                      style: hintStyle,
                    ),
                    onChanged: _userController.onChangeBloodGroup,
                    items: _userController.dropDownBlood,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Allergies and Medication Allergies')} (Optional)",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  controller: allergiesController,
                  hintText:
                      'Enter if you have any Allergies and Medication Allergies',
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Marital Status')} (Optional)",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    isExpanded: true,
                    value: _userController.selectedMaritalStatus.value.isEmpty
                        ? null
                        : _userController.selectedMaritalStatus.value,
                    hint: Text(
                      Translate.of(context).translate('add_marital_status'),
                      style: hintStyle,
                    ),
                    onChanged: _userController.onChangeMaritalStatus,
                    items: _userController.dropDownMarital,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Medical Insurance')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => Column(
                    children: [
                      DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        focusNode: FocusNode(),
                        validator: (value) => value == null
                            ? 'Please Select Medical Insurance'
                            : null,
                        isExpanded: true,
                        value: _userController
                                .selectedInsuranceEligibility.value.isEmpty
                            ? null
                            : _userController
                                .selectedInsuranceEligibility.value,
                        hint: Text(
                          Translate.of(context)
                              .translate('Please Select Insurance Eligibility'),
                          style: hintStyle,
                        ),
                        onChanged: _userController.onChangeInsuranceEligibility,
                        items: _userController.dropDownInsurance,
                      ),
                      if (_userController.selectedInsuranceEligibility.value ==
                          "Yes")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${Translate.of(context).translate('State the name of your Medical Insurance')} *",
                              style: kInputTextStyle,
                            ),
                            CustomTextFormField(
                              focusNode: FocusNode(),
                              textInputAction: TextInputAction.next,
                              controller: insuranceCompanyName,
                              hintText:
                                  'Enter State the name of Medical Insurance',
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Enter State the name of Medical Insurance';
                                }
                                return null;
                              },
                            )
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Are you a US Veteran?')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => Column(
                    children: [
                      DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        focusNode: FocusNode(),
                        validator: (value) => value == null
                            ? 'Please Select US Veteran or not?'
                            : null,
                        isExpanded: true,
                        value: _userController.areYouAUSVeteran.value.isEmpty
                            ? null
                            : _userController.areYouAUSVeteran.value,
                        hint: Text(
                          Translate.of(context)
                              .translate('Select US Veteran or not?'),
                          style: hintStyle,
                        ),
                        onChanged: _userController.onAareYouAUSVeteran,
                        items: _userController.dropDownAreYouAUSVeteran,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Tribal Status')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    validator: (value) =>
                        value == null ? 'Please Select Tribal Status' : null,
                    isExpanded: true,
                    value: _userController.selectedTribalStatus.value.isEmpty
                        ? null
                        : _userController.selectedTribalStatus.value,
                    hint: Text(
                      Translate.of(context).translate('Select Tribal Status'),
                      style: hintStyle,
                    ),
                    onChanged: _userController.onChangeTribalStatus,
                    items: _userController.dropDownTribal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Are you enrolled in a Federally Recognized Tribe?')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => Column(
                    children: [
                      DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        focusNode: FocusNode(),
                        validator: (value) => value == null
                            ? 'Please Select Tribal Status'
                            : null,
                        isExpanded: true,
                        value:
                            _userController.tribalFederallyMember.value.isEmpty
                                ? null
                                : _userController.tribalFederallyMember.value,
                        hint: Text(
                          Translate.of(context)
                              .translate('Select Enrolled or not'),
                          style: hintStyle,
                        ),
                        onChanged:
                            _userController.onChangeTribalFederallyStatus,
                        items: _userController.dropDownTribal1,
                      ),
                      if (_userController.tribalFederallyMember.value == "Yes")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${Translate.of(context).translate('What tribe?')} *",
                              style: kInputTextStyle,
                            ),
                            CustomTextFormField(
                              focusNode: FocusNode(),
                              textInputAction: TextInputAction.next,
                              controller: whatTribe1Controller,
                              hintText: 'Enter state tribal affiliation',
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Please state tribal affiliation';
                                }
                                return null;
                              },
                            )
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('Are you enrolled in a State Recognized Tribe?')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => Column(
                    children: [
                      DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        focusNode: FocusNode(),
                        validator: (value) => value == null
                            ? 'Please select enrolled or not'
                            : null,
                        isExpanded: true,
                        value:
                            _userController.tribalFederallyState.value.isEmpty
                                ? null
                                : _userController.tribalFederallyState.value,
                        hint: Text(
                            Translate.of(context)
                                .translate('Select Enrolled or not'),
                            style: hintStyle),
                        onChanged: _userController.onChangeTribalStateStatus,
                        items: _userController.dropDownTribal2,
                      ),
                      if (_userController.tribalFederallyState.value == "Yes")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${Translate.of(context).translate('Please state tribal affiliation')} *",
                              style: kInputTextStyle,
                            ),
                            CustomTextFormField(
                              focusNode: FocusNode(),
                              textInputAction: TextInputAction.next,
                              controller: whatTribe2Controller,
                              hintText: 'Enter state tribal affiliation',
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Please state tribal affiliation';
                                }
                                return null;
                              },
                            )
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('If you are not enrolled tribal member, please select racial/ethnic background')} *",
                  style: kInputTextStyle,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    validator: (value) => value == null
                        ? 'Please select racial/ethnic background'
                        : null,
                    isExpanded: true,
                    value: _userController.tribalBackgroundStatus.value.isEmpty
                        ? null
                        : _userController.tribalBackgroundStatus.value,
                    hint: Text(
                        Translate.of(context)
                            .translate('Select racial/ethnic background'),
                        style: hintStyle),
                    onChanged: _userController.onChangeTribalBackgroundStatus,
                    items: _userController.dropDownTribal3,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('password_dot')} *",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  controller: _passwordController,
                  hintText: '* * * * * * * *',
                  obscureText: true,
                  validator: (text) {
                    if (text.toString().length < 8 || text.isEmpty) {
                      return 'Password Should be Greater Than 8 Digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('confirm_password_dot')} *",
                  style: kInputTextStyle,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.done,
                  controller: _confirmPasswordController,
                  hintText: '* * * * * * * *',
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Enter Confirm Password';
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      return 'Confirm Password Does Not Match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${Translate.of(context).translate('State')} *",
                  style: kInputTextStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                dropDownView(
                  state: true,
                  colorCon: categoryItemListState == [] ||
                      categoryItemListState.isEmpty,
                  textStyleCon: dropdownValuesState == null,
                  text: dropdownValuesState != null
                      ? '$dropdownValuesState'
                      : 'Select State',
                  onTap: () {
                    if (categoryItemListState.isNotEmpty) {
                      selectStateCity(state: true, h: h, w: w);
                    }
                  },
                ),
                Text(
                  "${Translate.of(context).translate('City')} *",
                  style: kInputTextStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                dropDownView(
                  state: false,
                  colorCon: categoryItemListCity == [] ||
                      categoryItemListCity.isEmpty,
                  textStyleCon: categoryItemListCity == [] ||
                      categoryItemListCity.isEmpty,
                  text: dropdownValuesCity != null
                      ? '$dropdownValuesCity'
                      : 'Select City',
                  onTap: () {
                    if (categoryItemListCity.isNotEmpty) {
                      selectStateCity(state: false, h: h, w: w);
                    }
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  "${Translate.of(context).translate('How did you hear about us?')} (Optional)",
                  style: kInputTextStyle,
                ),
                const SizedBox(height: 3),
                Obx(
                  () => DropdownButtonFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    focusNode: FocusNode(),
                    // validator: (value) => value == null
                    //     ? 'Please select racial/ethnic background'
                    //     : null,
                    isExpanded: true,
                    value: _userController.howYouHereAboutUs.value.isEmpty
                        ? null
                        : _userController.howYouHereAboutUs.value,
                    hint: Text(
                        Translate.of(context)
                            .translate('Select how did you here about us'),
                        style: hintStyle),
                    onChanged: (value) {
                      _userController.onChangeHowYouHereAboutUsStatus(value);
                      howDidYouHearAboutUs.text = value.toString();
                    },
                    items: _userController.dropDownHowYouHereAboutUs,
                  ),
                ),

                /* SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 'IH Client',
                        groupValue: doctorsTypes,
                        onChanged: (value) {
                          setState(() {
                            doctorsTypes = value.toString();
                            radioSelector = 0;
                          });
                          print(doctorsTypes);
                          print(radioSelector);
                        },
                      ),
                    ),
                    Text(
                      'UN Client',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.subtitle1.color,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 'Other Client',
                        groupValue: doctorsTypes,
                        onChanged: (value) {
                          setState(() {
                            doctorsTypes = value.toString();
                            radioSelector = 1;
                            print(radioSelector);
                          });
                          print(doctorsTypes);
                        },
                      ),
                    ),
                    Text(
                      'Other Client',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.subtitle1.color,
                      ),
                    )
                  ],
                ),*/
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                  textSize: 24,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_userController.dateOfBirth.value == "") {
                        Utils.showSnackBar(
                            'Warning!', "Please select date of birth.");
                        return;
                      }
                      if (dropdownValuesStateID.toString().isEmpty ||
                          dropdownValuesStateID == null) {
                        Utils.showSnackBar('Warning!', "Please select state.");
                        return;
                      }
                      if (dropdownValuesCityID.toString().isEmpty ||
                          dropdownValuesCityID == null) {
                        Utils.showSnackBar('Warning!', "Please select city.");
                        return;
                      }

                      _userController.registerData = User(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        gender: _userController.selectedGender.value,
                        email: _emailController.text,
                        password: _passwordController.text,
                        bloodGroup: _userController.selectedBloodGroup.value,
                        height: heightController.text.trim(),
                        weight: weightController.text.trim(),
                        currentCaseManagerInfo:
                            currentCaseContactController.text.trim(),
                        emergencyContact: emergencyContactController.text,
                        dateOfBirth: DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(_userController.dateOfBirth.value)),
                        contactNumber: _contactController.text,
                        allergies: allergiesController.text.trim(),
                        maritalStatus:
                            _userController.selectedMaritalStatus.value,
                        insuranceEligibility:
                            _userController.selectedInsuranceEligibility.value,
                        insuranceCompanyName: insuranceCompanyName.text.trim(),
                        userType: "1",
                        city: dropdownValuesCityID ?? "",
                        state: dropdownValuesStateID ?? "",
                        isIhUser:
                            radioSelector == 0 ? 0.toString() : 1.toString(),
                        howDidYouHearAboutUs: howDidYouHearAboutUs.text.trim(),
                        tribalStatus:
                            _userController.selectedTribalStatus.value,
                        usVeteranStatus: _userController.areYouAUSVeteran.value,
                        tribalFederallyMember:
                            _userController.tribalFederallyMember.value == "Yes"
                                ? whatTribe1Controller.text.trim()
                                : "",
                        tribalFederallyState:
                            _userController.tribalFederallyState.value == "Yes"
                                ? whatTribe2Controller.text.trim()
                                : "",
                        tribalBackgroundStatus:
                            _userController.tribalBackgroundStatus.value,
                      );
                      if (_image != null) {
                        _userController.registerUserProfile = _image!;
                      }
                      _signUpMedicleCenter();
                      Get.toNamed(Routes.phoneAuthScreen);

                      /*if (radioSelector == 0 && isVerify == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return SimpleDialog(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            hintText: 'Enter The 6 Digit Pin'),
                                        controller: digitController,
                                        onChanged: (value) {
                                          setState(() {
                                            value = text;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(digitController.text);
                                          print(data);
                                          print(
                                              '+++++++${digitController.text == data}');
                                          if (digitController.text == data) {
                                            setState(() {
                                              isVerify = true;
                                            });

                                            Get.snackbar('success',
                                                'Verify Successfully',
                                                backgroundColor: Colors.blue);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              isVerify = false;
                                            });
                                            Get.snackbar(
                                                '6 digit code wrong', '',
                                                backgroundColor: Colors.blue);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Verify'),
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(40, 30)),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else */
                      // if (radioSelector == 0 && isVerify == true) {
                      //   print('++++$isVerify');
                      //   _userController.registerData = User(
                      //     firstName: _firstNameController.text,
                      //     lastName: _lastNameController.text,
                      //     gender: _userController.selectedGender.value,
                      //     email: _emailController.text,
                      //     password: _passwordController.text,
                      //     bloodGroup:
                      //         _userController.selectedBloodGroup.value ?? "",
                      //     emergencyContact: _contactController.text,
                      //     dateOfBirth:
                      //         '${DateFormat('yyyy-MM-dd').format(DateTime.parse(_userController.dateOfBirth.value))}',
                      //     contactNumber: _contactController.text,
                      //     maritalStatus:
                      //         _userController.selectedMaritalStatus.value,
                      //     insuranceEligibility: _userController
                      //         .selectedInsuranceEligibility.value,
                      //     tribalStatus:
                      //         _userController.selectedTribalStatus.value,
                      //     userType: "1",
                      //     isAdmin: '1',
                      //     city: dropdownValuesCityID ?? "",
                      //     state: dropdownValuesStateID ?? "",
                      //     isIhUser:
                      //         radioSelector == 0 ? 0.toString() : 1.toString(),
                      //   );
                      //
                      //   if (_image != null) {
                      //     _userController.registerUserProfile = _image;
                      //   }
                      //   _signUpMedicleCenter();
                      //   Get.toNamed(Routes.phoneAuthScreen);
                      // } else {
                      /// CODE
                      // }
                      // if (RadioSelector == 1  ) {
                      //   _userController.registerData = User(
                      //     firstName: _firstNameController.text,
                      //     lastName: _lastNameController.text,
                      //     gender: _userController.selectedGender.value,
                      //     email: _emailController.text,
                      //     password: _passwordController.text,
                      //     bloodGroup: _userController.selectedBloodGroup.value,
                      //     emergencyContact: _contactController.text,
                      //     dateOfBirth:
                      //         '${DateFormat('yyyy-MM-dd').format(DateTime.parse(_userController.dateOfBirth.value))}',
                      //     contactNumber: _contactController.text,
                      //     maritalStatus:
                      //         _userController.selectedMaritalStatus.value,
                      //     insuranceEligibility: _userController
                      //         .selectedInsuranceEligibility.value,
                      //     tribalStatus:
                      //         _userController.selectedTribalStatus.value,
                      //     userType: "1",
                      //     city: getId1,
                      //     state: getId,
                      //   );
                      //
                      //   if (_image != null) {
                      //     _userController.registerUserProfile = _image;
                      //   }
                      //   _signUpMedicleCenter();
                      //   // await Navigator.pushNamed(context, Routes.phoneAuthScreen);
                      //   Get.toNamed(Routes.phoneAuthScreen);
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                      //         return SimpleDialog(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(horizontal: 10),
                      //               child: TextFormField(
                      //
                      //                 decoration: InputDecoration(
                      //                     focusedBorder: OutlineInputBorder(
                      //                       borderSide: BorderSide(
                      //                         color: Colors.grey,
                      //                       ),
                      //                     ),
                      //                     enabledBorder: OutlineInputBorder(
                      //                       borderSide: BorderSide(
                      //                         color: Colors.grey,
                      //                       ),
                      //                     ), hintText: 'Enter The 6 Digit Pin'
                      //                 ),controller: digitController,
                      //                 onChanged: (value){
                      //                   setState((){
                      //                    value=text;
                      //                   });
                      //                 },
                      //               ),
                      //             ),SizedBox(height: 15),
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(horizontal: 50),
                      //               child: ElevatedButton(onPressed: (){
                      //                 print(digitController.text);print(data);
                      //                 print('+++++++${digitController.text==data}');
                      //                 if(digitController.text==data){
                      //                     setState((){});
                      //                     isVerify=true;
                      //                   Get.snackbar('success', 'Verify Successfully');
                      //
                      //                 }else{
                      //                   Get.snackbar('6 digit code wrong', '');
                      //                 }
                      //               }, child: Text('Verify'),style: ElevatedButton.styleFrom(fixedSize: Size(40, 30)),),
                      //             )
                      //           ],
                      //         );
                      //       },
                      //
                      //       );
                      //     },
                      //   );
                      // }
                    }
                  },
                  text: Translate.of(context).translate('sign_up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signUpMedicleCenter() async {
    final result = await AppBloc.userCubit.onRegister(
      username: _firstNameController.text,
      password: _confirmPasswordController.text,
      email: _emailController.text,
    );
    log('result==========>>>>>$result');
  }

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
                  Translate.of(context).translate('take_a_photo'),
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
                  Translate.of(context).translate('choose_a_photo'),
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

  dropDownView({
    required void Function() onTap,
    required String text,
    required bool textStyleCon,
    required bool colorCon,
    required bool state,
  }) async {
    return GestureDetector(
      onTap: onTap,
      child: commonContainer(
        child: Column(
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
                  ),
                ),
                (state == true && stateLoader == true) ||
                        (state == false && cityLoader == true)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Utils.circular(),
                        ))
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
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade500,
            )
          ],
        ),
      ),
    );
  }

  selectStateCity(
      {required double h, required double w, required bool state}) async {
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
                    // height: h * 0.6,
                    // width: w * 0.85,
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
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (state) {
                                    Navigator.pop(context, dropdownValuesState);
                                  } else {
                                    Navigator.pop(context, dropdownValuesCity);
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
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                int index = state
                                    ? categoryItemListState.indexWhere(
                                        (element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase()))
                                    : categoryItemListCity.indexWhere(
                                        (element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase()));
                                if (index < 0) {
                                  return Center(
                                    child: Text(
                                      state ? 'No States !' : 'No City !',
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
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state
                                      ? categoryItemListState.length
                                      : categoryItemListCity.length,
                                  itemBuilder: (context, index) {
                                    if (state
                                        ? categoryItemListState[index]['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase())
                                        : categoryItemListCity[index]['name']
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
                                            onTap: () async {
                                              if (state) {
                                                Navigator.pop(
                                                    context,
                                                    categoryItemListState[index]
                                                            ['name']
                                                        .toString());
                                                sController.clear();
                                                dropdownValuesStateID =
                                                    categoryItemListState[index]
                                                            ['id']
                                                        .toString();

                                                dropdownValuesCity = null;
                                                dropdownValuesCityID = null;
                                                categoryItemListCity.clear();
                                                await getCities(
                                                    dropdownValuesStateID!);

                                                setState(() {});
                                              } else {
                                                Navigator.pop(
                                                    context,
                                                    categoryItemListCity[index]
                                                            ['name']
                                                        .toString());
                                                sController.clear();
                                                dropdownValuesCityID =
                                                    categoryItemListCity[index]
                                                            ['id']
                                                        .toString();
                                                setState(() {});
                                              }
                                              sController.clear();
                                            },
                                            title: Text(
                                              state
                                                  ? categoryItemListState[index]
                                                          ['name']
                                                      .toString()
                                                  : categoryItemListCity[index]
                                                          ['name']
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.color,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            height: 0,
                                          )
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
      if (state) {
        dropdownValuesState = value;
        setState(() {});
      } else {
        dropdownValuesCity = value;
        setState(() {});
      }
    });
  }

  static Container commonContainer({required Widget child}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.transparent),
      child: child,
    );
  }
}

/*if (radioSelector == 0 && isVerify == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return SimpleDialog(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            hintText: 'Enter The 6 Digit Pin'),
                                        controller: digitController,
                                        onChanged: (value) {
                                          setState(() {
                                            value = text;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(digitController.text);
                                          print(data);
                                          print(
                                              '+++++++${digitController.text == data}');
                                          if (digitController.text == data) {
                                            setState(() {
                                              isVerify = true;
                                            });

                                            Get.snackbar('success',
                                                'Verify Successfully',
                                                backgroundColor: Colors.blue);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              isVerify = false;
                                            });
                                            Get.snackbar(
                                                '6 digit code wrong', '',
                                                backgroundColor: Colors.blue);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Verify'),
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(40, 30)),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else */
// if (radioSelector == 0 && isVerify == true) {
//   print('++++$isVerify');
//   _userController.registerData = User(
//     firstName: _firstNameController.text,
//     lastName: _lastNameController.text,
//     gender: _userController.selectedGender.value,
//     email: _emailController.text,
//     password: _passwordController.text,
//     bloodGroup:
//         _userController.selectedBloodGroup.value ?? "",
//     emergencyContact: _contactController.text,
//     dateOfBirth:
//         '${DateFormat('yyyy-MM-dd').format(DateTime.parse(_userController.dateOfBirth.value))}',
//     contactNumber: _contactController.text,
//     maritalStatus:
//         _userController.selectedMaritalStatus.value,
//     insuranceEligibility: _userController
//         .selectedInsuranceEligibility.value,
//     tribalStatus:
//         _userController.selectedTribalStatus.value,
//     userType: "1",
//     isAdmin: '1',
//     city: dropdownValuesCityID ?? "",
//     state: dropdownValuesStateID ?? "",
//     isIhUser:
//         radioSelector == 0 ? 0.toString() : 1.toString(),
//   );
//
//   if (_image != null) {
//     _userController.registerUserProfile = _image;
//   }
//   _signUpMedicleCenter();
//   Get.toNamed(Routes.phoneAuthScreen);
// } else {
