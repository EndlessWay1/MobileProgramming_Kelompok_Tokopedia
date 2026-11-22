import 'package:flutter/material.dart';

enum NotificationCategory{
  order,
  promo,
  live,
  finance,
  store,
}

extension NotificationCategoryLabel on NotificationCategory {
  String get label {
    switch (this) {
      case NotificationCategory.order:
        return 'Pesanan';
      case NotificationCategory.promo:
        return 'Promo';
      case NotificationCategory.live:
        return 'Live';
      case NotificationCategory.finance:
        return 'Keuangan';
      case NotificationCategory.store:
        return 'Info Toko';
    }
  }
}

class NotificationData {
  final String id;
  final String storeName;
  final String title;
  final String message;
  final NotificationCategory category;
  //final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;

//imageurl nanti dulu 
  const NotificationData({
    required this.id,
    required this.storeName,
    required this.title,
    required this.message,
    required this.category,
    //required this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

  NotificationData copyWith({
    bool? isRead,
  }) {
    return NotificationData(
      id: id, 
      storeName: storeName, 
      title: title, 
      message: message, 
      category: category, 
      //imageUrl: imageUrl, 
      isRead: isRead ?? this.isRead, 
      createdAt: createdAt,
    );
  }
}


//tes layout (nanti sambungin ke data notification API)
final List<NotificationData> notificationSamples = [
  //Notification data progress
  NotificationData(
    id: 'tes1',
    storeName: 'Gadgetin Store',
    title: 'Pesananmu sedang dikemas',
    message: 'Penjual sedang menyiapkan barang sebelum dikirim.',
    category: NotificationCategory.order,
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(minutes: 15),
    ),
  ),

  NotificationData(
    id: 'tes2',
    storeName: 'daily TCG',
    title: 'Promo spesial untukmu!',
    message: 'Dapatkan potongan harga untuk produk pilihan hari ini.',
    category: NotificationCategory.promo,
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(hours: 1),
    ),
  ),

  NotificationData(
    id: 'tes3',
    storeName: 'Live Shopping',
    title: 'Live shopping sedang berlangsung',
    message: 'Temukan produk menarik dan penawaran khusus dari penjual.',
    category: NotificationCategory.live,
    isRead: true,
    createdAt: DateTime.now().subtract(
      const Duration(hours: 3),
    ),
  ),

  NotificationData(
    id: 'tes4',
    storeName: 'GreenPay',
    title: 'Transaksi berhasil',
    message: 'Pembayaran untuk pesananmu berhasil diproses.',
    category: NotificationCategory.finance,
    isRead: true,
    createdAt: DateTime.now().subtract(
      const Duration(days: 1),
    ),
  ),

  NotificationData(
    id: 'tes5',
    storeName: 'Official Store',
    title: 'Selamat datang di toko kami!',
    message: 'Terima kasih sudah bergabung. Temukan produk terbaru kami disini.',
    category: NotificationCategory.store,
    isRead: true,
    createdAt: DateTime.now().subtract(
      const Duration(days: 2),
    ),
  ),
];


