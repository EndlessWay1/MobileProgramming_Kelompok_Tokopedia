import 'package:flutter/material.dart';
import 'package:aplikasi_tokped/core/app_colors.dart';

class CheckoutItem {
  final String title;
  final int price;
  final String brand;
  final String thumbnail;
  int quantity;

  CheckoutItem({
    required this.title,
    required int price,
    this.brand = '',
    this.thumbnail = '',
    this.quantity = 1,
  }) : price = (price > 0 && price <= 10000) ? price * 1000 : price;
}

String formatHarga(int angka) {
  String str = angka.toString();
  String hasil = '';
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      hasil += ',';
    }
    hasil += str[i];
  }
  return hasil;
}

class ProductCard extends StatelessWidget {
  final CheckoutItem? item;
  final String? title;
  final int? price;
  final String? brand;
  final String? thumbnail;
  final int? quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductCard({
    super.key,
    this.item,
    this.title,
    this.price,
    this.brand,
    this.thumbnail,
    this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cardTitle = item?.title ?? title ?? '';
    int cardPrice = item?.price ?? price ?? 0;
    if (cardPrice > 0 && cardPrice <= 10000) {
      cardPrice *= 1000;
    }
    final cardBrand = item?.brand ?? brand ?? '';
    final cardThumbnail = item?.thumbnail ?? thumbnail ?? '';
    final cardQuantity = item?.quantity ?? quantity ?? 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, size: 18, color: AppColors.deepGreen),
                const SizedBox(width: 8),
                Text(
                  cardBrand.isNotEmpty
                      ? '$cardBrand Official Store'
                      : 'Official Store',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPine),
                ),
              ],
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    cardThumbnail,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: AppColors.paleMintWhite,
                        child: const Icon(Icons.image, color: AppColors.softMint),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${formatHarga(cardPrice)}',
                        style: const TextStyle(
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.deepGreen),
                  onPressed: onRemove,
                ),
                Text(
                  '$cardQuantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPine,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.deepGreen),
                  onPressed: onAdd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
