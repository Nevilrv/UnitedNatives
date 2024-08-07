import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/controller/user_update_contoller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../components/text_form_field.dart';
import '../../../utils/constants.dart';

class DocEditWidget extends StatefulWidget {
  @override
  _DocEditWidgetState createState() => _DocEditWidgetState();
}

class _DocEditWidgetState extends State<DocEditWidget> {
  final UserUpdateController _userUpdateController = Get.find();
  final UserController _userController = Get.find();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  final sController = TextEditingController();
  File _image;
  ImagePicker imagePicker = ImagePicker();

  Future<void> _getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: imageSource);

      if (pickedFile != null) {
        final croppedImage = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          cropStyle: CropStyle.rectangle,
          aspectRatio: CropAspectRatio(ratioX: 1.1, ratioY: 1.1),
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "",
            showCropGrid: true,
            toolbarColor: _isDark ? Colors.grey.shade600 : Colors.white,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            backgroundColor: Colors.black,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: "",
            aspectRatioLockEnabled: true,
          ),
        );
        if (croppedImage != null) {
          setState(() {
            final croppedFile = File(croppedImage.path);
            _image = croppedFile;
            print("Image Path===>${_image.path}");
          });
        }
      }
    } catch (e) {
      print("Error picking/cropping image: $e");
    }
  }

  String dropdownValuesState;
  List categoryItemListState = [];
  String dropdownValuesCity;
  List categoryItemListCity = [];
  String categoryOfMedicalCenterDropDown;
  List categoryOfMedicalCenter = [];
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  bool stateLoader = false;
  Future getStates() async {
    setState(() {
      stateLoader = true;
    });
    http.Response response = await http.get(
      Uri.parse('${Constants.baseUrl + Constants.getAllStates}'),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      setState(() {
        categoryItemListState = result;

        categoryItemListState.forEach((element) {
          if (element['id'].toString() == _userUpdateController.getStateId) {
            dropdownValuesState = element['name'];
            getMedicalCenter(location: element['name']);
            getCities(stateId: element['id']);
          }
        });
        stateLoader = false;
      });

      return result;
    } else {
      setState(() {
        stateLoader = false;
      });
    }
  }

  bool cityLoader = false;
  Future getCities({String stateId}) async {
    setState(() {
      cityLoader = true;
    });
    http.Response response = await http.get(
      Uri.parse(
          '${Constants.baseUrl + Constants.getAllCityByState}/${_userUpdateController.getStateId ?? stateId}'),
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      categoryItemListCity = result;
      categoryItemListCity.forEach((element) {
        if (element['id'].toString() == _userUpdateController.getCityId) {
          dropdownValuesCity = element['name'];
        }
      });
      cityLoader = false;
      setState(() {});

      return result;
    } else {
      setState(() {
        cityLoader = false;
      });
    }
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please Enter Mobile number';
    } else if (value.length != 10) {
      return 'Mobile Number Should be 10 Digit';
    } else if (!regExp.hasMatch(value)) {
      return 'Please Enter Valid Mobile Number';
    }
    return null;
  }

  initName() {
    dropdownValuesState = _userController.user.value.stateName;
    dropdownValuesCity = _userController.user.value.cityName;
    categoryOfMedicalCenterDropDown =
        _userController.user.value.medicalCenterName;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initName();
    getStates();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
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
                              child: Image.file(_image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight),
                            ),
                            Positioned.fill(
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
                                _userController.user?.value?.socialProfilePic ??
                                    _userController.user?.value?.profilePic ??
                                    ""),
                            onBackgroundImageError: (context, error) {
                              return Container();
                            },
                            child: Stack(
                              children: [
                                ClipOval(
                                  clipBehavior: Clip.hardEdge,
                                  child: OctoImage(
                                      image: CachedNetworkImageProvider(
                                          _userController
                                                  .user?.value?.profilePic ??
                                              _userController.user?.value
                                                  ?.socialProfilePic ??
                                              ""),
                                      // placeholderBuilder:
                                      //     OctoPlaceholder.blurHash(
                                      //         'LEHV6nWB2yk8pyo0adR*.7kCMdnj'
                                      //         // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                                      //         ),
                                      progressIndicatorBuilder:
                                          (context, progress) {
                                        double? value;
                                        var expectedBytes =
                                            progress?.expectedTotalBytes;
                                        if (progress != null &&
                                            expectedBytes != null) {
                                          value =
                                              progress.cumulativeBytesLoaded /
                                                  expectedBytes;
                                        }
                                        return CircularProgressIndicator(
                                            value: value);
                                      },
                                      errorBuilder: OctoError.circleAvatar(
                                        backgroundColor: Colors.white,
                                        text: Image.network(
                                          'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                                          color: Color(0xFF7E7D7D),
                                          // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                                        ),
                                      ),
                                      fit: BoxFit.fill,
                                      height: Get.height,
                                      width: Get.height),
                                ),
                                Center(
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  Translate.of(context).translate('Profile Picture'),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "${Translate.of(context).translate('first_name_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                hintText: '${_userController.user.value.firstName}',
                controller: _userUpdateController.firstNameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter First Name';
                  }
                },
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('last_name_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                hintText: '${_userController.user.value.lastName}',
                controller: _userUpdateController.lastNameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Last Name';
                  }
                },
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('contact_number_dot')} *",
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
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('email_dot')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                hintText: '${_userController.user.value.email}',
                enabled: false,
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('date_of_birth_dot')} *",
                style: kInputTextStyle,
              ),
              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.all(0),
                  // title: Text(_userController.dateOfBirth.value),
                  title: _userUpdateController.dateOfBirth.value.isEmpty ?? true
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tap to Select BirthDate",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            DateFormat('EEEE, dd MMMM, yyyy').format(
                              DateTime.parse(_userUpdateController
                                      .dateOfBirth.value) ??
                                  DateTime.now(),
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((DateTime value) {
                      if (value != null) {
                        _userUpdateController.onDateOfBirth(value.toString());
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('gender_dot')} *",
                style: kInputTextStyle,
              ),
              Obx(() {
                print('GenderDropDown:${_userUpdateController.genderItems}');
                print('Gender:${_userController.user.value.gender}');

                return DropdownButtonFormField(
                  validator: (value) =>
                      value == null ? 'Please Select Gender' : null,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).textTheme.subtitle1.color,
                  ),
                  isExpanded: true,
                  value: _userUpdateController.selectedGender.value.isEmpty
                      ? null
                      : _userUpdateController.selectedGender.value,
                  hint: Text(
                    Translate.of(context).translate('add_gender'),
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xffbcbcbc),
                      fontFamily: 'NunitoSans',
                    ),
                  ),
                  onChanged: _userUpdateController.onChangeGender,
                  items: _userUpdateController.dropDownGender,
                );
              }),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('Certificate No.')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                controller: _userUpdateController.certificateNoController,
                // keyboardType: TextInputType.number,
                hintText: Translate.of(context).translate(
                    _userController.user.value.certificateNo ??
                        "Enter certificate number"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Certificate Number';
                  }
                },
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('Per Appointment Charge')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller:
                    _userUpdateController.perAppointmentChargeController,
                hintText:
                    '${_userController.user.value.perAppointmentCharge ?? "Enter appointment charge"}',
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Enter Appointment Charges';
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${Translate.of(context).translate('Speciality')} *",
                style: kInputTextStyle,
              ),
              Obx(() {
                return DropdownButtonFormField(
                  validator: (value) =>
                      value == null ? 'Please Select Speciality' : null,
                  isExpanded: true,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).textTheme.subtitle1.color,
                  ),
                  value:
                      _userUpdateController?.speciality?.value?.isEmpty ?? true
                          ? null
                          : _userUpdateController.speciality.value,
                  hint: Text(
                    Translate.of(context).translate('Add Speciality'),
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xffbcbcbc),
                      fontFamily: 'NunitoSans',
                    ),
                  ),
                  onChanged: _userUpdateController.onChangeSpeciality,
                  items: _userUpdateController?.dropDownSpeciality ?? [],
                );
              }),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('Education')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                // keyboardType: TextInputType.number,
                validator: (value) =>
                    value.isEmpty ? 'Please insert a valid Education' : null,
                controller: _userUpdateController.educationController,
                hintText: Translate.of(context).translate(
                    _userController.user.value.education ?? "Enter education"),
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('Provider Type')} *",
                style: kInputTextStyle,
              ),
              CustomTextFormField(
                focusNode: FocusNode(),
                textInputAction: TextInputAction.next,
                controller: _userUpdateController.providerTypeController,
                hintText:
                    Translate.of(context).translate('Enter Provider Type'),
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Please insert a Provider Type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              Text(
                "${Translate.of(context).translate('State')} *",
                style: kInputTextStyle,
              ),
              SizedBox(
                height: 15,
              ),
              dropDownView(
                category: "s",
                colorCon: categoryItemListState == null ||
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
                "${Translate.of(context).translate('city')} *",
                style: kInputTextStyle,
              ),
              SizedBox(
                height: 15,
              ),
              dropDownView(
                category: "c",
                colorCon: categoryItemListCity == null ||
                    categoryItemListCity.isEmpty,
                textStyleCon: categoryItemListCity == null ||
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
              Text(
                "${Translate.of(context).translate('Medical Center')} *",
                style: kInputTextStyle,
              ),
              SizedBox(
                height: 15,
              ),
              dropDownView(
                category: 'm',
                colorCon: categoryOfMedicalCenter == null ||
                    categoryOfMedicalCenter.isEmpty,
                textStyleCon: categoryOfMedicalCenterDropDown == null,
                text: categoryOfMedicalCenterDropDown != null
                    ? '$categoryOfMedicalCenterDropDown'
                    : 'Select Medical Center',
                onTap: () {
                  if (categoryOfMedicalCenter.isNotEmpty) {
                    selectStateCity(category: 'm', h: h, w: w);
                  }
                },
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: RoundedLoadingButton(
                  color: kColorBlue,
                  valueColor: Colors.white,
                  successColor: Colors.white,
                  child: Text('Update Profile',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  controller: _btnController,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if ((_userUpdateController.dateOfBirth.value.isEmpty) &&
                          categoryOfMedicalCenterDropDown == null &&
                          dropdownValuesCity == null &&
                          dropdownValuesState == null) {
                        _btnController.reset();
                        Utils.showSnackBar(
                            'Warning', "Please fill doctor all details");
                      } else if ((_userUpdateController
                          .dateOfBirth.value.isEmpty)) {
                        Utils.showSnackBar(
                            'Warning', "Please fill date of birth");
                      } else if (dropdownValuesState == null) {
                        Utils.showSnackBar('Warning', "Please select state");
                      } else if (dropdownValuesCity == null) {
                        Utils.showSnackBar('Warning', "Please select city");
                      } else if (categoryOfMedicalCenterDropDown == null) {
                        Utils.showSnackBar(
                            'Warning', "Please select medical center");
                      } else {
                        _btnController.start();
                        await _userUpdateController.userProfileUpdate(
                            userProfilePic: _image, userType: "2");

                        _userUpdateController.editProfile();
                        _btnController.reset();
                      }
                    } else {
                      _userUpdateController.dScrollController.jumpTo(0);
                    }
                    _btnController.reset();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  selectStateCity({double h, double w, bool state, String category}) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
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
                                      decoration: InputDecoration(
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
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (category == "m") {
                                    Navigator.pop(context,
                                        categoryOfMedicalCenterDropDown);
                                  } else if (state) {
                                    Navigator.pop(context, dropdownValuesState);
                                  } else {
                                    Navigator.pop(context, dropdownValuesCity);
                                  }

                                  sController.clear();
                                },
                                icon: Icon(
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
                                int index = category == "m"
                                    ? categoryOfMedicalCenter.indexWhere(
                                        (element) => element['post_title']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase()))
                                    : state
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
                                                .contains(sController.text.toString().toLowerCase()));
                                if (index < 0) {
                                  return Center(
                                    child: Text(
                                      category == "m"
                                          ? 'No Medical Centers !'
                                          : state
                                              ? 'No States !'
                                              : 'No City !',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: category == "m"
                                      ? categoryOfMedicalCenter.length
                                      : state
                                          ? categoryItemListState.length
                                          : categoryItemListCity.length,
                                  itemBuilder: (context, index) {
                                    if (category == "m"
                                        ? categoryOfMedicalCenter[index]
                                                ['post_title']
                                            .toString()
                                            .toLowerCase()
                                            .contains(sController.text
                                                .toString()
                                                .toLowerCase())
                                        : state
                                            ? categoryItemListState[index]
                                                    ['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(sController.text
                                                    .toString()
                                                    .toLowerCase())
                                            : categoryItemListCity[index]
                                                    ['name']
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
                                              category == "m"
                                                  ? "${categoryOfMedicalCenter[index]['post_title'].toString()}"
                                                  : state
                                                      ? "${categoryItemListState[index]['name'].toString()}"
                                                      : "${categoryItemListCity[index]['name'].toString()}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .color,
                                              ),
                                            ),
                                            onTap: () async {
                                              if (category == "m") {
                                                Navigator.pop(
                                                    context,
                                                    categoryOfMedicalCenter[
                                                            index]['post_title']
                                                        .toString());

                                                _userUpdateController
                                                        .getMedicalCenterId =
                                                    categoryOfMedicalCenter[
                                                            index]['ID']
                                                        .toString();

                                                categoryOfMedicalCenterDropDown =
                                                    categoryOfMedicalCenter[
                                                        index]['post_title'];

                                                setState(() {});
                                              } else if (state) {
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
                                                print('drop');
                                                print(
                                                    '====iddddddddd${_userUpdateController.getStateId}');
                                                _userUpdateController
                                                    .getCityId = null;
                                                dropdownValuesCity = null;
                                                categoryItemListCity = [];
                                                await getCities(
                                                    stateId:
                                                        _userUpdateController
                                                            .getStateId);
                                                // await getMedicalCenter(
                                                //     location:
                                                //         categoryItemListState[
                                                //             index]['name']);
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
                                          Divider(
                                            height: 0,
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
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
      if (category == "m") {
        categoryOfMedicalCenterDropDown = value;
        setState(() {});
      } else if (state) {
        dropdownValuesState = value;
        setState(() {});
      } else {
        dropdownValuesCity = value;
        setState(() {});
      }
    });
  }

  bool medicalCenterLoader = false;
  Future getMedicalCenter({String location}) async {
    setState(() {
      medicalCenterLoader = true;
    });

    String url;
    url = '${Constants.medicalCenterURL}listar/v1/active-centres';

    Map<String, String> header = {"Content-Type": "application/json"};

    http.Response response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      setState(() {
        categoryOfMedicalCenter = result['data']['locations'];
        log('_userUpdateController.getMedicalCenterId==========>>>>>${_userUpdateController.getMedicalCenterId}');
        categoryOfMedicalCenter.forEach((element) {
          log('elem==========>>>>>${element['ID']}');
          if (element['ID'].toString() ==
              _userUpdateController.getMedicalCenterId) {
            categoryOfMedicalCenterDropDown = element['post_title'];
          }
        });
        medicalCenterLoader = false;
      });
      return result;
    } else {
      setState(() {
        medicalCenterLoader = false;
      });
    }
  }

  Widget dropDownView({
    void Function() onTap,
    String text,
    String category,
    bool textStyleCon,
    bool colorCon,
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
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleCon
                        ? TextStyle(
                            fontSize: 22,
                            color: Color(0xffbcbcbc),
                            fontFamily: 'NunitoSans',
                          )
                        : TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).textTheme.subtitle1.color,
                          ),
                  ),
                ),
                (category == 'm' && medicalCenterLoader == true) ||
                        (category == 'c' && cityLoader == true) ||
                        (category == 's' && stateLoader == true)
                    ? Container(
                        height: 20,
                        width: 20,
                        // child: CircularProgressIndicator(
                        //   strokeWidth: 1,
                        // ),
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
            SizedBox(
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

  static Widget commonContainer({Widget child}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.transparent,
        // border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
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
                leading: Icon(
                  Icons.camera,
                  size: 20,
                ),
                title: Text(
                  Translate.of(context).translate('take_a_photo'),
                  style: TextStyle(
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
                leading: Icon(
                  Icons.photo_library,
                  size: 20,
                ),
                title: Text(
                  Translate.of(context).translate('choose_a_photo'),
                  style: TextStyle(
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
}
