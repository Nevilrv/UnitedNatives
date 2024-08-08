import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import '../../../routes/routes.dart';

class AccountWidget extends StatelessWidget {
  final Color color;

  const AccountWidget({super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: color,
          padding: const EdgeInsets.all(15),
          child: Text(
            Translate.of(context).translate('accounts'),
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: Text(
            Translate.of(context).translate('logout'),
            style: const TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.exit_to_app, color: Colors.blue),
          onTap: () => Navigator.of(context).pushNamed(Routes.doctorlogin),
        ),
      ],
    );
  }
}
