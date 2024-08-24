import 'package:flutter/material.dart';

class NavBarItemWidget extends StatelessWidget {
  final Function() onTap;
  final IconData iconData;
  final String text;
  final Color color;

  const NavBarItemWidget({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              size: 30,
              color: color,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w300,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
