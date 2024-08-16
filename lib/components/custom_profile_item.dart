import 'package:flutter/material.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';

class CustomProfileItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final Function() onTap;
  final String buttonTitle;
  final String appointmentDate;
  final String? subTitle2;

  const CustomProfileItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.buttonTitle,
    this.subTitle2,
    this.appointmentDate = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // CircleAvatar(
            //   backgroundColor: Colors.transparent,
            //   radius: 25,
            //   backgroundImage: NetworkImage(
            //     imagePath,
            //   ),
            //   onBackgroundImageError: (e, st) {
            //     print("ee -> ${imagePath ?? "Null"} : $e");
            //     return Container();
            //   },
            // ),
            if (imagePath.contains('assets/images/'))
              Utils().imageProfileFromLocal(imagePath, 25)
            else
              Utils().imageProfile(imagePath, 25),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  if (subTitle.isNotEmpty)
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (appointmentDate.isNotEmpty)
                    Visibility(
                      visible: subTitle2 == null ? false : true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${'given at'} $appointmentDate',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              buttonTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontSize: 18, color: kColorBlue),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
