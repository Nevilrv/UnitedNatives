import 'package:flutter/material.dart';

import '../../../data/pref_manager.dart';
import '../../../model/docnotification.dart' as notif;

class DocNotificationListItem extends StatelessWidget {
  final notif.DocNotification notification;
  final void Function()? onTap;

  const DocNotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.isDark();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                notification.icon!,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${notification.body}\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              notification.date!,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
