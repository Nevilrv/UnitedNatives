import 'package:flutter/material.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';

class HealthConcernItem extends StatelessWidget {
  final String? specialityName;
  final String? specialityImg;
  final Function()? onTap;

  const HealthConcernItem(
      {super.key,
      @required this.onTap,
      @required this.specialityName,
      this.specialityImg});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(specialityImg!),
                radius: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '${Translate.of(context).translate(specialityName!)}\n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
