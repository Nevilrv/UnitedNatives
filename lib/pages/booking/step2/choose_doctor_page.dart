import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/progress_indicator.dart';
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/book_appointment_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/ResponseModel/doctor_by_specialities.dart';
import 'package:united_natives/pages/booking/filter/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../components/doctor_item.dart';
import '../../../components/round_icon_button.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';

class ChooseDoctorPage extends StatefulWidget {
  final String? id;

  const ChooseDoctorPage({super.key, this.id});

  @override
  State<ChooseDoctorPage> createState() => _ChooseDoctorPageState();
}

class _ChooseDoctorPageState extends State<ChooseDoctorPage> {
  final BookAppointmentController _bookAppointmentController =
      Get.find<BookAppointmentController>();

  DoctorBySpecialitiesModel? responseData;

  AdsController adsController = Get.find();
  List? idList;
  String? specialityId;
  String? stateId;
  String? medicalCenterId;

  @override
  void initState() {
    idList = widget.id?.split(',');
    specialityId = idList!.isNotEmpty ? idList![0] : "";
    stateId = idList!.length > 1 ? idList![1] : '';
    medicalCenterId = idList!.length > 2 ? idList![2] : '';
    getData();
    super.initState();
  }

  getData() async {
    await _bookAppointmentController
        .getDoctorSpecialities(specialityId!, context,
            stateId: stateId, medicalCenterId: medicalCenterId)
        .whenComplete(() {
      responseData =
          _bookAppointmentController.doctorBySpecialitiesModelData.value;
    });
    _bookAppointmentController.isLoading.value = false;
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<AdsController>(builder: (ads) {
          return Scaffold(
            bottomNavigationBar: AdsBottomBar(
              ads: ads,
              context: context,
            ),
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                Translate.of(context)!.translate('doctor'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Obx(
                  () => _bookAppointmentController.isFiltered.value
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilterPage(
                                  id: specialityId,
                                  medicalCenterIid: medicalCenterId,
                                ),
                              ),
                            );
                            // Get.toNamed(Routes.filter, arguments: specialityId);
                            // Navigator.of(context).pushNamed(Routes.filter);
                          },
                          icon: const Icon(
                            Icons.filter_list,
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            await getData();
                            // _bookAppointmentController.getDoctorSpecialities(
                            //   specialityId,
                            //   context,
                            //   stateId: stateId,
                            //   medicalCenterId: medicalCenterId,
                            // );
                            // _bookAppointmentController.getFilteredDoctor(widget.id, _userController.user.value.id, '${_availability.index}', _male == true ? 'male' : 'female', '${_consultationFee.index}');
                            // _bookAppointmentController.isFiltered.isFalse;
                            // Get.toNamed(Routes.filter, arguments: id);
                            // Navigator.of(context).pushNamed(Routes.filter);
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                )
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      Translate.of(context)!.translate('choose_a_doctor'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kColorBlue,
                    ),
                    child: Row(
                      children: <Widget>[
                        RoundIconButton(
                          onPressed: () {},
                          icon: Icons.person_pin,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          Translate.of(context)!
                              .translate('any_available_doctor'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20).copyWith(bottom: 20),
                    child: TextField(
                      controller: searchController,
                      autofillHints: const [AutofillHints.name],
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: kColorBlue, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[250],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                        hintText:
                            Translate.of(context)?.translate('search_messages'),
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 22),
                      ),
                      cursorWidth: 1,
                      maxLines: 1,
                    ),
                  ),
                  Obx(
                    () => _bookAppointmentController.isFiltered.value
                        ? Builder(
                            builder: (context) {
                              int? index1 = _bookAppointmentController
                                  .doctorBySpecialitiesModelData
                                  .value
                                  .doctorSpecialities
                                  ?.indexWhere((element) =>
                                      ("${element.firstName ?? "Dr."} ${element.lastName ?? "Lee"}")
                                          .toLowerCase()
                                          .trim()
                                          .contains(searchController.text
                                              .toLowerCase()
                                              .trim()));

                              if (index1! < 0 &&
                                  _bookAppointmentController
                                      .doctorBySpecialitiesModelData
                                      .value
                                      .doctorSpecialities!
                                      .isNotEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Provider not available !',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return Obx(
                                () => ListView.separated(
                                  separatorBuilder: (context, index) {
                                    String doctorName =
                                        "${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].firstName ?? "Dr."} ${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].lastName ?? "Lee"}";

                                    if (doctorName
                                        .toString()
                                        .toLowerCase()
                                        .trim()
                                        .contains(searchController.text
                                            .toString()
                                            .toLowerCase()
                                            .trim())) {
                                      return const Divider(
                                        height: 1,
                                        indent: 15,
                                        endIndent: 15,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _bookAppointmentController
                                          .doctorBySpecialitiesModelData
                                          .value
                                          .doctorSpecialities
                                          ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    String doctorName =
                                        "${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].firstName ?? "Dr."} ${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].lastName ?? "Lee"}";

                                    if (doctorName
                                        .toString()
                                        .toLowerCase()
                                        .trim()
                                        .contains(searchController.text
                                            .toString()
                                            .toLowerCase()
                                            .trim())) {
                                      return Obx(
                                        () => _bookAppointmentController
                                                .doctorBySpecialitiesModelData
                                                .value
                                                .doctorSpecialities!
                                                .isEmpty
                                            ? const SizedBox()
                                            : DoctorItem(
                                                doctorAvatar: _bookAppointmentController
                                                        .doctorBySpecialitiesModelData
                                                        .value
                                                        .doctorSpecialities?[
                                                            index]
                                                        .profilePic ??
                                                    "assets/images/Doctor_lee.png",
                                                doctorName: doctorName,
                                                doctorPrice: _bookAppointmentController
                                                        .doctorBySpecialitiesModelData
                                                        .value
                                                        .doctorSpecialities?[
                                                            index]
                                                        .perAppointmentCharge ??
                                                    "100",
                                                doctorSpeciality:
                                                    _bookAppointmentController
                                                            .doctorBySpecialitiesModelData
                                                            .value
                                                            .doctorSpecialities![
                                                                index]
                                                            .speciality ??
                                                        "",
                                                rating: _bookAppointmentController
                                                    .doctorBySpecialitiesModelData
                                                    .value
                                                    .doctorSpecialities![index]
                                                    .rating
                                                    .toString(),
                                                // onTap: () => Get.toNamed(Routes.bookingStep3, arguments: _bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities[index]),
                                                onTap: () {
                                                  _bookAppointmentController
                                                    ..selectedIndex.value = (-1)
                                                    ..items =
                                                        <Map<String, dynamic>>[]
                                                            .obs
                                                    ..getPatientAppointment(
                                                        _bookAppointmentController
                                                                .doctorBySpecialitiesModelData
                                                                .value
                                                                .doctorSpecialities?[
                                                                    index]
                                                                .userId ??
                                                            "",
                                                        context);
                                                  Get.toNamed(
                                                      Routes.bookingStep3,
                                                      arguments: _bookAppointmentController
                                                          .doctorBySpecialitiesModelData
                                                          .value
                                                          .doctorSpecialities?[index]);
                                                },
                                              ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              );
                            },
                          )
                        : Builder(builder: (context) {
                            int? index1 = _bookAppointmentController
                                .doctorBySpecialitiesModelData
                                .value
                                .doctorSpecialities
                                ?.indexWhere((element) =>
                                    ("${element.firstName ?? "Dr."} ${element.lastName ?? "Lee"}")
                                        .toLowerCase()
                                        .trim()
                                        .contains(searchController.text
                                            .toLowerCase()
                                            .trim()));

                            if (index1! < 0) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Provider not available !',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              separatorBuilder: (context, index) {
                                String doctorName =
                                    "${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].firstName ?? "Dr."} ${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].lastName ?? "Lee"}";

                                if (doctorName
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(searchController.text
                                        .toString()
                                        .toLowerCase()
                                        .trim())) {
                                  return const Divider(
                                    height: 1,
                                    indent: 15,
                                    endIndent: 15,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _bookAppointmentController
                                      .doctorBySpecialitiesModelData
                                      .value
                                      .doctorSpecialities
                                      ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                String doctorName =
                                    "${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].firstName ?? "Dr."} ${_bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities?[index].lastName ?? "Lee"}";

                                if (doctorName
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(searchController.text
                                        .toString()
                                        .toLowerCase()
                                        .trim())) {
                                  return Obx(
                                    () => _bookAppointmentController
                                            .doctorBySpecialitiesModelData
                                            .value
                                            .doctorSpecialities!
                                            .isEmpty
                                        ? const SizedBox()
                                        : DoctorItem(
                                            rating: "4.4",
                                            doctorAvatar: _bookAppointmentController
                                                    .doctorBySpecialitiesModelData
                                                    .value
                                                    .doctorSpecialities?[index]
                                                    .profilePic ??
                                                "assets/images/Doctor_lee.png",
                                            doctorName: doctorName,
                                            doctorPrice: _bookAppointmentController
                                                    .doctorBySpecialitiesModelData
                                                    .value
                                                    .doctorSpecialities?[index]
                                                    .perAppointmentCharge ??
                                                "100",
                                            doctorSpeciality:
                                                _bookAppointmentController
                                                        .doctorBySpecialitiesModelData
                                                        .value
                                                        .doctorSpecialities?[
                                                            index]
                                                        .speciality ??
                                                    "",

                                            // onTap: () => Get.toNamed(Routes.bookingStep3, arguments: _bookAppointmentController.doctorBySpecialitiesModelData.value.doctorSpecialities[index]),
                                            onTap: () {
                                              _bookAppointmentController
                                                ..selectedIndex.value = (-1)
                                                ..items =
                                                    <Map<String, dynamic>>[].obs
                                                ..getPatientAppointment(
                                                    _bookAppointmentController
                                                            .doctorBySpecialitiesModelData
                                                            .value
                                                            .doctorSpecialities?[
                                                                index]
                                                            .userId ??
                                                        "",
                                                    context);
                                              Get.toNamed(Routes.bookingStep3,
                                                  arguments: _bookAppointmentController
                                                      .doctorBySpecialitiesModelData
                                                      .value
                                                      .doctorSpecialities?[index]);
                                            }),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          }),
                  )
                ],
              ),
            ),
          );
        }),
        Obx(
          () => Container(
            child: _bookAppointmentController.isLoading.value
                ? const ProgressIndicatorScreen()
                : responseData?.doctorsCount == 0 ||
                        responseData?.doctorsCount == null
                    ? Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              // stateId == '' ? '' :
                              'Provider not available !',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : responseData?.doctorSpecialities != null ||
                            responseData!.doctorSpecialities!.isNotEmpty ||
                            (_bookAppointmentController.isFiltered.value !=
                                    false &&
                                _bookAppointmentController
                                    .doctorBySpecialitiesModelData
                                    .value
                                    .doctorSpecialities!
                                    .isNotEmpty)
                        ? responseData?.doctorsCount == 0 ||
                                _bookAppointmentController
                                    .doctorBySpecialitiesModelData
                                    .value
                                    .doctorSpecialities!
                                    .isEmpty
                            ? Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      // stateId == '' ? '' :
                                      'Provider not available !',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        : Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  // stateId == '' ? '' :
                                  'Provider not available !',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
          ),
        ),
      ],
    );
  }
}
