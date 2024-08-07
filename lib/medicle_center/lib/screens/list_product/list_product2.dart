import 'dart:convert';
import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_city_data.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_state_data.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/app_navbar.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/app_product_item.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListProduct2 extends StatefulWidget {
  final Map<String, dynamic> contentData;
  const ListProduct2({Key key, @required this.contentData}) : super(key: key);

  @override
  State<ListProduct2> createState() => _ListProduct2State();
}

class _ListProduct2State extends State<ListProduct2> {
  String title = '';
  bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  List<ProductModel> dataList = [];
  List<ProductModel> allDataList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetOpen = false;
  final searchController = TextEditingController();
  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  @override
  void initState() {
    super.initState();
    title = widget.contentData['title'];
    dataList = widget.contentData['dataList'];
    allDataList = widget.contentData['allData'];

    print("allDataList----->$allDataList");
    allDataList.forEach((element) {
      log("element.-------------------->${element.category.title}");
    });
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  final _swipeController = SwiperController();
  ProductModel _currentItem;
  MapType _mapType = MapType.normal;
  GoogleMapController _mapController;

  ///On tap marker map location
  void _onSelectLocation(int index) {
    _swipeController.move(index);
  }

  ///Handle Index change list map view
  void _onIndexChange(ProductModel item) {
    setState(() {
      _currentItem = item;
    });
    if (item.location != null) {
      ///Camera animated
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              item.location.latitude,
              item.location.longitude,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();

    _mapController?.dispose();

    super.dispose();
  }

  ///Build list recent
  Widget _buildContent() {
    List<ProductModel> data = [];

    if (AppBloc.filterCubit.selectedState != null &&
        AppBloc.filterCubit.selectedCity != null) {
      allDataList.forEach((element) {
        if (AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
                element.stateName.toString().toLowerCase() &&
            AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                element.cityName.toString().toLowerCase()) {
          data.add(element);
        }
      });
    } else if (AppBloc.filterCubit.selectedState != null) {
      allDataList.forEach((element) {
        if (AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
            element.stateName.toString().toLowerCase()) {
          data.add(element);
        }
      });
    } else if (AppBloc.filterCubit.selectedCity != null) {
      allDataList.forEach((element) {
        if (AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
            element.cityName.toString().toLowerCase()) {
          data.add(element);
        }
      });
    } else {
      data = dataList;
    }
    setState(() {});
    if (_pageType == PageType.list) {
      log('data--------$data');

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

      if (data != null) {
        debugPrint("filter--------------->");
        if (AppBloc.filterCubit.selectedState != null &&
            AppBloc.filterCubit.selectedCity != null) {
          // data = allDataList;
          int dataIndex = data.indexWhere((element) =>
              AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
                  element.stateName.toString().toLowerCase() &&
              AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
                  element.cityName.toString().toLowerCase());
          log("data--selectedCity--434------->${data.length}");
          if (dataIndex < 0) {
            return Center(
                child: Text(
              'No Data available',
              style: TextStyle(fontSize: 21),
            ));
          }
        } else if (AppBloc.filterCubit.selectedState != null) {
          // data = allDataList;
          int dataIndex = data.indexWhere((element) =>
              AppBloc.filterCubit.selectedState.name.toString().toLowerCase() ==
              element.stateName.toString().toLowerCase());
          log("data--selectedState--------->${data.length}");
          log("dataIndex====>$dataIndex");
          if (dataIndex < 0) {
            return Center(
                child: Text(
              'No Data available',
              style: TextStyle(fontSize: 21),
            ));
          }
        } else if (AppBloc.filterCubit.selectedCity != null) {
          // data = allDataList;
          int dataIndex = data.indexWhere((element) =>
              AppBloc.filterCubit.selectedCity.name.toString().toLowerCase() ==
              element.cityName.toString().toLowerCase());
          log("data--selectedCity--------->${data.length}");

          if (dataIndex < 0) {
            return Center(
                child: Text(
              'No Data available',
              style: TextStyle(fontSize: 21),
            ));
          }
        } else {}

        content = ListView.builder(
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = data[index];

            if (AppBloc.filterCubit.selectedState != null &&
                AppBloc.filterCubit.selectedCity != null) {
              if (AppBloc.filterCubit.selectedState.name
                          .toString()
                          .toLowerCase() ==
                      item.stateName.toString().toLowerCase() &&
                  AppBloc.filterCubit.selectedCity.name
                          .toString()
                          .toLowerCase() ==
                      item.cityName.toString().toLowerCase()) {
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
              } else {
                return SizedBox();
              }
            } else if (AppBloc.filterCubit.selectedState != null) {
              if (AppBloc.filterCubit.selectedState.name
                      .toString()
                      .toLowerCase() ==
                  item.stateName.toString().toLowerCase()) {
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
              } else {
                return SizedBox();
              }
            } else if (AppBloc.filterCubit.selectedCity != null) {
              if (AppBloc.filterCubit.selectedCity.name
                      .toString()
                      .toLowerCase() ==
                  item.cityName.toString().toLowerCase()) {
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
              } else {
                return SizedBox();
              }
            }

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
          itemCount: data.length,
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
        child: content,
      );
    } else {
      log("data---------->${data.length}");
      CameraPosition initPosition = const CameraPosition(
        target: LatLng(
          40.697403,
          -74.1201063,
        ),
        zoom: 14.4746,
      );
      Map<MarkerId, Marker> markers = {};

      ///Not build swipe and action when empty
      Widget list = Container();

      ///Build swipe if list not empty
      if (data.isNotEmpty) {
        if (data[0].location != null) {
          initPosition = CameraPosition(
            target: LatLng(
              data[0].location.latitude ?? 40.697403,
              data[0].location.longitude ?? -74.1201063,
            ),
            zoom: 14.4746,
          );
        }
        log("dataList--------------->${data.length}");

        ///Setup list marker map from list
        for (var item in data) {
          log('item---------->>>>>>>>${data.length}');

          log('item.location != null---------->>>>>>>>${item.location.latitude} ${item.location.longitude}');

          if (item.location != null) {
            final markerId = MarkerId(item.id.toString());
            final marker = Marker(
              markerId: markerId,
              position: LatLng(
                item.location.latitude ?? 40.697403,
                item.location.longitude ?? -74.1201063,
              ),
              infoWindow: InfoWindow(title: item.title),
              onTap: () {
                _onSelectLocation(data.indexOf(item));
              },
            );
            markers[markerId] = marker;
          }
        }

        for (var item in data) {
          log('item.id---------->>>>>>>>${item.id}');
        }

        ///build list map
        list = SafeArea(
          bottom: false,
          top: false,
          child: Container(
            height: 220,
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'location',
                        mini: true,
                        onPressed: () {},
                        backgroundColor: Theme.of(context).cardColor,
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Swiper(
                    itemBuilder: (context, index) {
                      final ProductModel item = data[index];
                      bool selected = _currentItem == item;
                      if (index == 0 && _currentItem == null) {
                        selected = true;
                      }
                      return Container(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: selected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).dividerColor,
                                blurRadius: 4,
                                spreadRadius: 1.0,
                                offset: const Offset(1.5, 1.5),
                              )
                            ],
                          ),
                          child: AppProductItem(
                            onPressed: () {
                              _onProductDetail(item);
                            },
                            item: item,
                            type: ProductViewType.list,
                          ),
                        ),
                      );
                    },
                    controller: _swipeController,
                    onIndexChanged: (index) {
                      final item = data[index];
                      _onIndexChange(item);
                    },
                    itemCount: data.length,
                    viewportFraction: 0.8,
                    scale: 0.9,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      ///build Map
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            mapType: _mapType,
            initialCameraPosition: initPosition,
            markers: Set<Marker>.of(markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          list
        ],
      );
    }
  }

  PageType _pageType = PageType.list;

  ///On change page
  void _onChangePageStyle() {
    switch (_pageType) {
      case PageType.list:
        setState(() {
          _pageType = PageType.map;
        });
        return;
      case PageType.map:
        setState(() {
          _pageType = PageType.list;
        });
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData iconAction = Icons.map;
    if (_pageType == PageType.map) {
      iconAction = Icons.view_compact;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .headline6
              .copyWith(fontSize: 20),
        ),
        actions: [
          _pageType != PageType.list
              ? SizedBox()
              : !isBottomSheetOpen
                  ? GestureDetector(
                      onTap: () async {
                        onFilter();
                      },
                      child: Row(
                        children: [
                          Text(
                            Translate.of(context).translate('filter'),
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
          IconButton(
            icon: Icon(iconAction),
            onPressed: _onChangePageStyle,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  ///On Filter
  void onFilter() async {
    isBottomSheetOpen = true;
    setState(() {});
    CityModel oldCityName = AppBloc.filterCubit.selectedCity;
    StateModel oldStateName = AppBloc.filterCubit.selectedState;
    bool isApply = false;
    scaffoldKey.currentState
        .showBottomSheet((context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  List<StateModel> stateList;
                  List<CityModel> cityList;

                  if (state is FilterLoading) {
                    return Utils.circular();
                  }

                  if (state is FilterSuccess) {
                    stateList = state.stateList;
                    cityList = state.cityList;
                  }

                  return Container(
                    padding: EdgeInsets.all(16),
                    color: _isdark ? Colors.black : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _isDark
                                                ? Colors.grey.shade800
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005,
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
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.045,
                                                        child: Center(
                                                          child: TextField(
                                                            controller:
                                                                searchController,
                                                            onChanged: (value) {
                                                              setState234(
                                                                  () {});
                                                            },
                                                            decoration: InputDecoration(
                                                                contentPadding: EdgeInsets.only(
                                                                    top: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.004,
                                                                    left: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Expanded(
                                                  child: Builder(
                                                      builder: (context) {
                                                    int index = stateList.indexWhere(
                                                        (element) => element
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
                                                      itemCount:
                                                          stateList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (stateList[index]
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
                                                                title: Text(
                                                                  '${stateList[index].name.toString()} (${stateList[index].medicalCenterInState})',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .subtitle1
                                                                          .color,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);

                                                                  AppBloc.filterCubit.onUpdateStateData(
                                                                      stateDataList:
                                                                          stateList,
                                                                      stateData:
                                                                          stateList[
                                                                              index]);

                                                                  String state =
                                                                      jsonEncode(
                                                                          stateList[
                                                                              index]);

                                                                  Prefs.setString(
                                                                      Prefs
                                                                          .stateFilter,
                                                                      state);

                                                                  cityList
                                                                      .clear();

                                                                  searchController
                                                                      .clear();
                                                                  setState(
                                                                      () {});
                                                                  await AppBloc
                                                                      .filterCubit
                                                                      .onCitiesLoad(
                                                                          stateData:
                                                                              stateList,
                                                                          stateId: stateList[index]
                                                                              .id
                                                                              .toString());
                                                                },
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
                                        ),
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

                        // DropdownButton(
                        //   isExpanded: true,
                        //   hint: Text(
                        //     'Select States',
                        //     style: TextStyle(
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        //   value: AppBloc.filterCubit.selectedState,
                        //   menuMaxHeight: Get.height / 2,
                        //   icon: const Icon(Icons.arrow_drop_down_outlined),
                        //   items: stateList.map((item) {
                        //     return DropdownMenuItem(
                        //       value: item,
                        //       child: Text(
                        //           '${item.name.toString()} (${item.medicalCenterInState})'),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) async {
                        //     AppBloc.filterCubit.onUpdateStateData(
                        //         stateDataList: stateList, stateData: newValue);
                        //     cityList.clear();
                        //     setState(() {});
                        //     await AppBloc.filterCubit.onCitiesLoad(
                        //         stateData: stateList, stateId: newValue.id);
                        //   },
                        // ),

                        Text(
                          Translate.of(context).translate('City'),
                          style: kInputTextStyle,
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (cityList.isNotEmpty || cityList == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState234) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
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
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
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
                                                                      top: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.004,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  Expanded(
                                                    child: Builder(
                                                        builder: (context) {
                                                      int index = cityList.indexWhere(
                                                          (element) => element
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
                                                        itemCount:
                                                            cityList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (cityList[index]
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
                                                                  title: Text(
                                                                    '${cityList[index].name.toString()} (${cityList[index].medicalCenterInCity})',
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
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);

                                                                    AppBloc
                                                                        .filterCubit
                                                                        .onUpdateCityData(
                                                                            cityData:
                                                                                cityList[index]);

                                                                    String
                                                                        city =
                                                                        jsonEncode(
                                                                            cityList[index]);

                                                                    Prefs.setString(
                                                                        Prefs
                                                                            .cityFilter,
                                                                        city);

                                                                    setState(
                                                                        () {});
                                                                  },
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
                                          ? cityList == null || cityList.isEmpty
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade100
                                          : cityList == null || cityList.isEmpty
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
                        //   value: AppBloc.filterCubit.selectedCity,
                        //   icon: const Icon(Icons.arrow_drop_down_outlined),
                        //   items: cityList.map((item) {
                        //     return DropdownMenuItem(
                        //       value: item,
                        //       child: Text(
                        //           '${item.name.toString()} (${item.medicalCenterInCity})'),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) {
                        //     AppBloc.filterCubit
                        //         .onUpdateCityData(cityData: newValue);
                        //     setState(() {});
                        //   },
                        // ),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  AppBloc.filterCubit.clearAllFilter(
                                      stateDataList: stateList,
                                      cityDataList: cityList);
                                  cityList.clear();
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
                                          fontWeight: FontWeight.w600),
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
          isBottomSheetOpen = false;

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

  static Container commonContainer({Widget child}) {
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
}
