import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:united_natives/medicle_center/lib/widgets/widget.dart';
import 'package:flutter/material.dart';

class AppBottomPicker extends StatelessWidget {
  final PickerModel? picker;

  const AppBottomPicker({
    super.key,
    this.picker,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Column(
                  children: picker!.data!.map((item) {
                    Widget? trailing;
                    String title = '';
                    if (item is String) {
                      title = item;
                    } else {
                      title = item.title;
                    }
                    if (picker!.selected!.contains(item)) {
                      trailing = Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      );
                    }
                    if (item == picker!.data!.last) {
                      return AppListTitle(
                        title: Translate.of(context)?.translate(title),
                        trailing: trailing!,
                        border: false,
                        onPressed: () {
                          Navigator.pop(context, item);
                        },
                      );
                    }
                    return AppListTitle(
                      title: Translate.of(context)?.translate(title),
                      trailing: trailing!,
                      onPressed: () {
                        Navigator.pop(context, item);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
