import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';

class AppDiscoveryItem extends StatelessWidget {
  final DiscoveryModel item;
  final Function(CategoryModel) onSeeMore;
  final Function(ProductModel) onProductDetail;

  const AppDiscoveryItem({
    Key key,
    this.item,
    this.onSeeMore,
    this.onProductDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      item.list.isNotEmpty ? Color(0xff58d68d) : Colors.black,
                ),
                child: FaIcon(
                  item.category.icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.category.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.category.count} ${Translate.of(context).translate('location')}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  log('item.category---------->>>>>>>>$item');
                  onSeeMore(item.category);
                },
                child: Text(
                  Translate.of(context).translate('see_more'),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 15),
          item.list.isNotEmpty
              ? Builder(builder: (context) {
                  return SizedBox(
                    height: 195,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8)
                          .copyWith(bottom: 15),
                      itemBuilder: (context, index) {
                        final product = item.list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AppProductItem(
                            item: product,
                            type: ProductViewType.card,
                            onPressed: () {
                              onProductDetail(product);
                            },
                          ),
                        );
                      },
                      itemCount: item.list.length,
                    ),
                  );
                })
              : SizedBox(),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 150, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 8,
                  width: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: AppProductItem(
                  type: ProductViewType.card,
                ),
              );
            },
            itemCount: List.generate(8, (index) => index).length,
          ),
        ),
      ],
    );
  }
}
