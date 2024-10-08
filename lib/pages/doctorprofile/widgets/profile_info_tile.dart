import 'package:united_natives/utils/pref_manager.dart';
import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String? title, hint, trailing;

  const ProfileInfoTile(
      {super.key, @required this.title, this.hint, this.trailing});
  @override
  Widget build(BuildContext context) {
    var isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            title!,
            maxLines: 10,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            child: Text(
              trailing ?? hint!,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: trailing != null
                    ? isDark
                        ? Colors.white.withOpacity(0.87)
                        : Colors.black
                    : Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Divider(
            height: 0.5, color: Colors.grey[200], indent: 15, endIndent: 15),
      ],
    );
  }
}
