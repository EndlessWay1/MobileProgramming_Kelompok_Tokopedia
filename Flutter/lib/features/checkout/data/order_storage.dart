import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderItem {
  String title;
  int price;
  String brand;
  String thumbnail;
  int quantity;

  OrderItem({
    required this.title,
    required this.price,
    required this.brand,
    required this.thumbnail,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'brand': brand,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    return OrderItem(
      title: map['title'] ?? '',
      price: map['price'] ?? 0,
      brand: map['brand'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }
}

class OrderData {
  String id;
  List<OrderItem> items;
  String kurir;
  int ongkir;
  int totalBayar;
  String alamat;
  DateTime createdAt;
  DateTime arriveAt;

  OrderData({
    required this.id,
    required this.items,
    required this.kurir,
    required this.ongkir,
    required this.totalBayar,
    required this.alamat,
    required this.createdAt,
    required this.arriveAt,
  });

  // cek apakah pesanan sudah sampai
  bool get sudahTiba {
    return DateTime.now().compareTo(arriveAt) >= 0;
  }

  Duration get sisaWaktu {
    if (sudahTiba) {
      return Duration.zero;
    }
    return arriveAt.difference(DateTime.now());
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> listItems = [];
    for (var item in items) {
      listItems.add(item.toMap());
    }

    return {
      'id': id,
      'items': listItems,
      'kurir': kurir,
      'ongkir': ongkir,
      'totalBayar': totalBayar,
      'alamat': alamat,
      'createdAt': createdAt.toIso8601String(),
      'arriveAt': arriveAt.toIso8601String(),
    };
  }

  static OrderData fromMap(Map<String, dynamic> map) {
    List rawItems = map['items'] ?? [];
    List<OrderItem> parsedItems = [];
    for (var e in rawItems) {
      parsedItems.add(OrderItem.fromMap(Map<String, dynamic>.from(e)));
    }

    return OrderData(
      id: map['id'] ?? '',
      items: parsedItems,
      kurir: map['kurir'] ?? 'Reguler',
      ongkir: map['ongkir'] ?? 0,
      totalBayar: map['totalBayar'] ?? 0,
      alamat: map['alamat'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      arriveAt: DateTime.parse(map['arriveAt']),
    );
  }
}

class OrderStorage {
  static final _storage = FlutterSecureStorage();
  static const _ordersKey = 'orders_data';
  static final ValueNotifier<int> ordersVersion = ValueNotifier<int>(0);

  static Future<List<OrderData>> getOrders() async {
    try {
      var text = await _storage.read(key: _ordersKey);
      if (text == null || text.trim() == '') {
        return [];
      }

      List decoded = jsonDecode(text);
      List<OrderData> listOrder = [];
      for (var item in decoded) {
        listOrder.add(OrderData.fromMap(Map<String, dynamic>.from(item)));
      }
      return listOrder;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveOrder(OrderData order) async {
    var orders = await getOrders();
    orders.insert(0, order);

    List<Map<String, dynamic>> dataSimpan = [];
    for (var o in orders) {
      dataSimpan.add(o.toMap());
    }

    var jsonString = jsonEncode(dataSimpan);
    await _storage.write(key: _ordersKey, value: jsonString);
    ordersVersion.value++;
  }

  static Future<void> clearOrders() async {
    await _storage.delete(key: _ordersKey);
    ordersVersion.value++;
  }
}
