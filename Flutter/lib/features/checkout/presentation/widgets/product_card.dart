import 'package:flutter/material.dart';
import 'package:aplikasi_tokped/core/app_colors.dart';

class CheckoutItem {
  String title;
  int price;
  String brand;
  String thumbnail;
  int quantity;

  CheckoutItem({
    required this.title,
    required this.price,
    this.brand = '',
    this.thumbnail = '',
    this.quantity = 1,
  }) {
    // kadang harga dari dummyjson masih dollar jadi dikali 1000 dulu
    if (price > 0 && price <= 10000) {
      price = price * 1000;
    }
  }
}

// format ribuan pake titik
String formatRp(int angka) {
  bool minus = angka < 0;
  String teks = angka.abs().toString();
  String hasil = '';
  int hitung = 0;

  for (int i = teks.length - 1; i >= 0; i--) {
    hasil = teks[i] + hasil;
    hitung++;
    if (hitung == 3 && i != 0) {
      hasil = '.$hasil';
      hitung = 0;
    }
  }

  if (minus) {
    return '-$hasil';
  }
  return hasil;
}

class ProductCard extends StatelessWidget {
  final CheckoutItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  ProductCard({
    Key? key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, size: 17, color: AppColors.deepGreen),
              SizedBox(width: 6),
              Text(
                item.brand == '' ? 'Official Store' : '${item.brand} Official Store',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPine),
              ),
            ],
          ),
          Divider(thickness: 0.8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.thumbnail,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    SizedBox(height: 6),
                    Text(
                      'Rp ${formatRp(item.price)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.deepGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TODO: tambahin tombol hapus kalau qty 0
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: AppColors.deepGreen, size: 22),
                onPressed: onRemove,
              ),
              Text(
                '${item.quantity}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: AppColors.deepGreen, size: 22),
                onPressed: onAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
