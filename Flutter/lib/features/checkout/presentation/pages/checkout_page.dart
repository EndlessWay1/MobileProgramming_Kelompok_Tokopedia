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

  CheckoutPage({
    Key? key,
    this.products,
    this.items,
    this.title,
    this.price,
    this.brand,
    this.thumbnail,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CheckoutItem> items = [];

  int ongkir = 10000;
  String kurir = 'Reguler';

  bool isLoading = true;
  String username = '';
  String alamat = '';

  @override
  void initState() {
    super.initState();
    if (widget.products != null && widget.products!.isNotEmpty) {
      items = widget.products!;
    } else if (widget.items != null && widget.items!.isNotEmpty) {
      items = widget.items!;
    } else if (widget.title != null) {
      items.add(
        CheckoutItem(
          title: widget.title!,
          price: widget.price ?? 0,
          brand: widget.brand ?? '',
          thumbnail: widget.thumbnail ?? '',
        ),
      );
    }
    loadUser();
  }

  void loadUser() async {
    var data = await ProfileStorage.getProfile();
    print('data profile: $data');
    var name = (data['username'] ?? '').trim();

    // kalau belum login suruh daftar dulu
    if (name == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
      return;
    }

    setState(() {
      username = name;
      alamat = (data['location'] ?? '').trim();
      isLoading = false;
    });
  }

  int getTotal() {
    int hasil = 0;
    for (var item in items) {
      hasil += item.price * item.quantity;
    }
    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.paleMintWhite,
        body: Center(child: CircularProgressIndicator(color: AppColors.deepGreen)),
      );
    }

    int subtotal = getTotal();
    int totalBayar = subtotal + ongkir;
    int totalQty = 0;
    for (var x in items) {
      totalQty += x.quantity;
    }

    return Scaffold(
      backgroundColor: AppColors.paleMintWhite,
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 19, color: AppColors.deepGreen),
                            SizedBox(width: 6),
                            Text('Alamat Pengiriman',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPine)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(username != '' ? username : 'Nama Penerima',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 3),
                        Text(
                          alamat != '' ? alamat : 'Belum ada alamat pengiriman',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  ...items.map((barang) {
                    return ProductCard(
                      item: barang,
                      onAdd: () {
                        setState(() {
                          barang.quantity++;
                        });
                      },
                      onRemove: () {
                        if (barang.quantity > 1) {
                          setState(() {
                            barang.quantity--;
                          });
                        }
                      },
                    );
                  }),

                  // TODO: nanti tambah pilihan metode pembayaran (transfer / e-wallet)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pilihan Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 8),
                        opsiKurir('Reguler', 'Estimasi 2 menit', 10000),
                        opsiKurir('Fast', 'Estimasi 1 menit', 20000),
                        opsiKurir('Instant', 'Estimasi 30 detik', 30000),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Harga ($totalQty barang)'),
                            Text('Rp ${formatRp(subtotal)}'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ongkos Kirim ($kurir)'),
                              Text('Rp ${formatRp(ongkir)}'),
                            ],
                          ),
                        ),
                        Divider(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Tagihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              'Rp ${formatRp(totalBayar)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.deepGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Tagihan', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text(
                      'Rp ${formatRp(totalBayar)}',
                      style: TextStyle(
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
                    print('bayar sekarang: $totalBayar');
                    // sementara pake dialog aja dulu
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Pembayaran Berhasil'),
                        content: Text('Pesanan untuk $totalQty barang berhasil dibuat!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Selesai'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Bayar Sekarang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget opsiKurir(String nama, String estimasi, int harga) {
    bool dipilih = kurir == nama;
    return InkWell(
      onTap: () {
        setState(() {
          kurir = nama;
          ongkir = harga;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: dipilih ? AppColors.deepGreen : Colors.grey.shade300,
          ),
          color: dipilih ? AppColors.paleMintWhite : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$nama (Rp ${formatRp(harga)})', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(estimasi, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            if (dipilih) Icon(Icons.check_circle, color: AppColors.deepGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
