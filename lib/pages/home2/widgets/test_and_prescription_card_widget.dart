import 'package:flutter/material.dart';

class TestAndPrescriptionCardWidget extends StatelessWidget {
  final String? image;
  final String title;
  final String subTitle;

  const TestAndPrescriptionCardWidget(
      {super.key, this.image, required this.title, required this.subTitle});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Card(
      // padding: EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(4),
      //   border: Border.all(color: Colors.grey[200], width: 1),
      //   color: Theme.of(context).cardColor,
      // ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/$image',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: w * 0.63,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 22,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade700,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      subTitle,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w600,
                      ),
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
