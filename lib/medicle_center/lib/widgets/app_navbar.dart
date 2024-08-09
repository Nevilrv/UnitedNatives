import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';

enum PageType { map, list }

class AppNavBar extends StatelessWidget {
  final PageType? pageStyle;
  final SortModel? currentSort;
  final VoidCallback? onChangeSort;
  final VoidCallback? onChangeView;
  final VoidCallback? onFilter;
  final IconData? iconModeView;

  const AppNavBar({
    super.key,
    this.pageStyle = PageType.list,
    this.currentSort,
    this.onChangeSort,
    this.iconModeView,
    this.onChangeView,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    String? sortTitle = Translate.of(context)?.translate('sort');
    if (currentSort != null) {
      sortTitle = Translate.of(context)?.translate(currentSort!.title!);
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (currentSort != null)
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: onChangeSort,
                ),
                Text(
                  sortTitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            )
          else
            const SizedBox(),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(iconModeView),
                    onPressed: onChangeView,
                  ),
                  // SizedBox(
                  //   height: 24,
                  //   child: VerticalDivider(
                  //     color: Theme.of(context).dividerColor,
                  //   ),
                  // ),
                ],
              ),
              // IconButton(
              //   icon: const Icon(Icons.track_changes),
              //   onPressed: onFilter,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 16, left: 16),
              //   child: Text(
              //     Translate.of(context).translate('filter'),
              //     style: Theme.of(context).textTheme.subtitle2,
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }
}
