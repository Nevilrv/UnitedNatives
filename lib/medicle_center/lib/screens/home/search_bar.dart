import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback? onSearch;
  final VoidCallback? onScan;
  final VoidCallback? onFilter;
  const SearchBar({
    super.key,
    this.onSearch,
    this.onScan,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: TextButton(
            onPressed: onSearch,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      Translate.of(context)!.translate(
                        'search_location',
                      ),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const VerticalDivider(),
                  InkWell(
                    onTap: onScan,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onFilter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Positioned(
                            right: -5,
                            top: 3,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor:
                                  AppBloc.filterCubit.selectedState == null
                                      ? Colors.transparent
                                      : Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
