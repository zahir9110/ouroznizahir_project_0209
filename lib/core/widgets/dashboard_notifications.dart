import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Type de notification pour le dashboard
enum NotificationType {
  newBooking,
  lowStock,
  newReview,
  payoutReady,
  boostExpired,
  warning,
  info,
}

/// Modèle de notification
class DashboardNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isRead;

  DashboardNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.actionLabel,
    this.onAction,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.newBooking:
        return Icons.confirmation_number;
      case NotificationType.lowStock:
        return Icons.warning_amber_rounded;
      case NotificationType.newReview:
        return Icons.star;
      case NotificationType.payoutReady:
        return Icons.account_balance_wallet;
      case NotificationType.boostExpired:
        return Icons.bolt;
      case NotificationType.warning:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.newBooking:
        return const Color(0xFF10B981); // Green
      case NotificationType.lowStock:
        return const Color(0xFFF59E0B); // Amber
      case NotificationType.newReview:
        return AppColors.accent; // Amber
      case NotificationType.payoutReady:
        return AppColors.primary; // Blue
      case NotificationType.boostExpired:
        return const Color(0xFF6B7280); // Gray
      case NotificationType.warning:
        return const Color(0xFFEF4444); // Red
      case NotificationType.info:
        return AppColors.textSecondary;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

/// Widget de liste de notifications pour le dashboard
class DashboardNotificationsList extends StatelessWidget {
  final List<DashboardNotification> notifications;
  final VoidCallback? onMarkAllRead;
  final Function(DashboardNotification)? onNotificationTap;
  final int maxVisible;

  const DashboardNotificationsList({
    super.key,
    required this.notifications,
    this.onMarkAllRead,
    this.onNotificationTap,
    this.maxVisible = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    final visibleNotifications = notifications.take(maxVisible).toList();
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (unreadCount > 0 && onMarkAllRead != null)
                  TextButton(
                    onPressed: onMarkAllRead,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                    ),
                    child: Text(
                      'Tout marquer lu',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Notifications list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleNotifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = visibleNotifications[index];
              return _NotificationTile(
                notification: notification,
                onTap: onNotificationTap != null
                    ? () => onNotificationTap!(notification)
                    : null,
              );
            },
          ),

          // Voir plus
          if (notifications.length > maxVisible)
            InkWell(
              onTap: () {
                debugPrint('📋 Voir toutes les notifications');
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.h),
                child: Text(
                  'Voir toutes les notifications (${notifications.length})',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget d'une seule notification (tile)
class _NotificationTile extends StatelessWidget {
  final DashboardNotification notification;
  final VoidCallback? onTap;

  const _NotificationTile({
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? notification.onAction,
      child: Container(
        padding: EdgeInsets.all(12.w),
        color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: notification.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 20.r,
              ),
            ),

            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.actionLabel != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      notification.actionLabel!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 8.r,
                height: 8.r,
                margin: EdgeInsets.only(left: 8.w, top: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
