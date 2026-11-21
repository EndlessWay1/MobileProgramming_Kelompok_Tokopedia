import 'package:flutter/material.dart';

class NotificationData {
  
  final String storeName;
  final String title;
  final String message;
  final String time;

  final IconData storeIcon;
  final IconData productIcon;

  final Color storeColor;
  final Color productColor;
  final Color backgroundColor;

  const NotificationData({

    required this.storeName,
    required this.title,
    required this.message,
    required this.time,

    required this.storeIcon,
    required this.productIcon,

    required this.storeColor,
    required this.productColor,
    required this.backgroundColor,
  });
}

const List<NotificationData> notificationSamples = [
  //Notification data progress
];


