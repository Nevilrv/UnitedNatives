import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../components/custom_circular_indicator.dart';
import '../../components/round_icon_button.dart';
import '../../utils/constants.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              //backgroundColor: Colors.white,
              elevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/doctor_profile.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Translate.of(context)!
                                .translate('available_now')
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xff40E58C),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Tawfiq Bahri',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Text(
                            'Family Provider. Cardiologist',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: 4.5,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[350],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomCircularIndicator(
                      radius: 80,
                      percent: 0.85,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: Translate.of(context)?.translate('good_reviews'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomCircularIndicator(
                      radius: 80,
                      percent: 0.95,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: Translate.of(context)?.translate('total_score'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomCircularIndicator(
                      radius: 80,
                      percent: 0.9,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: Translate.of(context)?.translate('satisfaction'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[350],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  Translate.of(context)!.translate('about'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Provider Tawfiq Bahri, is a Provider primarily located in New York, with another office in Atlantic City, New Jersey. He has 16 years of experience. His specialities include Family Medicine and Cardiology.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    RoundIconButton(
                      onPressed: () {},
                      icon: Icons.message,
                      elevation: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RoundIconButton(
                      onPressed: () {},
                      icon: Icons.phone,
                      elevation: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: SizedBox(
                          height: 48,
                          child: Center(
                            child: Text(
                              Translate.of(context)!
                                  .translate('book_an_appointment')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
