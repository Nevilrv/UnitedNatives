import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomProfileItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final Function onTap;
  final String buttonTitle;
  final String appointmentDate;
  final String subTitle2;

  const CustomProfileItem({
    Key key,
    this.imagePath,
    @required this.title,
    @required this.subTitle,
    @required this.onTap,
    @required this.buttonTitle,
    this.subTitle2,
    this.appointmentDate = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
              Utils().imageProfileFromLocal(imagePath ?? "", 25)
            else
              Utils().imageProfile(imagePath ?? "", 25),
            SizedBox(
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
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  if (subTitle.isNotEmpty)
                    Text(
                      subTitle,
                      style: TextStyle(
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${'given at'} ${appointmentDate ?? ''}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
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
                                  .button
                                  .copyWith(fontSize: 18),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
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
