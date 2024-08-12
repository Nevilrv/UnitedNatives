import 'package:flutter/material.dart';

import '../../../data/pref_manager.dart';
import '../../../model/notification.dart' as notif;

class NotificationListItem extends StatelessWidget {
  final notif.Notification notification;
  final Function() onTap;

  const NotificationListItem({
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
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(notification.icon!),
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
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${notification.body}\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 18),
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
              notification.date ?? "",
              style: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
