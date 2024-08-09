import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';

class CustomRecipeItem extends StatelessWidget {
  final String purpose;
  final String title;
  final String subTitle;
  final String days;
  final String pills;

  const CustomRecipeItem(
      {super.key,
      required this.title,
      required this.purpose,
      required this.subTitle,
      required this.days,
      required this.pills});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Purpose of visit : ",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                ),
                Expanded(
                  child: Text(
                    purpose,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: Image.asset(
                    'assets/images/icon_pill_bottle.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.red.shade700,
                            ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, color: Colors.white),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 75),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context)!.translate('days_of_treat'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        days,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context)!.translate('pill_per_day'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        pills,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
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
