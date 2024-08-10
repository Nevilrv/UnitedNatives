import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/viewModel/get_city_view_model.dart';
import 'package:united_natives/viewModel/get_states_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:octo_image/octo_image.dart';

import 'profile_info_tile.dart';

class DocInfoWidget extends StatefulWidget {
  const DocInfoWidget({super.key});

  @override
  State<DocInfoWidget> createState() => _DocInfoWidgetState();
}

class _DocInfoWidgetState extends State<DocInfoWidget> {
  final UserController _userController = Get.find();
  final GetCitiesViewModel getCitiesViewModel = Get.put(GetCitiesViewModel());

  final GetStatesViewModel getStatesViewModel = Get.put(GetStatesViewModel());
  String cityName = '';

  String stateName = '';

  String stateID = '';

  String medicalCenterName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getStateCityData();
    });

    super.initState();
  }

  getStateCityData() async {
    await getStatesViewModel.getStatesViewModel();
    getMedicalCenter();
    List<GetStatesResponseModel> data =
        getStatesViewModel.getStatesApiResponse.data;
    for (var element in data) {
      if (element.id.toString() ==
          _userController.user.value.state.toString()) {
        stateName = element.name!;
        stateID = element.id!;
        setState(() {});
      }
    }
    await getCitiesViewModel.getCitiesViewModel(stateId: stateID);
    List<GetCityResponseModel> data1 =
        getCitiesViewModel.getCitiesApiResponse.data;
    for (var e1 in data1) {
      if (e1.id.toString() == _userController.user.value.city.toString()) {
        cityName = e1.name!;
        setState(() {});
      }
    }
  }

  Future getMedicalCenter() async {
    String url = '${Constants.medicalCenterURL}listar/v1/active-centres';
    Map<String, String> header = {"Content-Type": "application/json"};
    http.Response response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      result['data']['locations'].forEach(
        (element) {
          if (element['ID'].toString() ==
              _userController.user.value.medicalCenterID.toString()) {
            medicalCenterName = element['post_title'];
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            Translate.of(context)!.translate('name_dot'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            '${_userController.user.value.firstName} ${_userController.user.value.lastName}',
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),
          ),
          trailing: Obx(
            () => CircleAvatar(
              radius: 25,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: CachedNetworkImageProvider(
                      _userController.user.value.profilePic ??
                          _userController.user.value.socialProfilePic ??
                          ''),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),
                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },
                  errorBuilder: OctoError.circleAvatar(
                    backgroundColor: Colors.white,
                    text: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                      color: const Color(0xFF7E7D7D),
                      // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                    ),
                  ),
                  fit: BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
              // backgroundColor: Colors.grey,
              // backgroundImage: NetworkImage(
              //     _userController.user?.value?.profilePic ??
              //         _userController?.authResult?.user?.photoURL ??
              //         ''),
              // onBackgroundImageError: (context, e) {
              //   return Container();
              // },
            ),
          ),
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[200],
          indent: 15,
          endIndent: 15,
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('contact_number'),
          trailing: _userController.user.value.contactNumber ??
              "Enter Contact Number",
          hint: 'Add phone number',
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('email'),
          trailing: _userController.user.value.email ?? "Enter Email",
          hint: Translate.of(context)!.translate('add_email'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Date of Birth'),
          trailing: _userController.user.value.dateOfBirth ?? "Date of Birth",
          hint: Translate.of(context)!.translate('Date of Birth'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('gender'),
          trailing: Translate.of(context)!
              .translate(_userController.user.value.gender.toString()),
          hint: Translate.of(context)!.translate('add_gender'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Certificate No.'),
          trailing: _userController.user.value.certificateNo ??
              "Enter Certificate Number",
          hint: Translate.of(context)!.translate('Enter your license no.'),
        ),
        ProfileInfoTile(
          title: 'Per Appointment Charge',
          trailing: _userController.user.value.perAppointmentCharge ??
              "Enter Per Appointment Charge",
          hint: '\$100',
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Speciality'),
          trailing: _userController.user.value.speciality ?? "Enter Speciality",
          hint: Translate.of(context)!.translate('add Speciality'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Education'),
          trailing: _userController.user.value.education ?? "Enter Education",
          hint: Translate.of(context)!.translate('add Education'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Provider Type'),
          trailing:
              _userController.user.value.providerType ?? "Enter Provider Type",
          hint: Translate.of(context)!.translate('Enter Provider Type'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('State'),
          trailing: stateName,
          hint: Translate.of(context)!.translate('State'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('City'),
          trailing: cityName.toLowerCase().capitalizeFirst ??
              _userController.user.value.city ??
              "Akhiok",
          hint: Translate.of(context)!.translate('State'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Medical Center'),
          trailing: medicalCenterName.toLowerCase().capitalizeFirst ??
              "United Natives LLC",
          hint: Translate.of(context)!.translate('Medical Center'),
        ),
      ],
    );
  }
}
