import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/utils/utils.dart';

import '../../../components/text_form_field.dart';
import '../../../utils/constants.dart';

class EditWidget extends StatefulWidget {
  const EditWidget({super.key});

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final UserUpdateController _userUpdateController = Get.find();
  final UserController _userController = Get.find();
  bool stateLoader = false;
  bool cityLoader = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String? dropdownValuesState;
  List categoryItemListState = [];
  String? dropdownValuesCity;
  List categoryItemListCity = [];
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final searchController = TextEditingController();

  initName() {
    dropdownValuesState = _userController.user.value.stateName;
    dropdownValuesCity = _userController.user.value.cityName;
    setState(() {});
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
        categoryItemListState = result;

        for (var element in categoryItemListState) {
          if (element['id'].toString() == _userUpdateController.getStateId) {
            dropdownValuesState = element['name'];
          }
        }
        stateLoader = false;
      });

      return result;
    } else {
      setState(() {
        stateLoader = false;
      });
    }
  }

  Future getCities({String? stateId}) async {
    setState(() {
      cityLoader = true;
    });

    http.Response response = await http.get(
      Uri.parse(
          '${Constants.baseUrl + Constants.getAllCityByState}/${_userUpdateController.getStateId ?? stateId}'),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      setState(() {
        categoryItemListCity = result;

        for (var element in categoryItemListCity) {
          if (element['id'].toString() == _userUpdateController.getCityId) {
            dropdownValuesCity = element['name'];
          }
        }
        cityLoader = false;
      });

      return result;
    } else {
      setState(() {
        cityLoader = false;
      });
    }
  }

  @override
  void initState() {
    initName();
    getStates();
    getCities();

    super.initState();
  }

  @override
  void dispose() {
    categoryItemListState = [];
    categoryItemListCity = [];
    dropdownValuesState = null;
    dropdownValuesCity = null;
    super.dispose();
  }

  File? _image;
  ImagePicker imagePicker = ImagePicker();

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
            print("Image Path===>${_image?.path}");
          });
        }
      }
    } catch (e) {
      print("Error picking/cropping image: $e");
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    _openBottomSheet(context);
                  },
                  child: _image != null
                      ? Stack(
                          children: [
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
                                  Icon(Icons.camera_alt, color: Colors.white),
                            )
                          ],
                        )
                      : Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              _userController.user.value.profilePic ??
                                  _userController.user.value.socialProfilePic ??
                                  'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  Translate.of(context)!.translate('Profile Picture'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "${Translate.of(context)!.translate('first_name_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                hintText: 'John',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter First Name';
                  }
                  return null;
                },
                controller: _userUpdateController.firstNameController,
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('last_name_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                hintText: 'Brad',
                controller: _userUpdateController.lastNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Last Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('contact_number_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                controller: _userUpdateController.contactController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ], // textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                validator: validateMobile,
                hintText: '+1 520 44 54 661',
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('email_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintText: 'patient@sataware.com',
                enabled: false,
                controller: _userUpdateController.emailController,
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('gender_dot')} *",
                style: kInputTextStyle,
              ),
              Obx(
                () => DropdownButtonFormField(
                  validator: (value) =>
                      value == null ? 'Please Select Gender' : null,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  isExpanded: true,
                  value: _userUpdateController.selectedGender.value.isEmpty
                      ? null
                      : _userUpdateController.selectedGender.value,
                  hint: Text(
                    Translate.of(context)!.translate('add_gender'),
                    style: hintStyle,
                  ),
                  onChanged: _userUpdateController.onChangeGender,
                  items: _userUpdateController.dropDownGender,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('date_of_birth_dot')} *",
                style: kInputTextStyle,
              ),

              Obx(
                () => ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: _userUpdateController.dateOfBirth.value.isEmpty
                      ? const Text(
                          "Tap to Select BirthDate",
                          style: hintStyle,
                        )
                      : Text(
                          DateFormat('EEEE, dd MMMM, yyyy').format(
                            DateTime.parse(
                                _userUpdateController.dateOfBirth.value),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    ).then(
                      (DateTime? value) {
                        if (value != null) {
                          _userUpdateController.onDateOfBirth(value.toString());
                        }
                      },
                    );
                  },
                ),
              ),
              Container(
                  width: Get.width,
                  color: _isDark ? Colors.white38 : Colors.black38,
                  height: 1),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('blood_group_dot')} (Optional)",
                style: kInputTextStyle,
              ),
              Obx(
                () => DropdownButtonFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  isExpanded: true,
                  value: _userUpdateController.selectedBloodGroup.value.isEmpty
                      ? null
                      : _userUpdateController.selectedBloodGroup.value,
                  hint: Text(
                    Translate.of(context)!.translate('add_blood_group'),
                    style: hintStyle,
                  ),
                  onChanged: _userUpdateController.onChangeBloodGroup,
                  items: _userUpdateController.dropDownBlood,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "${Translate.of(context)?.translate('Allergies and Medication Allergies')} (Optional)",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                focusNode: FocusNode(),
                textInputAction: TextInputAction.next,
                controller: _userUpdateController.allergiesController,
                hintText:
                    'Enter if you have any Allergies and Medication Allergies',
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('marital_status_dot')} (Optional)",
                style: kInputTextStyle,
              ),
              Obx(
                () => DropdownButtonFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  // validator: (value) =>
                  //     value == null ? 'Please Select Marital Status' : null,
                  isExpanded: true,
                  value:
                      _userUpdateController.selectedMaritalStatus.value.isEmpty
                          ? null
                          : _userUpdateController.selectedMaritalStatus.value,
                  hint: Text(
                    Translate.of(context)!.translate('add_marital_status'),
                    style: hintStyle,
                  ),
                  onChanged: _userUpdateController.onChangeMaritalStatus,
                  items: _userUpdateController.dropDownMarital,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('height_dot')} (Optional)",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _userUpdateController.heightController,
                hintText: Translate.of(context)!.translate('in_cm'),
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('weight_dot')} (Optional)",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _userUpdateController.weightController,
                hintText: Translate.of(context)!.translate('in_kg'),
              ),
              const SizedBox(height: 15),
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
                controller: _userUpdateController.emergencyContactController,
                hintText: '+1 5204454661',
                // validator: validateMobile,
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('Current Case Manger info')} (Optional)",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                controller: _userUpdateController.currentCaseContactController,
                hintText: '+1 5204454661',
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('Medical Insurance')} *",
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
                      validator: (value) => value == null
                          ? 'Please Select Insurance Eligibility'
                          : null,
                      isExpanded: true,
                      value: _userUpdateController
                              .selectedInsuranceEligibility.value.isEmpty
                          ? null
                          : _userUpdateController
                              .selectedInsuranceEligibility.value,
                      hint: Text(
                        Translate.of(context)!
                            .translate('Please Select Medical Insurance'),
                        style: hintStyle,
                      ),
                      onChanged: (value) {
                        _userUpdateController
                            .onChangeInsuranceEligibility(value);

                        if (_userUpdateController
                                .selectedInsuranceEligibility.value ==
                            "No") {
                          _userUpdateController.insuranceCompanyName.clear();
                        }
                      },
                      items: _userUpdateController.dropDownInsurance,
                    ),
                    if (_userUpdateController
                            .selectedInsuranceEligibility.value ==
                        "Yes")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${Translate.of(context)?.translate('State the name of your Medical Insurance')} *",
                            style: kInputTextStyle,
                          ),
                          CustomTextFormField(
                            focusNode: FocusNode(),
                            textInputAction: TextInputAction.next,
                            controller:
                                _userUpdateController.insuranceCompanyName,
                            hintText:
                                'Enter State the name of your Medical Insurance',
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'Enter State the name of your Medical Insurance';
                              }
                              return null;
                            },
                          )
                        ],
                      )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('Are you a US Veteran?')} *",
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
                      value:
                          _userUpdateController.areYouAUSVeteran.value.isEmpty
                              ? null
                              : _userUpdateController.areYouAUSVeteran.value,
                      hint: Text(
                        Translate.of(context)!
                            .translate('Select US Veteran or not?'),
                        style: hintStyle,
                      ),
                      onChanged: _userUpdateController.onAareYouAUSVeteran,
                      items: _userUpdateController.dropDownAreYouAUSVeteran,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${Translate.of(context)?.translate('Tribal Status')} *",
                style: kInputTextStyle,
              ),
              Obx(
                () => DropdownButtonFormField(
                  validator: (value) =>
                      value == null ? 'Please Select Tribal Status' : null,
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  value:
                      _userUpdateController.selectedTribalStatus.value.isEmpty
                          ? null
                          : _userUpdateController.selectedTribalStatus.value,
                  hint: Text(
                    Translate.of(context)!
                        .translate('Please Select Tribal Status'),
                    style: hintStyle,
                  ),
                  onChanged: _userUpdateController.onChangeTribalStatus,
                  items: _userUpdateController.dropDownTribal,
                ),
              ),

              ///

              const SizedBox(
                height: 20,
              ),
              Text(
                "${Translate.of(context)?.translate('Are you enrolled in a Federally Recognized Tribe?')} *",
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
                      value: _userUpdateController.tribalFederallyMember.value,
                      hint: Text(
                        Translate.of(context)!
                            .translate('Select enrolled or not'),
                        style: hintStyle,
                      ),
                      onChanged: (value) {
                        _userUpdateController
                            .onChangeTribalFederallyStatus(value);

                        if (_userUpdateController.tribalFederallyMember.value ==
                            "No") {
                          _userUpdateController.whatTribe1Controller.clear();
                        }
                      },
                      items: _userUpdateController.dropDownTribal1,
                    ),
                    if (_userUpdateController.tribalFederallyMember.value ==
                        "Yes")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${Translate.of(context)?.translate('What tribe?')} *",
                            style: kInputTextStyle,
                          ),
                          CustomTextFormField(
                            focusNode: FocusNode(),
                            textInputAction: TextInputAction.next,
                            controller:
                                _userUpdateController.whatTribe1Controller,
                            hintText: 'Enter state tribal affiliation',
                            validator: (text) {
                              if (text!.isEmpty) {
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
                "${Translate.of(context)?.translate('Are you enrolled in a State Recognized Tribe?')} *",
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
                      value: _userUpdateController.tribalFederallyState.value,
                      hint: Text(
                          Translate.of(context)!
                              .translate('Select Enrolled or not'),
                          style: hintStyle),
                      onChanged: (value) {
                        _userUpdateController.onChangeTribalStateStatus(value);
                        if (_userUpdateController.tribalFederallyState.value ==
                            "No") {
                          _userUpdateController.whatTribe2Controller.clear();
                        }
                      },
                      items: _userUpdateController.dropDownTribal2,
                    ),
                    if (_userUpdateController.tribalFederallyState.value ==
                        "Yes")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "${Translate.of(context)?.translate('Please state tribal affiliation')} *",
                            style: kInputTextStyle,
                          ),
                          CustomTextFormField(
                            focusNode: FocusNode(),
                            textInputAction: TextInputAction.next,
                            controller:
                                _userUpdateController.whatTribe2Controller,
                            hintText: 'Enter state tribal affiliation',
                            validator: (text) {
                              if (text!.isEmpty) {
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
              const SizedBox(height: 20),
              Text(
                "${Translate.of(context)?.translate('If you are not enrolled tribal member, please select racial/ethnic background')} *",
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
                  value:
                      _userUpdateController.tribalBackgroundStatus.value.isEmpty
                          ? null
                          : _userUpdateController.tribalBackgroundStatus.value,
                  hint: Text(
                      Translate.of(context)!
                          .translate('Select racial/ethnic background'),
                      style: hintStyle),
                  onChanged:
                      _userUpdateController.onChangeTribalBackgroundStatus,
                  items: _userUpdateController.dropDownTribal3,
                ),
              ),

              ///

              const SizedBox(height: 25),
              Text(
                "${Translate.of(context)?.translate('State')} *",
                style: kInputTextStyle,
              ),
              const SizedBox(height: 10),
              dropDownView(
                state: true,
                colorCon: categoryItemListState.isEmpty,
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
                "${Translate.of(context)?.translate('City')} *",
                style: kInputTextStyle,
              ),
              const SizedBox(height: 10),
              dropDownView(
                state: false,
                colorCon: categoryItemListCity.isEmpty,
                textStyleCon: categoryItemListCity.isEmpty,
                text: dropdownValuesCity != null
                    ? '$dropdownValuesCity'
                    : 'Select City',
                onTap: () {
                  if (categoryItemListCity.isNotEmpty) {
                    selectStateCity(state: false, h: h, w: w);
                  }
                },
              ),
              const SizedBox(height: 35),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                // child: CustomButton(
                //   onPressed: () async {
                //     await _userUpdateController.userProfileUpdate(
                //         userProfilePic: _image, userType: "1");
                //
                //   },
                //   text: 'update_info'.tr(),
                // ),
                child: RoundedLoadingButton(
                  color: kColorBlue,
                  valueColor: Colors.white,
                  successColor: Colors.white,
                  controller: _btnController,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _btnController.start();
                      await _userUpdateController.userProfileUpdate(
                          userProfilePic: _image, userType: "1");
                      _btnController.reset();
                    } else {
                      _btnController.reset();

                      if (_userUpdateController.dateOfBirth.value == null ||
                          _userUpdateController.dateOfBirth.value == "") {
                        Utils.showSnackBar(
                            'Warning!', "Please select date of birth.");
                        return;
                      }
                      if (dropdownValuesState.toString().isEmpty ||
                          dropdownValuesState == null) {
                        Utils.showSnackBar('Warning!', "Please select state.");
                        return;
                      }
                      if (dropdownValuesCity.toString().isEmpty ||
                          dropdownValuesCity == null) {
                        Utils.showSnackBar('Warning!', "Please select city.");
                        return;
                      }
                    }
                  },
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  Translate.of(context)!.translate('take_a_photo'),
                  style: const TextStyle(
                    color: Color(0xff4a4a4a),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  // Navigator.of(context).pop();
                  // _getImage(ImageSource.camera);
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
                  // Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  Widget dropDownView({
    void Function()? onTap,
    String? text,
    bool? state,
    bool? textStyleCon,
    bool? colorCon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: commonContainer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleCon!
                        ? hintStyle
                        : TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                  ),
                ),
                (state == true && stateLoader == true) ||
                        (state == false && cityLoader == true)
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
                            ? colorCon!
                                ? Colors.grey.shade800
                                : Colors.grey.shade100
                            : colorCon!
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

  selectStateCity({double? h, double? w, bool? state}) {
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
                      BoxConstraints(maxHeight: h! * 0.6, maxWidth: 550),
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
                                      controller: searchController,
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
                                  if (state!) {
                                    Navigator.pop(context, dropdownValuesState);
                                  } else {
                                    Navigator.pop(context, dropdownValuesCity);
                                  }
                                  searchController.clear();
                                },
                                icon: const Icon(Icons.clear,
                                    color: Colors.black, size: 25),
                              )
                            ],
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                int index = state!
                                    ? categoryItemListState.indexWhere(
                                        (element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase()))
                                    : categoryItemListCity.indexWhere(
                                        (element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
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
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase())
                                        : categoryItemListCity[index]['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toString()
                                                .toLowerCase())) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
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
                                            onTap: () async {
                                              if (state) {
                                                Navigator.pop(
                                                    context,
                                                    categoryItemListState[index]
                                                            ['name']
                                                        .toString());

                                                _userUpdateController
                                                        .getStateId =
                                                    categoryItemListState[index]
                                                            ['id']
                                                        .toString();
                                                _userUpdateController
                                                    .getCityId = null;
                                                dropdownValuesCity = null;
                                                categoryItemListCity = [];
                                                getCities(
                                                    stateId:
                                                        _userUpdateController
                                                            .getStateId);

                                                setState(() {});
                                              } else {
                                                Navigator.pop(
                                                    context,
                                                    categoryItemListCity[index]
                                                            ['name']
                                                        .toString());
                                                _userUpdateController
                                                        .getCityId =
                                                    categoryItemListCity[index]
                                                            ['id']
                                                        .toString();
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          const Divider(height: 0)
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
      if (state!) {
        dropdownValuesState = value;
        setState(() {});
      } else {
        dropdownValuesCity = value;
        setState(() {});
      }
    });
  }

  static Widget commonContainer({required Widget child}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.transparent,
      ),
      child: child,
    );
  }
}
