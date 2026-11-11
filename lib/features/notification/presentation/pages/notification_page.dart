import 'package:flutter/material.dart';

import '../widgets/notification_categories.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //header
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        elevation: 0,

        title: const Text(
          'Notifikasi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        actions: const [
          NotificationHeaderIcon(icon: Icons.shopping_cart_outlined, count: 2),

          NotificationHeaderIcon(icon: Icons.chat_bubble_outline, count: 3),

          SizedBox(width: 12),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.zero,

        children: [
          //status pesanan
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status Pesanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: const [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),

                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),

          const OrderStatusCard(),

          const SizedBox(height: 18),

          Container(height: 9, color: const Color(0xFFF2F3F2)),

          const NotificationCategories(),
        ],
      ),
    );
  }
}

class NotificationHeaderIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const NotificationHeaderIcon({
    super.key,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Badge(
        isLabelVisible: count > 0,

        label: Text('$count'),

        backgroundColor: const Color.fromARGB(255, 240, 106, 62),

        textColor: Colors.white,

        child: Icon(
          icon,
          size: 25,
          color: const Color.fromARGB(255, 16, 134, 77),
        ),
      ),
    );
  }
}

//card status pesanan
class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color.fromARGB(255, 232, 232, 232)),
      ),

      child: Row(
        children: [
          //informasi pesanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Pesanan Telah Dikirim',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Klik untuk melacak pesananmu',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),

                const SizedBox(height: 15),
                const Text(
                  'Kemarin, 11:57',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          //placeholder gambar produk
          Container(
            width: 88,
            height: 88,

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 231, 247, 236),
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.inventory_2_outlined,
              size: 38,
              color: Color.fromARGB(255, 12, 116, 66),
            ),
          ),
        ],
      ),
    );
  }
}
