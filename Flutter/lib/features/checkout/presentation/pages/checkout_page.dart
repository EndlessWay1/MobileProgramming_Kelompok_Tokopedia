import 'package:flutter/material.dart';
import 'package:aplikasi_tokped/core/app_colors.dart';
import 'package:aplikasi_tokped/features/checkout/presentation/widgets/product_card.dart';
import 'package:aplikasi_tokped/features/profile/data/secure_storage.dart';
import 'package:aplikasi_tokped/features/profile/presentation/pages/register_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CheckoutItem>? products;
  final List<CheckoutItem>? items;

  final String? title;
  final int? price;
  final String? brand;
  final String? thumbnail;

  const CheckoutPage({
    super.key,
    this.products,
    this.items,
    this.title,
    this.price,
    this.brand,
    this.thumbnail,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CheckoutItem> items = [];

  int shippingCost = 10000;
  String selectedShipping = 'Reguler';

  bool _isLoading = true;
  String _userName = '';
  String _userLocation = '';

  @override
  void initState() {
    super.initState();
    if (widget.products != null && widget.products!.isNotEmpty) {
      items = List.from(widget.products!);
    } else if (widget.items != null && widget.items!.isNotEmpty) {
      items = List.from(widget.items!);
    } else if (widget.title != null) {
      items = [
        CheckoutItem(
          title: widget.title!,
          price: widget.price ?? 0,
          brand: widget.brand ?? '',
          thumbnail: widget.thumbnail ?? '',
          quantity: 1,
        ),
      ];
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStorage.getProfile();
    final username = profile['username']?.trim() ?? '';

    if (username.isEmpty) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
            onRegisterSuccess: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(
                    products: widget.products,
                    items: widget.items,
                    title: widget.title,
                    price: widget.price,
                    brand: widget.brand,
                    thumbnail: widget.thumbnail,
                  ),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _userName = username;
      _userLocation = profile['location']?.trim() ?? '';
      _isLoading = false;
    });
  }

  int totalHarga() {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int totalBarang() {
    int total = 0;
    for (var item in items) {
      total += item.quantity;
    }
    return total;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.paleMintWhite,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.deepGreen),
        ),
      );
    }

    const themeColor = AppColors.deepGreen;
    final int itemTotal = totalHarga();
    final int totalBill = itemTotal + shippingCost;

    return Scaffold(
      backgroundColor: AppColors.paleMintWhite,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: AppColors.deepGreen),
                        SizedBox(width: 8),
                        Text(
                          'Alamat Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPine),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userName.isNotEmpty ? _userName : 'Nama Penerima',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userLocation.isNotEmpty ? _userLocation : 'Belum ada alamat pengiriman',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            for (int i = 0; i < items.length; i++)
              ProductCard(
                item: items[i],
                onAdd: () {
                  setState(() {
                    items[i].quantity++;
                  });
                },
                onRemove: () {
                  if (items[i].quantity > 1) {
                    setState(() {
                      items[i].quantity--;
                    });
                  }
                },
              ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilihan Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Reguler (Rp 10,000)'),
                      subtitle: const Text('Estimasi 2 menit'),
                      trailing: selectedShipping == 'Reguler'
                          ? const Icon(Icons.check, color: themeColor)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedShipping = 'Reguler';
                          shippingCost = 10000;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Fast (Rp 20,000)'),
                      subtitle: const Text('Estimasi 1 menit'),
                      trailing: selectedShipping == 'Same Day'
                          ? const Icon(Icons.check, color: themeColor)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedShipping = 'Same Day';
                          shippingCost = 20000;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Instant (Rp 30,000)'),
                      subtitle: const Text('Estimasi 30 detik'),
                      trailing: selectedShipping == 'Instant'
                          ? const Icon(Icons.check, color: themeColor)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedShipping = 'Instant';
                          shippingCost = 30000;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Harga (${totalBarang()} barang)'),
                        Text('Rp ${formatHarga(itemTotal)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Ongkos Kirim'),
                        Text('Rp ${formatHarga(shippingCost)}'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Tagihan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Rp ${formatHarga(totalBill)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.softMint)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Tagihan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  'Rp ${formatHarga(totalBill)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pembayaran Berhasil'),
                    content: Text('Pesanan untuk ${totalBarang()} barang berhasil dibuat!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Selesai'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
