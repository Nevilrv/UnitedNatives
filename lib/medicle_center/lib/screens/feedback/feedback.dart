import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/medicle_center/lib/widgets/widget.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class WriteReview extends StatefulWidget {
  final ProductModel? product;

  const WriteReview({
    super.key,
    this.product,
  });

  @override
  State<WriteReview> createState() {
    return _WriteReviewState();
  }
}

class _WriteReviewState extends State<WriteReview> {
  final _textReviewController = TextEditingController();
  final _focusReview = FocusNode();
  final UserController _userController = Get.find<UserController>();

  String? _errorReview;
  double _rate = 1;

  @override
  void initState() {
    super.initState();
    _rate = widget.product!.rate!;
  }

  @override
  void dispose() {
    _textReviewController.dispose();
    _focusReview.dispose();
    super.dispose();
  }

  ///On send
  void _onSave() async {
    UtilsMedicalCenter.hiddenKeyboard(context);
    setState(() {
      _errorReview = UtilValidator.validate(_textReviewController.text);
    });
    if (_errorReview == null) {
      final result = await AppBloc.reviewCubit.onSave(
        id: widget.product?.id,
        content: _textReviewController.text,
        rate: _rate,
      );
      if (result) {
        if (!mounted) return;
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context)!.translate('feedback'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Utils().patientProfile(
                              _userController.user.value.profilePic ?? '',
                              _userController.user.value.socialProfilePic ?? '',
                              40),
                        ),
                        // CachedNetworkImage(
                        //   imageUrl: AppBloc.userCubit.state.image,
                        //   imageBuilder: (context, imageProvider) {
                        //     return Container(
                        //       width: 60,
                        //       height: 60,
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         shape: BoxShape.circle,
                        //         image: DecorationImage(
                        //           image: imageProvider,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   placeholder: (context, url) {
                        //     return AppPlaceholder(
                        //       child: Container(
                        //         width: 60,
                        //         height: 60,
                        //         decoration: const BoxDecoration(
                        //           color: Colors.white,
                        //           shape: BoxShape.circle,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   errorWidget: (context, url, error) {
                        //     return AppPlaceholder(
                        //       child: Container(
                        //         width: 60,
                        //         height: 60,
                        //         decoration: const BoxDecoration(
                        //           color: Colors.white,
                        //           shape: BoxShape.circle,
                        //         ),
                        //         child: const Icon(Icons.error),
                        //       ),
                        //     );
                        //   },
                        // )
                      ],
                    ),
                    const SizedBox(height: 6),
                    RatingBar.builder(
                      initialRating: _rate,
                      minRating: 1,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(100),
                      itemCount: 5,
                      itemSize: 24.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rate) {
                        setState(() {
                          _rate = rate;
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Translate.of(context)!.translate('tap_rate'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              Translate.of(context)!.translate('description'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          AppTextInput(
                            hintText: Translate.of(context)?.translate(
                              'input_feedback',
                            ),
                            errorText: _errorReview,
                            focusNode: _focusReview,
                            maxLines: 5,
                            onSubmitted: (text) {
                              _onSave();
                            },
                            onChanged: (text) {
                              setState(() {
                                _errorReview = UtilValidator.validate(
                                  _textReviewController.text,
                                );
                              });
                            },
                            controller: _textReviewController,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Translate.of(context)?.translate('send') ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ).paddingAll(10),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
