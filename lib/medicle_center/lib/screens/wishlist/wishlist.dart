import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';
import 'package:share/share.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  _WishListState createState() {
    return _WishListState();
  }
}

class _WishListState extends State<WishList> {
  StreamSubscription _submitSubscription;
  StreamSubscription _reviewSubscription;
  final _scrollController = ScrollController();
  final _endReachedThreshold = 500;
  int selector = 0;

  @override
  void initState() {
    print('WishListData');
    super.initState();
    _scrollController.addListener(_onScroll);
    _submitSubscription = AppBloc.submitCubit.stream.listen((state) {
      if (state is Submitted) {
        _onRefresh();
      }
    });
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewSuccess && state.id != null) {
        _onRefresh();
      }
    });
  }

  @override
  void dispose() {
    _submitSubscription.cancel();
    _reviewSubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = AppBloc.wishListCubit.state;
    if (state is WishListSuccess && state.canLoadMore && !state.loadingMore) {
      AppBloc.wishListCubit.onLoadMore();
    }
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await AppBloc.wishListCubit.onLoad();
  }

  ///Clear all wishlist
  void _clearWishList() {
    AppBloc.wishListCubit.onRemove(null);
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  ///Action Item
  void _onAction(ProductModel item) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Widget bookingItem = Container();
        // if (item.bookingUse) {
        //   bookingItem = AppListTitle(
        //     title: Translate.of(context).translate("Booking"),
        //     leading: const Icon(Icons.pending_actions_outlined),
        //     onPressed: () {
        //       Navigator.pop(context, "booking");
        //     },
        //   );
        // }
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Column(
                      children: [
                        bookingItem,
                        AppListTitle(
                          title: Translate.of(context).translate("remove"),
                          leading: const Icon(Icons.delete_outline),
                          onPressed: () {
                            Navigator.pop(context, "remove");
                          },
                        ),
                        AppListTitle(
                          title: Translate.of(context).translate("share"),
                          leading: const Icon(Icons.share_outlined),
                          onPressed: () {
                            Navigator.pop(context, "share");
                          },
                          border: false,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (result == 'booking') {
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        Routes.booking,
        arguments: item.id,
      );
    }
    if (result == 'remove') {
      AppBloc.wishListCubit.onRemove(item.id);
    }
    if (result == 'share') {
      Share.share(
        'Check out my item ${item.link}',
        subject: 'PassionUI',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        ///Loading
        Widget content = RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 28),
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: AppProductItem(type: ProductViewType.small),
              );
            },
            itemCount: 8,
          ),
        );

        ///Success
        if (state is WishListSuccess) {
          print('wishListIsSuccess');
          int count = state.list.length;
          if (state.loadingMore) {
            count = count + 1;
          }
          content = RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                bottom: 28,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                ///Loading loadMore item
                if (index == state.list.length) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AppProductItem(
                      type: ProductViewType.small,
                    ),
                  );
                }

                state.list.sort((a, b) =>
                    a.title.toLowerCase().compareTo(b.title.toLowerCase()));

                final item = state.list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppProductItem(
                    onPressed: () {
                      _onProductDetail(item);
                    },
                    item: item,
                    type: ProductViewType.small,
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        _onAction(item);
                      },
                    ),
                  ),
                );
              },
            ),
          );

          ///Empty
          if (state.list.isEmpty) {
            content = Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.sentiment_satisfied),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      Translate.of(context).translate('list_is_empty'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            );
          }
        }

        ///Icon Remove
        Widget icon = Container();
        if (state is WishListSuccess && state.list.isNotEmpty) {
          icon = IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearWishList,
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              Translate.of(context).translate('wish_list'),
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[icon],
          ),
          body: SafeArea(
            child: content,
          ),
        );
      },
    );
  }
}
