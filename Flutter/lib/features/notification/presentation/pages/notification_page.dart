import 'package:flutter/material.dart';

import '../../data/notification_data.dart';
import '../widgets/notification_categories.dart';
import 'package:aplikasi_tokped/core/app_colors.dart';
import '../widgets/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationData> _notifications;

  NotificationCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    // sementara pake data preview
    _notifications = List.of(notificationSamples);
  }

  bool get _hasUnread {
    return _notifications.any((notification) => !notification.isRead);
  }

  List<NotificationData> get _filteredNotifications {
    final result = _notifications.where((notification) {
      if (_selectedCategory == null) {
        return true;
      }

      return notification.category == _selectedCategory;
    }).toList();

    result.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return result;
  }

  void _markAllAsRead() {
    if (!_hasUnread) return;

    setState(() {
      _notifications = _notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();
    });
  }

  void _markAsRead(String id) {
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );

    if (index == -1 || _notifications[index].isRead) {
      return;
    }

    setState(() {
      _notifications[index] =
          _notifications[index].copyWith(isRead: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleNotifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: AppColors.paleMint,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.darkPine,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),

        children: [
          // Ringkasan pesanan
          const _OrderProgressCard(),

          const SizedBox(height: 24),

          // Judul dan tombol baca semua
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Update Terbaru',
                style: TextStyle(
                  color: AppColors.darkPine,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextButton.icon(
                onPressed: _hasUnread ? _markAllAsRead : null,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(
                  Icons.done_all_rounded,
                  size: 17,
                ),
                label: const Text(
                  'Baca semua',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filter kategori
          NotificationCategories(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),

          const SizedBox(height: 17),

          // Daftar notifikasi
          if (visibleNotifications.isEmpty)
            const _EmptyNotificationState()
          else
            ...visibleNotifications.map((notification) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NotificationItem(
                  notification: notification,
                  onTap: () {
                    _markAsRead(notification.id);
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}

// Kartu ringkasan proses pesanan
class _OrderProgressCard extends StatelessWidget {
  const _OrderProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: AppColors.paleMint,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.deepGreen,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perjalanan Pesanan',
                      style: TextStyle(
                        color: AppColors.darkPine,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Pantau proses pesananmu dalam satu tempat.',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          const SizedBox(height: 15),

          // tahapan pesanan
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _OrderStage(
                icon: Icons.inventory_2_outlined,
                label: 'Dikemas',
              ),

              _OrderConnector(),

              _OrderStage(
                icon: Icons.local_shipping_outlined,
                label: 'Dikirim',
              ),

              _OrderConnector(),

              _OrderStage(
                icon: Icons.task_alt_outlined,
                label: 'Selesai',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStage extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OrderStage({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            color: AppColors.paleMint,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.deepGreen,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.mutedText,
          ),
        ),
      ],
    );
  }
}

class _OrderConnector extends StatelessWidget {
  const _OrderConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 2,
      color: AppColors.softMint,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}

class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 42,
            color: AppColors.softMint,
          ),

          SizedBox(height: 12),

          Text(
            'Belum ada notifikasi',
            style: TextStyle(
              color: AppColors.darkPine,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Notifikasi untuk kategori ini akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}