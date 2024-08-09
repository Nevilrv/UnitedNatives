import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookAppointmentTab extends StatefulWidget {
  const BookAppointmentTab({super.key});

  @override
  State<BookAppointmentTab> createState() => _BookAppointmentTabState();
}

class _BookAppointmentTabState extends State<BookAppointmentTab> {
  final BookAppointmentController _bookAppointmentController =
      Get.put(BookAppointmentController());

  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final searchController = TextEditingController();
  List categoryOfStatess = [];
  String? chooseStateId;

  String stateName = '';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w > 550 ? 70 : 20),
      child: GetBuilder<BookAppointmentController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  Translate.of(context)!.translate('choose_health_center'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
            ),

            /// SELECT STATES - DON'T _ DELETE
            // GestureDetector(
            //   onTap: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return StatefulBuilder(
            //           builder: (context, setState234) {
            //             return WillPopScope(
            //               onWillPop: () async {
            //                 return false;
            //               },
            //               child: Dialog(
            //                 backgroundColor: Colors.transparent,
            //                 child: ConstrainedBox(
            //                   constraints: BoxConstraints(
            //                     maxHeight:
            //                         MediaQuery.of(context).size.height *
            //                             0.55,
            //                   ),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       color: _isDark
            //                           ? Colors.grey.shade800
            //                           : Colors.white,
            //                       borderRadius: BorderRadius.circular(5),
            //                     ),
            //                     height: MediaQuery.of(context).size.height *
            //                         0.55,
            //                     width: MediaQuery.of(context).size.width *
            //                         0.85,
            //                     child: Padding(
            //                       padding: EdgeInsets.only(
            //                         top:
            //                             MediaQuery.of(context).size.height *
            //                                 0.015,
            //                         left:
            //                             MediaQuery.of(context).size.height *
            //                                 0.015,
            //                         right:
            //                             MediaQuery.of(context).size.height *
            //                                 0.015,
            //                         bottom: 0,
            //                       ),
            //                       child: Column(
            //                         children: [
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               Expanded(
            //                                 child: Container(
            //                                   decoration: BoxDecoration(
            //                                     color: _isDark
            //                                         ? Colors.grey.shade800
            //                                         : Colors.white,
            //                                     borderRadius:
            //                                         BorderRadius.circular(
            //                                             25),
            //                                     border: Border.all(
            //                                         color: Colors.grey),
            //                                   ),
            //                                   height: MediaQuery.of(context)
            //                                           .size
            //                                           .height *
            //                                       0.045,
            //                                   child: Center(
            //                                     child: TextField(
            //                                       controller:
            //                                           searchController,
            //                                       onChanged: (value) {
            //                                         setState234(() {});
            //                                       },
            //                                       decoration:
            //                                           InputDecoration(
            //                                         contentPadding:
            //                                             EdgeInsets.only(
            //                                                 top: h * 0.004,
            //                                                 left: w * 0.04),
            //                                         suffixIcon:
            //                                             Icon(Icons.search),
            //                                         enabledBorder:
            //                                             InputBorder.none,
            //                                         focusedBorder:
            //                                             InputBorder.none,
            //                                         hintText: 'Search...',
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 15,
            //                               ),
            //                               GestureDetector(
            //                                 onTap: () {
            //                                   Navigator.pop(
            //                                       context, stateName);
            //
            //                                   searchController.clear();
            //                                 },
            //                                 child: Icon(
            //                                   Icons.clear,
            //                                   color: Colors.black,
            //                                   size: 28,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           SizedBox(
            //                             height: MediaQuery.of(context)
            //                                     .size
            //                                     .height *
            //                                 0.01,
            //                           ),
            //                           Expanded(
            //                             child: Builder(
            //                               builder: (context) {
            //                                 int index = categoryOfStatess
            //                                     .indexWhere((element) =>
            //                                         element['name']
            //                                             .toString()
            //                                             .toLowerCase()
            //                                             .contains(
            //                                                 searchController
            //                                                     .text
            //                                                     .toString()
            //                                                     .toLowerCase()));
            //                                 if (index < 0) {
            //                                   return Center(
            //                                     child: Text(
            //                                       'No States !',
            //                                       style: TextStyle(
            //                                         color: _isDark
            //                                             ? Colors
            //                                                 .grey.shade800
            //                                             : Colors.white,
            //                                         fontSize: 16,
            //                                         fontWeight:
            //                                             FontWeight.w400,
            //                                       ),
            //                                     ),
            //                                   );
            //                                 }
            //
            //                                 return ListView.builder(
            //                                   padding: EdgeInsets.zero,
            //                                   physics:
            //                                       const BouncingScrollPhysics(),
            //                                   shrinkWrap: true,
            //                                   itemCount:
            //                                       categoryOfStatess.length,
            //                                   itemBuilder:
            //                                       (context, index) {
            //                                     if (categoryOfStatess[index]
            //                                             ['name']
            //                                         .toString()
            //                                         .toLowerCase()
            //                                         .contains(searchController
            //                                             .text
            //                                             .toString()
            //                                             .toLowerCase())) {
            //                                       return Column(
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment
            //                                                 .start,
            //                                         children: [
            //                                           InkWell(
            //                                             onTap: () async {
            //                                               Navigator.pop(
            //                                                   context,
            //                                                   "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})" ??
            //                                                       "");
            //                                               chooseStateId =
            //                                                   categoryOfStatess[
            //                                                           index]
            //                                                       ['id'];
            //
            //                                               controller
            //                                                   .medicalName = '';
            //                                               controller
            //                                                       .chooseMedicalCenter =
            //                                                   null;
            //                                               controller
            //                                                       .categoryOfMedicalCenterDropDowns =
            //                                                   null;
            //                                               print('drop');
            //                                               controller
            //                                                   .categoryOfMedicalCenter = [];
            //
            //                                               await _bookAppointmentController
            //                                                   .getSpecialities(
            //                                                       false.obs,
            //                                                       stateId: chooseStateId ==
            //                                                               '0'
            //                                                           ? ''
            //                                                           : chooseStateId ??
            //                                                               '');
            //                                             },
            //                                             child: Padding(
            //                                               padding:
            //                                                   const EdgeInsets
            //                                                           .symmetric(
            //                                                       vertical:
            //                                                           5),
            //                                               child: SizedBox(
            //                                                 width: double
            //                                                     .infinity,
            //                                                 height: 50,
            //                                                 child: Align(
            //                                                   alignment:
            //                                                       Alignment
            //                                                           .centerLeft,
            //                                                   child: Text(
            //                                                     "${categoryOfStatess[index]['name'].toString()} (${categoryOfStatess[index]['doctors_count'].toString()})",
            //                                                     style: TextStyle(
            //                                                         fontWeight:
            //                                                             FontWeight
            //                                                                 .w600,
            //                                                         color: Theme.of(context)
            //                                                             .textTheme
            //                                                             .subtitle1
            //                                                             .color,
            //                                                         fontSize:
            //                                                             17),
            //                                                   ),
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                           ),
            //                                           const Divider(
            //                                               height: 0)
            //                                         ],
            //                                       );
            //                                     } else {
            //                                       return SizedBox();
            //                                     }
            //                                   },
            //                                 );
            //                               },
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       },
            //     ).then(
            //       (value) async {
            //         stateName = value;
            //         await  controller.getMedicalCenter(stateName: stateName);
            //         setState(() {});
            //       },
            //     );
            //   },
            //   child: commonContainer(
            //     child: Padding(
            //       padding: EdgeInsets.only(left: 20, right: 12),
            //       child: Row(
            //         children: [
            //           Text(
            //             stateName == "" ? 'Select State' : '$stateName',
            //             style: TextStyle(
            //               fontSize: 18,
            //             ),
            //           ),
            //           const Spacer(),
            //           Icon(
            //             Icons.arrow_drop_down,
            //             color:
            //                 !_isDark ? Colors.grey.shade800 : Colors.white,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),

            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (controller.categoryOfMedicalCenter.isNotEmpty) {
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
                                  maxHeight: h * 0.55,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: _isDark
                                          ? Colors.grey.shade800
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: h * 0.55,
                                  width: w * 0.85,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: h * 0.015,
                                      left: h * 0.015,
                                      right: h * 0.015,
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
                                                    controller:
                                                        searchController,
                                                    onChanged: (value) {
                                                      setState234(() {});
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    left: 16),
                                                            suffixIcon:
                                                                Icon(Icons
                                                                    .search),
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText:
                                                                'Search...'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context,
                                                    controller.medicalName);
                                                searchController.clear();
                                              },
                                              child: const Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              int index = controller
                                                  .categoryOfMedicalCenter
                                                  .indexWhere((element) =>
                                                      element['post_title']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                              searchController
                                                                  .text
                                                                  .toString()
                                                                  .toLowerCase()));
                                              if (index < 0) {
                                                return const Center(
                                                  child: Text(
                                                    'No Medical Center !',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller
                                                    .categoryOfMedicalCenter
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return controller
                                                          .categoryOfMedicalCenter[
                                                              index]
                                                              ['post_title']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                              searchController
                                                                  .text
                                                                  .toString()
                                                                  .toLowerCase())
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                searchController
                                                                    .clear();
                                                                controller
                                                                    .setMedicalCenterId(
                                                                  controller
                                                                      .categoryOfMedicalCenter[
                                                                          index]
                                                                          ['ID']
                                                                      .toString(),
                                                                  controller
                                                                      .categoryOfMedicalCenter[
                                                                          index]
                                                                          [
                                                                          'post_title']
                                                                      .toString(),
                                                                  controller
                                                                      .categoryOfMedicalCenter[
                                                                          index]
                                                                          [
                                                                          'google_form_url']
                                                                      .toString(),
                                                                );
                                                                // await _bookAppointmentController.getSpecialities(false.obs,stateId: chooseStateId ?? "",medicalCenterId: controller.chooseMedicalCenter ?? '');
                                                                await _bookAppointmentController.getDoctorSpecialities(
                                                                    "", context,
                                                                    stateId:
                                                                        chooseStateId ??
                                                                            "",
                                                                    medicalCenterId:
                                                                        controller.chooseMedicalCenter ??
                                                                            '');
                                                              },
                                                              title: Text(
                                                                controller
                                                                    .categoryOfMedicalCenter[
                                                                        index][
                                                                        'post_title']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleMedium
                                                                        ?.color,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                            const Divider(
                                                                height: 0),
                                                          ],
                                                        )
                                                      : const SizedBox();
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
                } else if (_bookAppointmentController.medicalLoader.value ==
                    true) {
                  Get.showSnackbar(
                    const GetSnackBar(
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 2),
                      messageText: Text(
                        'Please wait...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  Get.showSnackbar(
                    const GetSnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      messageText: Text(
                        'No medical centers available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              child: commonContainer(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.medicalName == ""
                              ? 'Select Medical Center'
                              : controller.medicalName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: controller.medicalName != ""
                                  ? !_isDark
                                      ? Colors.grey.shade800
                                      : Colors.white
                                  : Colors.grey),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: controller.categoryOfMedicalCenter.isEmpty
                              ? Colors.grey
                              : !_isDark
                                  ? Colors.grey.shade800
                                  : Colors.white)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // RadioListTile(
            //   title: Text('Indigenous Health'),
            //   groupValue: controller.ihOrNatives,
            //   value: 0,
            //   onChanged: (value) {
            //     controller.changeValue(value);
            //     setState(() {});
            //   },
            // ),
            // RadioListTile(
            //   title: Text('United Natives'),
            //   groupValue: controller.ihOrNatives,
            //   value: 1,
            //   onChanged: (value) {
            //     controller.changeValue(value);
            //     setState(() {});
            //   },
            // ),

            const SizedBox(height: 10),

            // Obx(
            //   () => Container(
            //     height: 500,
            //     width: Get.width,
            //     child: StaggeredGridView
            //         .countBuilder(
            //       padding: EdgeInsets.symmetric(
            //           horizontal: 10),
            //       crossAxisCount: 1,
            //       physics:
            //           NeverScrollableScrollPhysics(),
            //       shrinkWrap: true,
            //       itemCount:
            //           _bookAppointmentController
            //                   .specialitiesModelData
            //                   .value
            //                   .specialities
            //                   ?.length ??
            //               0,
            //       staggeredTileBuilder:
            //           (int index) =>
            //               StaggeredTile.fit(2),
            //       mainAxisSpacing: 10,
            //       crossAxisSpacing: 10,
            //       itemBuilder:
            //           (context, index) {
            //         // return HealthConcernItem(
            //         //   specialityName: _bookAppointmentController.specialitiesModelData.value.specialities[index].specialityName,
            //         //   // healthCategory: _bookAppointmentController.specialitiesModelData.value.specialities[index],
            //         //   onTap: () {
            //         //     Navigator.of(context).pushNamed(Routes.bookingStep2);
            //         //   },
            //         // );
            //         return Card(
            //           child: InkWell(
            //             onTap: () {
            //               print('demo....');
            //               // Navigator.of(context)
            //               //     .pushNamed(Routes.bookingStep2);
            //
            //               Get.toNamed(
            //                   Routes
            //                       .bookingStep2,
            //                   arguments:
            //                       '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${chooseMedicalCenter ?? ""}');
            //             },
            //             borderRadius:
            //                 BorderRadius
            //                     .circular(4),
            //             child: Padding(
            //               padding: EdgeInsets
            //                   .symmetric(
            //                       horizontal:
            //                           10,
            //                       vertical: 15),
            //               child: Row(
            //                 children: <Widget>[
            //                   CircleAvatar(
            //                     backgroundColor:
            //                         Colors.grey[
            //                             300],
            //                     backgroundImage:
            //                         NetworkImage(
            //                                 "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityIcon}") ??
            //                             AssetImage(
            //                                 'assets/images/medicine.png'),
            //                     radius: 25,
            //                   ),
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Expanded(
            //                     child: Text(
            //                       "${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName} (${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.doctorsCount})" ??
            //                           Translate.of(context)
            //                                   .translate('Women\'s Health') +
            //                               '\n',
            //                       maxLines: 2,
            //                       overflow:
            //                           TextOverflow
            //                               .ellipsis,
            //                       style:
            //                           TextStyle(
            //                         fontSize:
            //                             16,
            //                       ),
            //                     ),
            //                   ),
            //                   GestureDetector(
            //                     onTap: () {
            //                       setState(() {
            //                         selected =
            //                             index;
            //                       });
            //                     },
            //                     child: Checkbox(
            //                         value: _bookAppointmentController
            //                             .specialitiesModelData
            //                             .value
            //                             .specialities[
            //                                 index]
            //                             ?.isCheckedBox,
            //                         onChanged:
            //                             (value) {
            //                           setState(
            //                               () {
            //                             _bookAppointmentController
            //                                 .specialitiesModelData
            //                                 .value
            //                                 .specialities
            //                                 .forEach((element) {
            //                               element.isCheckedBox =
            //                                   false;
            //                             });
            //
            //                             _bookAppointmentController
            //                                 .specialitiesModelData
            //                                 .value
            //                                 .specialities[index]
            //                                 ?.isCheckedBox = value;
            //                             setState1(
            //                                 () {});
            //                             print(
            //                                 '-=-=-=-=-${_bookAppointmentController.specialitiesModelData.value.specialities[index]?.specialityName}');
            //                           });
            //                         }),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            Card(
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.bookingStep2,
                      arguments:
                          ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}');
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            const AssetImage('assets/images/medicine.png'),
                        radius: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          '${Translate.of(context)?.translate('Provider')}(${_bookAppointmentController.doctorCount.toString()})',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(w > 550 ? w * 0.55 : w * 0.7, 55),
              ),
              onPressed: () async {
                // int index = _bookAppointmentController
                //     .specialitiesModelData.value.specialities
                //     .indexWhere((element) => element.isCheckedBox == true);

                Get.toNamed(
                  Routes.bookingStep2,
                  arguments: /*index < 0
                      ?*/
                      ',${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ''}' /*: '${_bookAppointmentController.specialitiesModelData.value.specialities[index].id ?? ""},${chooseStateId ?? ""},${controller.chooseMedicalCenter ?? ""}'*/,
                );

                // Navigator.pop(context);
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  static Container commonContainer({Widget? child}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }
}
