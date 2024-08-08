import 'dart:async';

import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/routes.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/screens/search_history/search_history.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Discovery extends StatefulWidget {
  const Discovery({super.key});

  @override
  _DiscoveryState createState() {
    return _DiscoveryState();
  }
}

class _DiscoveryState extends State<Discovery> {
  final _discoveryCubit = DiscoveryCubit();
  StreamSubscription _submitSubscription;
  SearchHistoryDelegate _delegate;
  @override
  void initState() {
    print('printData');
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _discoveryCubit.onLoad();
      _delegate = SearchHistoryDelegate();
      _submitSubscription = AppBloc.submitCubit.stream.listen((state) {
        if (state is Submitted) {
          _onRefresh();
        }
      });
    });
  }

  @override
  void dispose() {
    _submitSubscription.cancel();
    _discoveryCubit.close();
    super.dispose();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await _discoveryCubit.onLoad();
  }

  ///On search
  void _onSearch() {
    _onSearch1();
    // Navigator.pushNamed(context, Routes.searchHistory);
  }

  ///onShow search
  void _onSearch1() async {
    AppBloc.searchCubit.onClear();
    await showSearch(
      context: context,
      delegate: _delegate,
    );
  }

  ///On navigate list product
  void _onProductList(CategoryModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    print('===>=====>');
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    print('printData');
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).hoverColor,
            child: Column(
              children: [
                const SizedBox(height: 16),

                SafeArea(
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: TextButton(
                        onPressed: _onSearch,
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.search,
                                        color: Theme.of(context).primaryColor),
                                    SizedBox(width: 10),
                                    Text(
                                      Translate.of(context)
                                          .translate('search_location'),
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ],
                                ),
                              ),
                              // const VerticalDivider(),
                              // InkWell(
                              //   onTap: onScan,
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 8,
                              //       vertical: 4,
                              //     ),
                              //     child: Icon(
                              //       Icons.qr_code_scanner_outlined,
                              //       color: Theme.of(context).primaryColor,
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: onFilter,
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 8,
                              //       vertical: 4,
                              //     ),
                              //     child: Stack(
                              //       clipBehavior: Clip.none,
                              //       children: [
                              //         Text(
                              //           'Filter',
                              //           style: TextStyle(
                              //             color: Theme.of(context).primaryColor,
                              //           ),
                              //         ),
                              //         Positioned(
                              //           right: -5,
                              //           top: 3,
                              //           child: CircleAvatar(
                              //             radius: 4,
                              //             backgroundColor:
                              //             AppBloc.filterCubit.selectedState == null
                              //                 ? Colors.transparent
                              //                 : Colors.green,
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // SearchBar(
                //   onSearch: _onSearch,
                //   onScan: () {},
                // ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
              bloc: _discoveryCubit,
              builder: (context, discovery) {
                ///Loading
                Widget content = SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const AppDiscoveryItem();
                    },
                    childCount: 15,
                  ),
                );

                ///Success
                if (discovery is DiscoverySuccess) {
                  if (discovery.list.isEmpty) {
                    content = SliverFillRemaining(
                      child: Center(
                        child: Text(
                          Translate.of(context).translate(
                            'can_not_found_data',
                          ),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    );
                  } else {
                    // int index1 = discovery.list.indexWhere((element) =>
                    //     element.category.title == "Navajo Nation Services");

                    content = SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          discovery.list[index].list.sort((a, b) => a.title
                              .toLowerCase()
                              .compareTo(b.title.toLowerCase()));

                          final item = discovery.list[index];

                          item.list.sort((a, b) => a.title
                              .toLowerCase()
                              .compareTo(b.title.toLowerCase()));

                          return AppDiscoveryItem(
                            item: item,
                            onSeeMore: _onProductList,
                            onProductDetail: _onProductDetail,
                          );
                        },
                        childCount: discovery.list.length,
                      ),
                    );
                  }
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    CupertinoSliverRefreshControl(
                      onRefresh: _onRefresh,
                    ),
                    SliverSafeArea(
                      top: false,
                      sliver: SliverPadding(
                        padding: const EdgeInsets.only(top: 8, bottom: 28),
                        sliver: content,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
