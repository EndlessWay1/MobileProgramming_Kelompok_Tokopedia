import 'package:flutter/material.dart';

import '../../data/notification_data.dart';
import '../../../../core/theme/appColors.dart';

class NotificationItem extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

    IconData get _categoryIcon {
    switch (notification.category) {
      case NotificationCategory.order:
        return Icons.local_shipping_outlined;
      case NotificationCategory.promo:
        return Icons.local_offer_outlined;
      case NotificationCategory.live:
        return Icons.play_circle_outline_rounded;
      case NotificationCategory.finance:
        return Icons.account_balance_wallet_outlined;
      case NotificationCategory.store:
        return Icons.storefront_outlined;
    }
  }

    Color get _categoryColor {
    switch (notification.category) {
      case NotificationCategory.order:
        return AppColors.deepGreen;
      case NotificationCategory.promo:
        return AppColors.primaryGreen;
      case NotificationCategory.live:
        return AppColors.mintAccent;
      case NotificationCategory.finance:
        return AppColors.deepGreen;
      case NotificationCategory.store:
        return AppColors.lightMint;
    }
  }

    String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);

    if (difference.isNegative || difference.inMinutes < 1) {
      return 'Baru saja';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : const Color(0xFFF3FCF7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.border
                  : AppColors.softMint,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ikon dari kategori 
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: AppColors.paleMint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _categoryIcon,
                  color: _categoryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // isi notifikasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: AppColors.darkPine,
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ),

                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      '${notification.storeName}  •  ${_formatTime(notification.createdAt)}',
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}