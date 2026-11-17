import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:aplikasi_tokped/models/shopping_item.dart';
import 'package:http/http.dart' as http;

Future<List<ShoppingItem>> fetchShoppingItem() async {
  final response = await http.Client().get(
    Uri.parse('http://localhost:5000/api/items'),
  );

  return compute(parseShoppingItem, response.body);
}

List<ShoppingItem> parseShoppingItem(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return parsed['items']
      .map<ShoppingItem>((json) => ShoppingItem.fromJson(json))
      .toList();
}
