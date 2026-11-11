import 'package:flutter/material.dart';

class NotificationCategories extends StatelessWidget {
  const NotificationCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      padding: const EdgeInsets.only(top: 16, bottom: 12),

      child: Column(
        children: [
          //judul section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: const [
                Text(
                  'Update terbaru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                Text(
                  'Tandai sudah dibaca',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          //daftar kategori
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                _CategoryItem(
                  icon: Icons.thumb_up_alt_rounded,
                  label: 'Pilihan Teratas',
                  selected: true,
                  badge: '1',
                ),

                _CategoryItem(icon: Icons.local_offer_outlined, label: 'Promo'),

                _CategoryItem(
                  icon: Icons.live_tv_outlined,
                  label: 'Live & Video',
                ),

                _CategoryItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Keuangan',
                ),

                _CategoryItem(
                  icon: Icons.storefront_outlined,
                  label: 'Info Toko',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//masing2 kategori
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final String? badge;

  const _CategoryItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color.fromARGB(255, 14, 126, 72)
        : Colors.grey.shade600;

    return Container(
      width: 88,
      padding: const EdgeInsets.only(bottom: 8),

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected
                ? const Color.fromARGB(255, 14, 126, 72)
                : Colors.transparent,

            width: 2,
          ),
        ),
      ),

      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,

            children: [
              Icon(icon, size: 27, color: color),

              if (badge != null)
                Positioned(
                  right: -10,
                  top: -8,

                  child: Container(
                    padding: const EdgeInsets.all(3),

                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(243, 107, 63, 1),
                      shape: BoxShape.circle,
                    ),

                    child: Text(
                      badge!,
                      style: const TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,

            maxLines: 2,

            style: TextStyle(
              fontSize: 11,
              color: color,

              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
