import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:developer';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_city_data.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_state_data.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/screens/home/home_sliver_app_bar.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/screens/search_history/search_history.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  StreamSubscription _submitSubscription;
  StreamSubscription _reviewSubscription;
  SearchHistoryDelegate _delegate;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final _discoveryCubit = DiscoveryCubit();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppBloc.homeCubit.onLoad();
      _discoveryCubit.onLoad();
      // AppBloc.discoveryCubit.onLoad();

      // if (AppBloc.filterCubit.selectedState == null) {
      AppBloc.filterCubit.onStateLoad();
      // }

      _submitSubscription = AppBloc.submitCubit.stream.listen((state) {
        if (state is Submitted) {
          AppBloc.homeCubit.onLoad();
        }
      });
      _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
        if (state is ReviewSuccess && state.id != null) {
          AppBloc.homeCubit.onLoad();
        }
      });
      _delegate = SearchHistoryDelegate();
    });

    d.log('jndi===========>');
    super.initState();
  }

  @override
  void dispose() {
    _submitSubscription.cancel();
    _reviewSubscription.cancel();
    super.dispose();
  }

  ///Refresh
  Future<void> _onRefresh() async {
    await AppBloc.homeCubit.onLoad();
  }

  ///On search
  void _onSearch() {
    print('searching');
    _onSearch1();
    // Navigator.pushNamed(context, Routes.searchHistory);
  }

  ///onShow search
  void _onSearch1() async {
    AppBloc.searchCubit.onClear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showSearch(
        context: context,
        delegate: _delegate,
      );
    });
  }

  ///On scan
  void _onScan() async {
    final result = await Navigator.pushNamed(context, Routes.scanQR);
    if (result != null) {
      final deeplink = DeepLinkModel.fromString(result as String);
      if (deeplink.target.isNotEmpty) {
        Navigator.pushNamed(
          context,
          Routes.deepLink,
          arguments: deeplink,
        );
      }
    }
  }

  ///On Filter
  void onFilter() async {
    CityModel oldCityName = AppBloc.filterCubit.selectedCity;
    StateModel oldStateName = AppBloc.filterCubit.selectedState;
    bool isApply = false;
    scaffoldKey.currentState
        .showBottomSheet((context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  // json.encode(stateList);
                  if (state is FilterLoading) {
                    return Utils.circular();
                  }
                  if (state is FilterSuccess) {
                    AppBloc.filterCubit.stateList = state.stateList;

                    AppBloc.filterCubit.cityList = state.cityList;
                  }
                  return Container(
                    padding: EdgeInsets.all(16),
                    color: _isDark ? Colors.black : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              AppBloc.filterCubit.selectedState = null;
                              AppBloc.filterCubit.selectedCity = null;
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ),
                        Text(
                          Translate.of(context).translate('State'),
                          style: kInputTextStyle,
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState234) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: Get.height * 0.6,
                                            maxWidth: 550),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _isDark
                                                ? Colors.grey.shade800
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          // height: Get.height * 0.6,
                                          // width: Get.width * 0.85,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: Get.height * 0.015,
                                              left: Get.height * 0.015,
                                              right: Get.height * 0.005,
                                              bottom: 0,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _isDark
                                                              ? Colors
                                                                  .grey.shade800
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        height: 48,
                                                        child: Center(
                                                          child: TextField(
                                                            controller:
                                                                searchController,
                                                            onChanged: (value) {
                                                              setState234(
                                                                  () {});
                                                            },
                                                            decoration: InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        top: 10,
                                                                        left:
                                                                            16),
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
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                        );
                                                        searchController
                                                            .clear();
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
                                                  height: Get.height * 0.01,
                                                ),
                                                Expanded(
                                                  child: Builder(
                                                      builder: (context) {
                                                    int index = AppBloc
                                                        .filterCubit.stateList
                                                        .indexWhere((element) => element
                                                            .name
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                                searchController
                                                                    .text
                                                                    .toString()
                                                                    .toLowerCase()));
                                                    if (index < 0) {
                                                      return Center(
                                                        child: Text(
                                                          'No States !',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: AppBloc
                                                          .filterCubit
                                                          .stateList
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (AppBloc
                                                            .filterCubit
                                                            .stateList[index]
                                                            .name
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                                searchController
                                                                    .text
                                                                    .toString()
                                                                    .toLowerCase())) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ListTile(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);

                                                                  AppBloc.filterCubit.onUpdateStateData(
                                                                      stateDataList: AppBloc
                                                                          .filterCubit
                                                                          .stateList,
                                                                      stateData: AppBloc
                                                                          .filterCubit
                                                                          .stateList[index]);

                                                                  String state =
                                                                      jsonEncode(AppBloc
                                                                          .filterCubit
                                                                          .stateList[index]);

                                                                  Prefs.setString(
                                                                      Prefs
                                                                          .stateFilter,
                                                                      state);
                                                                  // if (AppBloc
                                                                  //     .filterCubit
                                                                  //     .cityList
                                                                  //     .isNotEmpty) {
                                                                  //   AppBloc
                                                                  //       .filterCubit
                                                                  //       .cityList
                                                                  //       .clear();
                                                                  // }
                                                                  searchController
                                                                      .clear();
                                                                  setState(
                                                                      () {});
                                                                  await AppBloc.filterCubit.onCitiesLoad(
                                                                      stateData: AppBloc
                                                                          .filterCubit
                                                                          .stateList,
                                                                      stateId: AppBloc
                                                                          .filterCubit
                                                                          .stateList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                title: Text(
                                                                  '${AppBloc.filterCubit.stateList[index].name.toString()} (${AppBloc.filterCubit.stateList[index].medicalCenterInState})'
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .subtitle1
                                                                        .color,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                  height: 0)
                                                            ],
                                                          );
                                                        } else {
                                                          return SizedBox();
                                                        }
                                                      },
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: commonContainer(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppBloc.filterCubit.selectedState !=
                                                null
                                            ? '${AppBloc.filterCubit.selectedState.name} (${AppBloc.filterCubit.selectedState.medicalCenterInState})'
                                            : 'Select State',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          // color: AppBloc.filterCubit
                                          //             .selectedState !=
                                          //         null
                                          //     ? Colors.black
                                          //     : Colors.grey,
                                        ),
                                        // '${AppBloc.filterCubit.selectedState}',
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: _isDark
                                          ? Colors.white
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
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          Translate.of(context).translate('City'),
                          style: kInputTextStyle,
                        ),
                        // DropdownButton(
                        //   isExpanded: true,
                        //   hint: Text(
                        //     'Select States',
                        //     style: TextStyle(
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        //   // Initial Value
                        //   value: AppBloc.filterCubit.selectedState,
                        //   menuMaxHeight: Get.height / 2,
                        //   // Down Arrow Icon
                        //   icon: const Icon(Icons.arrow_drop_down_outlined),
                        //
                        //   // Array list of items
                        //   items: stateList.map((item) {
                        //     return DropdownMenuItem(
                        //       value: item,
                        //       child: Text(
                        //           '${item.name.toString()} (${item.medicalCenterInState})'),
                        //     );
                        //   }).toList(),
                        //   // After selecting the desired option,it will
                        //   // change button value to selected value
                        //   onChanged: (newValue) async {
                        //     AppBloc.filterCubit.onUpdateStateData(
                        //         stateDataList: stateList, stateData: newValue);
                        //     cityList.clear();
                        //     setState(() {});
                        //     await AppBloc.filterCubit.onCitiesLoad(
                        //         stateData: stateList, stateId: newValue.id);
                        //   },
                        // ),
                        SizedBox(height: 15),

                        GestureDetector(
                          onTap: () {
                            if (AppBloc.filterCubit.cityList.isNotEmpty ||
                                AppBloc.filterCubit.cityList == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState234) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: Get.height * 0.6,
                                              maxWidth: 550),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            // height: Get.height * 0.6,
                                            // width: Get.width * 0.85,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: Get.height * 0.015,
                                                left: Get.height * 0.015,
                                                right: Get.height * 0.005,
                                                bottom: 0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: _isDark
                                                                ? Colors.grey
                                                                    .shade800
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          height: Get.height *
                                                              0.045,
                                                          child: Center(
                                                            child: TextField(
                                                              controller:
                                                                  searchController,
                                                              onChanged:
                                                                  (value) {
                                                                setState234(
                                                                    () {});
                                                              },
                                                              decoration: InputDecoration(
                                                                  contentPadding: EdgeInsets.only(
                                                                      top: Get.height *
                                                                          0.004,
                                                                      left: Get.width *
                                                                          0.04),
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
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          searchController
                                                              .clear();
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
                                                    height: Get.height * 0.01,
                                                  ),
                                                  Expanded(
                                                    child: Builder(
                                                        builder: (context) {
                                                      int index = AppBloc
                                                          .filterCubit.cityList
                                                          .indexWhere((element) => element
                                                              .name
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  searchController
                                                                      .text
                                                                      .toString()
                                                                      .toLowerCase()));
                                                      if (index < 0) {
                                                        return Center(
                                                          child: Text(
                                                            'No City !',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: AppBloc
                                                            .filterCubit
                                                            .cityList
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (AppBloc
                                                              .filterCubit
                                                              .cityList[index]
                                                              .name
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  searchController
                                                                      .text
                                                                      .toString()
                                                                      .toLowerCase())) {
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ListTile(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    searchController
                                                                        .clear();
                                                                    AppBloc.filterCubit.onUpdateCityData(
                                                                        cityData: AppBloc
                                                                            .filterCubit
                                                                            .cityList[index]);

                                                                    String
                                                                        city =
                                                                        jsonEncode(AppBloc
                                                                            .filterCubit
                                                                            .cityList[index]);

                                                                    Prefs.setString(
                                                                        Prefs
                                                                            .cityFilter,
                                                                        city);

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  title: Text(
                                                                    '${AppBloc.filterCubit.cityList[index].name.toString()} (${AppBloc.filterCubit.cityList[index].medicalCenterInCity})',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1
                                                                            .color,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                    height: 0)
                                                              ],
                                                            );
                                                          } else {
                                                            return SizedBox();
                                                          }
                                                        },
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                          child: commonContainer(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppBloc.filterCubit.selectedCity != null
                                            ? '${AppBloc.filterCubit.selectedCity.name} (${AppBloc.filterCubit.selectedCity.medicalCenterInCity})'
                                            : 'Select City',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        // '${AppBloc.filterCubit.selectedState}',
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: _isDark
                                          ? AppBloc.filterCubit.cityList ==
                                                      null ||
                                                  AppBloc.filterCubit.cityList
                                                      .isEmpty
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade100
                                          : AppBloc.filterCubit.cityList ==
                                                      null ||
                                                  AppBloc.filterCubit.cityList
                                                      .isEmpty
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
                                  color: Colors.grey.shade300,
                                )
                              ],
                            ),
                          ),
                        ),

                        // DropdownButton(
                        //   isExpanded: true,
                        //   menuMaxHeight: Get.height / 2,
                        //   hint: Text(
                        //     'Select City',
                        //     style: TextStyle(
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        //   // Initial Value
                        //   value: AppBloc.filterCubit.selectedCity,
                        //
                        //   // Down Arrow Icon
                        //   icon: const Icon(Icons.arrow_drop_down_outlined),
                        //
                        //   // Array list of items
                        //   items: cityList.map((item) {
                        //     return DropdownMenuItem(
                        //       value: item,
                        //       child: Text(
                        //         '${item.name.toString()} (${item.medicalCenterInCity})',
                        //       ),
                        //     );
                        //   }).toList(),
                        //   // After selecting the desired option,it will
                        //   // change button value to selected value
                        //   onChanged: (newValue) {
                        //     AppBloc.filterCubit
                        //         .onUpdateCityData(cityData: newValue);
                        //     setState(() {});
                        //   },
                        // ),

                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  AppBloc.filterCubit.clearAllFilter(
                                      stateDataList:
                                          AppBloc.filterCubit.stateList,
                                      cityDataList:
                                          AppBloc.filterCubit.cityList);
                                  AppBloc.filterCubit.cityList.clear();
                                  Prefs.clearFilter();

                                  oldStateName = null;
                                  oldCityName = null;
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Clear",
                                      style: kTextStyleSubtitle1.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  isApply = true;
                                },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Apply",
                                      style: kTextStyleSubtitle1.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        })
        .closed
        .then((value) {
          if (!isApply) {
            if (oldCityName != AppBloc.filterCubit.selectedCity) {
              AppBloc.filterCubit.selectedCity = oldCityName;
            }

            if (oldStateName != AppBloc.filterCubit.selectedState) {
              AppBloc.filterCubit.selectedState = oldStateName;
            }
          }
          setState(() {});
        });
  }

  // void _onNavigate({
  //   String route,
  //   Object arguments,
  // }) async {
  //   if (AppBloc.userCubit.state == null) {
  //     final result = await Navigator.pushNamed(
  //       context,
  //       Routes.signIn,
  //       arguments: route,
  //     );
  //     if (result == null) return;
  //   }
  //   if (!mounted) return;
  //   Navigator.pushNamed(context, route, arguments: arguments);
  // }

  ///On select category
  // void _onCategory(CategoryModel item) {
  //   if (item.id == -1) {
  //     Navigator.pushNamed(context, Routes.category);
  //     return;
  //   }
  //   if (item.hasChild) {
  //     Navigator.pushNamed(context, Routes.category, arguments: item);
  //   } else {
  //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     //   return ListProduct(category:item,);
  //     // },));
  //     Navigator.pushNamed(context, Routes.listProduct, arguments: item)
  //         .then((value) => log('call....'));
  //   }
  // }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  /// Build category UI
  /*Widget _buildCategory(List<CategoryModel> category) {
    ///Loading
    Widget content = Wrap(
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(8, (index) => index).map(
        (item) {
          return const HomeCategoryItem();
        },
      ).toList(),
    );

    if (category != null) {
      List<CategoryModel> listBuild = category;

      log('category=====>${category[0].title}');
      final more = CategoryModel.fromJson({
        "term_id": -1,
        "name": Translate.of(context).translate("more"),
        "icon": "fas fa-ellipsis",
        "color": "#ff8a65",
      });

      if (category.length >= 7) {
        listBuild = category.take(7).toList();
        listBuild.add(more);
      }

      content = Wrap(
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: listBuild.map(
          (item) {
            return HomeCategoryItem(
              item: item,
              onPressed: _onCategory,
            );
          },
        ).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: content,
    );
  }*/

  ///On navigate list product
  /*void _onProductList(CategoryModel item) {
    print('printData');
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }*/

  ///Build popular UI
  /*Widget _buildLocation(List<CategoryModel> location) {
    ///Loading
    Widget content = ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: AppCategory(
            type: CategoryView.cardLarge,
          ),
        );
      },
      itemCount: List.generate(8, (index) => index).length,
    );

    if (location != null) {
      content = ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemBuilder: (context, index) {
          final item = location[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppCategory(
              item: item,
              type: CategoryView.cardLarge,
              onPressed: () {
                _onCategory(item);
              },
            ),
          );
        },
        itemCount: location.length,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translate.of(context).translate(
                  'popular_location',
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                Translate.of(context).translate(
                  'let_find_interesting',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Container(
          height: 180,
          padding: const EdgeInsets.only(top: 4),
          child: content,
        ),
      ],
    );
  }*/

  ///Build list recent
  /*Widget _buildRecent(List<ProductModel> recent) {
    ///Loading
    Widget content = ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: AppProductItem(type: ProductViewType.small),
        );
      },
      itemCount: 8,
    );

    if (recent != null) {
      content = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = recent[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: ProductViewType.small,
            ),
          );
        },
        itemCount: recent.length,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Translate.of(context).translate('recent_location'),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                Translate.of(context).translate(
                  'what_happen',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ],
    );
  }*/

  List<ProductModel> medicalCenterLists = [];
  List<ProductModel> medicalCenterList = [];

  ///Build list recent (NA HEALTH SERVICES)
  Widget _buildNativeAmericanData(List<ProductModel> nativeAmericanData) {
    int medicalCenterListLength = 0;
    medicalCenterLists = [];

    ///Loading
    Widget content = ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: AppProductItem(type: ProductViewType.small),
        );
      },
      itemCount: 5,
    );

    if (nativeAmericanData != null) {
      List<ProductModel> nativeAmericanDataList = [];

      nativeAmericanData.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

      nativeAmericanData.forEach((element) {
        if (AppBloc.filterCubit.selectedState != null &&
            AppBloc.filterCubit.selectedCity != null) {
          if ((AppBloc.filterCubit.selectedState.name
                          .toString()
                          .toLowerCase() ==
                      element.stateName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedState.name.toString() ==
                      'All States') &&
              (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                      element.cityName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedCity.name.toString() ==
                      'All Cities')) {
            nativeAmericanDataList.add(element);
          }
        } else if (AppBloc.filterCubit.selectedState != null) {
          if (AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
                  element.stateName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedState.name.toString() ==
                  'All States') {
            nativeAmericanDataList.add(element);
          }
        } else if (AppBloc.filterCubit.selectedCity != null) {
          if (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                  element.cityName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedCity.name.toString() ==
                  'All Cities') {
            nativeAmericanDataList.add(element);
          }
        } else {
          nativeAmericanDataList.add(element);
        }
      });

      medicalCenterLists = nativeAmericanDataList
          .where((element) =>
              element.category.title == 'I.H.S.' ||
              element.category.title == 'Tribal Facilities')
          .toList();

      medicalCenterListLength = medicalCenterLists.length;

      content = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = medicalCenterLists[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: ProductViewType.small,
            ),
          );
        },
        itemCount: medicalCenterListLength <= 5 ? medicalCenterListLength : 5,
      );

      if (medicalCenterListLength == 0) {
        content = Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 9),
            child: Text('No NA Health Services available'),
          ),
        );
      }
    } else if (nativeAmericanData != null && nativeAmericanData.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 9),
          child: Text('No NA Health Services available'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('native_american'),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    AppBloc.filterCubit.selectedState != null
                        ? Text(
                            Translate.of(context).translate(
                                '(${AppBloc.filterCubit.selectedState.name})'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18),
                          )
                        : SizedBox(),
                    SizedBox(height: 5),

                    // Text(
                    //   Translate.of(context).translate(
                    //     'what_happen',
                    //   ),
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1
                    //       .copyWith(fontSize: 18),
                    // ),
                  ],
                ),
              ),
              if (medicalCenterListLength > 5)
                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> contentData = {
                      "title":
                          Translate.of(context).translate('native_american'),
                      "dataList": medicalCenterLists,
                      "allData": nativeAmericanData
                    };

                    await Navigator.pushNamed(context, Routes.listProduct2,
                        arguments: contentData);
                    setState(() {});
                  },
                  child: Text(
                    Translate.of(context).translate('see_all'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 18,
                        ),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ],
    );
  }

  ///Build list recent (NAVAJO HEALTH SERVICES)

  Widget _buildNavajoNationServicesData(List<ProductModel> nativeAmericanData) {
    int medicalCenterListLength = 0;
    medicalCenterList = [];

    ///Loading
    Widget content = ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: AppProductItem(type: ProductViewType.small),
        );
      },
      itemCount: 5,
    );

    if (nativeAmericanData != null) {
      List<ProductModel> nativeAmericanDataList = [];

      nativeAmericanData.forEach((element) {
        if (AppBloc.filterCubit.selectedState != null &&
            AppBloc.filterCubit.selectedCity != null) {
          if ((AppBloc.filterCubit.selectedState.name
                          .toString()
                          .toLowerCase() ==
                      element.stateName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedState.name.toString() ==
                      'All States') &&
              (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                      element.cityName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedCity.name.toString() ==
                      'All Cities')) {
            nativeAmericanDataList.add(element);
          }
        } else if (AppBloc.filterCubit.selectedState != null) {
          if (AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
                  element.stateName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedState.name.toString() ==
                  'All States') {
            nativeAmericanDataList.add(element);
          }
        } else if (AppBloc.filterCubit.selectedCity != null) {
          if (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                  element.cityName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedCity.name.toString() ==
                  'All Cities') {
            nativeAmericanDataList.add(element);
          }
        } else {
          nativeAmericanDataList.add(element);
        }
      });

      medicalCenterList = nativeAmericanDataList
          .where((element) =>
              element.category.title == 'Navajo Nation Services' ||
              element.category.title == 'Navajo Health Facilities' ||
              element.category.title == 'Navajo Public Safety')
          .toList();

      medicalCenterListLength = medicalCenterList.length;

      content = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = medicalCenterList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: ProductViewType.small,
            ),
          );
        },
        itemCount: medicalCenterListLength <= 5 ? medicalCenterListLength : 5,
      );

      if (medicalCenterListLength == 0) {
        content = Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 9),
            child: Text('No Navajo Nation Services available'),
          ),
        );
      }
    } else if (medicalCenterList != null && medicalCenterList.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 9),
          child: Text('No Navajo Nation Services available     '),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('navajo_nation'),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    // Text(
                    //   Translate.of(context).translate(
                    //     'what_happen',
                    //   ),
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1
                    //       .copyWith(fontSize: 18),
                    // ),
                  ],
                ),
              ),
              if (medicalCenterListLength > 5)
                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> contentData = {
                      "title": Translate.of(context).translate('navajo_nation'),
                      "dataList": medicalCenterList,
                      "allData": nativeAmericanData
                    };

                    await Navigator.pushNamed(context, Routes.listProduct2,
                        arguments: contentData);
                    setState(() {});
                  },
                  child: Text(
                    Translate.of(context).translate('see_all'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 18,
                        ),
                  ),
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ],
    );
  }

  ///Build list recent (SUPPORTIVE (OTHER) HEALTH SERVICES)
  Widget _buildAmericanNativeData(List<ProductModel> americanNativeData) {
    int americanNativeDataLength = 0;

    ///Loading
    Widget content = ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: AppProductItem(type: ProductViewType.small),
        );
      },
      itemCount: 5,
    );

    if (americanNativeData != null) {
      List<ProductModel> americanNativeDataList = [];

      americanNativeData.forEach((element) {
        if (AppBloc.filterCubit.selectedState != null &&
            AppBloc.filterCubit.selectedCity != null) {
          if ((AppBloc.filterCubit.selectedState.name
                          .toString()
                          .toLowerCase() ==
                      element.stateName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedState.name.toString() ==
                      'All States') &&
              (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                      element.cityName.toString().toLowerCase() ||
                  AppBloc.filterCubit.selectedCity.name.toString() ==
                      'All Cities')) {
            if (element.category.title == "Other Medical Center") {
              americanNativeDataList.add(element);
            }
          }
        } else if (AppBloc.filterCubit.selectedState != null) {
          if (AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
                  element.stateName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedState.name.toString() ==
                  'All States') {
            if (element.category.title == "Other Medical Center") {
              americanNativeDataList.add(element);
            }
          }
        } else if (AppBloc.filterCubit.selectedCity != null) {
          if (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                  element.cityName.toString().toLowerCase() ||
              AppBloc.filterCubit.selectedCity.name.toString() ==
                  'All Cities') {
            if (element.category.title == "Other Medical Center") {
              americanNativeDataList.add(element);
            }
          }
        } else {
          if (element.category.title == "Other Medical Center") {
            americanNativeDataList.add(element);
          }
        }
      });

      americanNativeDataLength = americanNativeDataList.length;

      content = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = americanNativeDataList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: ProductViewType.small,
            ),
          );
        },
        itemCount: americanNativeDataList.length <= 5
            ? americanNativeDataList.length
            : 5,
      );

      if (americanNativeDataLength == 0) {
        content = Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 9),
            // child: Text('No Supportive Health Services available'),
            child: Text('No Other Health Services available'),
          ),
        );
      }
    } else if (americanNativeData != null && americanNativeData.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 9),
          // child: Text('No Supportive Health Services available'),
          child: Text('No Other Health Services available'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context)
                          .translate('supportive_health_service'),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 5),

                    // Text(
                    //   Translate.of(context).translate(
                    //     'what_happen',
                    //   ),
                    //   style: Theme.of(context).textTheme.bodyText1,
                    // ),
                  ],
                ),
              ),
              if (americanNativeDataLength > 5)
                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> contentData = {
                      "title": Translate.of(context)
                          .translate('supportive_health_service'),
                      "dataList": americanNativeData,
                      "allData": americanNativeData
                    };

                    await Navigator.pushNamed(context, Routes.listProduct2,
                        arguments: contentData);
                    setState(() {});
                  },
                  child: Text(
                    Translate.of(context).translate('see_all'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: BlocProvider.of<HomeCubit>(context),
        builder: (context, state) {
          List<String> banner;
          List<CategoryModel> category;
          List<CategoryModel> location;
          List<ProductModel> recent;
          List<ProductModel> nativeAmericanData;
          List<ProductModel> americanNativeData;

          if (state is HomeSuccess) {
            banner = state.banner;
            category = state.category;
            location = state.location;
            recent = state.recent;
            nativeAmericanData = state.nativeAmericanData;
            americanNativeData = state.americanNativeData;
          }

          log('category==========>>>>>$category');
          log('location==========>>>>>$location');
          log('recent==========>>>>>$recent');
          log('americanNativeData==========>>>>>$americanNativeData');

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: AppBarHomeSliver(
                  expandedHeight: h * 0.3,
                  banners: banner,
                  onSearch: state is HomeSuccess ? _onSearch : () {},
                  onScan: _onScan,
                  onFilter: onFilter,
                ),
                pinned: true,
              ),
              CupertinoSliverRefreshControl(
                onRefresh: _onRefresh,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SafeArea(
                    top: false,
                    bottom: false,
                    child: Column(
                      children: <Widget>[
                        // _buildCategory(category),
                        // _buildLocation(location),
                        // _buildRecent(recent),

                        _buildNativeAmericanData(nativeAmericanData),
                        _buildNavajoNationServicesData(nativeAmericanData),
                        _buildAmericanNativeData(nativeAmericanData),
                        const SizedBox(height: 28),
                        /*               BlocBuilder<DiscoveryCubit, DiscoveryState>(
                            bloc: _discoveryCubit,
                            builder: (context, state1) {
                              ///Loading
                              Widget content = SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return const AppDiscoveryItem();
                                  },
                                  childCount: 15,
                                ),
                              );
                              if (state1 is DiscoverySuccess) {
                                log('state1------------>${state1.list}');
                                if (state1.list.isEmpty) {
                                  content = Center(
                                    child: Text(
                                      Translate.of(context).translate(
                                        'can_not_found_data',
                                      ),
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  );
                                } else {
                                  state1.list.forEach((element) {
                                    if (element.category.title ==
                                        "Navajo Nation Services") {
                                      content = AppDiscoveryItem(
                                        item: element,
                                        onSeeMore: _onProductList,
                                        onProductDetail: _onProductDetail,
                                      );
                                    }
                                    log("element.category.title---->${element.category.title}");
                                  });
                                }
                              }
                              return content;
                            }),*/
                      ],
                    ),
                  )
                ]),
              )
            ],
          );
        },
      ),
    );
  }

  static Container commonContainer({Widget child}) {
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
