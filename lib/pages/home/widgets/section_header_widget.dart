import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final Function()? onPressed;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                  ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          onPressed != null
              ? MaterialButton(
                  onPressed: onPressed,
                  child: Text(
                    Translate.of(context)!.translate('see_all'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
