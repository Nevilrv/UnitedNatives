import 'dart:convert';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/config.dart';
import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';

import 'search_result_list.dart';
import 'search_suggest_list.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() {
    return _SearchHistoryState();
  }
}

class _SearchHistoryState extends State<SearchHistory> {
  SearchHistoryDelegate? _delegate;

  @override
  void initState() {
    super.initState();
    AppBloc.searchCubit.onClear();
    _delegate = SearchHistoryDelegate();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   _onSearch();
    // });
    _loadHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Load history
  void _loadHistory() async {
    List<String>? historyString = Preferences.getStringList(Preferences.search);
    if (historyString != null) {}
    setState(() {});
  }

  ///onShow search
  void _onSearch() async {
    AppBloc.searchCubit.onClear();
    await showSearch(
      context: context,
      delegate: _delegate!,
    );
  }

  void onClear({ProductModel? item}) async {
    if (item == null) {
      await Preferences.setStringList(Preferences.search, []);
    } else {
      List<String> historyString =
          Preferences.getStringList(Preferences.search)!;
      if (historyString.isNotEmpty) {
        historyString.remove(jsonEncode(item.toJson()));
        await Preferences.setStringList(Preferences.search, historyString);
      }
    }
    _loadHistory();
  }

  ///On navigate product detail
  void onProductDetail(ProductModel item) async {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _delegate!.transitionAnimation,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(Translate.of(context)!.translate('search_title')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearch,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: const SizedBox(),
      // body: SafeArea(
      //   child: ListView(
      //     padding: const EdgeInsets.all(16),
      //     children: <Widget>[
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: <Widget>[
      //               Text(
      //                 Translate.of(context).translate('search_history'),
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .subtitle1
      //                     .copyWith(fontWeight: FontWeight.bold),
      //               ),
      //               InkWell(
      //                 onTap: () {
      //                   _onClear();
      //                 },
      //                 child: Text(
      //                   Translate.of(context).translate('clear'),
      //                   style: Theme.of(context).textTheme.subtitle2.copyWith(
      //                         color: Theme.of(context).colorScheme.secondary,
      //                       ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Wrap(
      //             alignment: WrapAlignment.start,
      //             spacing: 8,
      //             children: _history.map((item) {
      //               return InputChip(
      //                 onPressed: () {
      //                   _onProductDetail(item);
      //                 },
      //                 label: Text(item.title),
      //                 onDeleted: () {
      //                   _onClear(item: item);
      //                 },
      //               );
      //             }).toList(),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class SearchHistoryDelegate extends SearchDelegate<String> {
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    AppBloc.searchCubit.onSearch(query);
    return const SuggestionList();
  }

  @override
  Widget buildResults(BuildContext context) {
    return const ResultList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return [];
  }
}
