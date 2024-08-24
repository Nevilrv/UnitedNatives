import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/config.dart';
import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/medicle_center/lib/widgets/widget.dart';

class Review extends StatefulWidget {
  final ProductModel? product;

  const Review({super.key, this.product});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() {
    AppBloc.reviewCubit.onLoad(widget.product!.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isWriteShow = false;

  ///On refresh
  Future<void> _onRefresh() async {
    await AppBloc.reviewCubit.onLoad(widget.product!.id!);
  }

  ///On navigate write review
  void _onWriteReview() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(context, Routes.signIn,
          arguments: Routes.writeReview);
      if (result != Routes.writeReview) {
        return;
      }
    }
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      Routes.writeReview,
      arguments: widget.product,
    ).then((value) {
      if (value != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            isWriteShow = true;
          });
        });
      }
    });
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    // Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          Translate.of(context)!.translate('review'),
        ),
        actions: [
          if (!isWriteShow)
            AppButton(
              Translate.of(context)!.translate('write'),
              onPressed: _onWriteReview,
              type: ButtonType.text,
            ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            RateModel? rate;

            ///Loading
            Widget content = ListView(
              children: List.generate(8, (index) => index).map(
                (item) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AppCommentItem(),
                  );
                },
              ).toList(),
            );

            ///Success
            if (state is ReviewSuccess) {
              rate = state.rate!;

              ///Empty
              if (state.list!.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    isWriteShow = false;
                  });
                });
                content = Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.sentiment_satisfied),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          Translate.of(context)!.translate('review_not_found'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                int index = -1;
                index = state.list!.indexWhere((element) =>
                    element.user!.email.toString() ==
                    "${Prefs.getString(Prefs.EMAIL)}");

                if (index >= 0 == !isWriteShow) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      isWriteShow = true;
                    });
                  });
                }

                ///HERE

                content = RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: state.list!.length,
                    itemBuilder: (context, index) {
                      final item = state.list![index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppCommentItem(
                          item: item,
                          onPressUser: () {
                            _onProfile(item.user!);
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  AppRating(rate: rate),
                  const SizedBox(height: 16),
                  Expanded(child: content),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
