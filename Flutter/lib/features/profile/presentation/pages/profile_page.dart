import 'dart:async';

import 'package:aplikasi_tokped/core/app_colors.dart';
import 'package:aplikasi_tokped/features/checkout/data/order_storage.dart';
import 'package:aplikasi_tokped/features/checkout/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../../data/secure_storage.dart';
import '../widgets/custom_text_field.dart';
import 'register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String location = '';
  bool isLoading = true;
  bool sudahDaftar = false;

  List<OrderData> orders = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadOrders();
    ProfileStorage.profileVersion.addListener(loadProfile);
    OrderStorage.ordersVersion.addListener(loadOrders);

    // cek tiap detik biar badge update kalau pesanan udah nyampe
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    ProfileStorage.profileVersion.removeListener(loadProfile);
    OrderStorage.ordersVersion.removeListener(loadOrders);
    super.dispose();
  }

  void loadProfile() async {
    var data = await ProfileStorage.getProfile();
    if (!mounted) return;

    var name = (data['username'] ?? '').trim();
    setState(() {
      sudahDaftar = name != '';
      username = sudahDaftar ? name : '';
      email = sudahDaftar ? (data['email'] ?? '') : '';
      location = sudahDaftar ? (data['location'] ?? '') : '';
      isLoading = false;
    });
  }

  void loadOrders() async {
    var dataOrder = await OrderStorage.getOrders();
    if (!mounted) return;
    setState(() {
      orders = dataOrder;
    });
  }

  void bukaDialogLogout() {
    var emailC = TextEditingController();
    var passC = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan email dan password akun Anda untuk verifikasi logout.',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              SizedBox(height: 14),
              CustomTextField(
                controller: emailC,
                hint: 'Email',
                icon: Icons.email_outlined,
                type: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: passC,
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Batal',
                style: TextStyle(color: AppColors.deepGreen),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                var inputEmail = emailC.text.trim();
                var inputPass = passC.text;

                // cek email sama password dulu sebelum hapus data
                if (inputEmail == '' || inputPass == '') {
                  showDialog(
                    context: dialogCtx,
                    builder: (c) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Email dan password tidak boleh kosong!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                var sukses = await ProfileStorage.deleteProfile(
                  inputEmail,
                  inputPass,
                );
                if (!mounted) return;

                if (sukses) {
                  if (dialogCtx.mounted) {
                    Navigator.pop(dialogCtx);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil keluar akun'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                  setState(() {
                    sudahDaftar = false;
                    username = '';
                    email = '';
                    location = '';
                  });
                } else {
                  if (!dialogCtx.mounted) return;
                  showDialog(
                    context: dialogCtx,
                    builder: (c) => AlertDialog(
                      title: Text('Gagal'),
                      content: Text('Email atau password salah!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void bukaListPesanan(bool sudahTiba) async {
    var listOrders = await OrderStorage.getOrders();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paleMintWhite,
      builder: (context) {
        return SheetPesanan(orders: listOrders, sudahTiba: sudahTiba);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.paleMintWhite,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    // kalau belum daftar lempar ke halaman register
    if (!sudahDaftar) {
      return RegisterPage(onRegisterSuccess: loadProfile);
    }

    int dikirimCount = 0;
    int sudahTibaCount = 0;
    for (var o in orders) {
      for (var item in o.items) {
        if (o.sudahTiba) {
          sudahTibaCount += item.quantity;
        } else {
          dikirimCount += item.quantity;
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.paleMintWhite,
      appBar: AppBar(
        backgroundColor: AppColors.paleMintWhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkPine,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.softMint,
              child: Icon(
                Icons.person_rounded,
                size: 48,
                color: AppColors.deepGreen,
              ),
            ),
            SizedBox(height: 14),
            Text(
              username,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPine,
              ),
            ),
            SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(fontSize: 14, color: AppColors.deepGreen),
            ),
            SizedBox(height: 22),

            // bagian transaksi
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPine,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.darkPine,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () => bukaListPesanan(false),
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    size: 32,
                                    color: AppColors.darkPine,
                                  ),
                                  if (dikirimCount > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.redAccent,
                                        child: Text(
                                          '$dikirimCount',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Dikirim',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkPine,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => bukaListPesanan(true),
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 32,
                                    color: AppColors.darkPine,
                                  ),
                                  if (sudahTibaCount > 0)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.redAccent,
                                        child: Text(
                                          '$sudahTibaCount',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Sudah tiba',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkPine,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 14),

            // alamat pengiriman
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.softMint,
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.deepGreen,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alamat Pengiriman',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPine,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          location != ''
                              ? location
                              : 'Belum ada alamat pengiriman',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.deepGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: bukaDialogLogout,
                icon: Icon(Icons.logout, color: Colors.redAccent, size: 20),
                label: Text(
                  'Keluar dari Akun',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SheetPesanan extends StatefulWidget {
  final List<OrderData> orders;
  final bool sudahTiba;

  const SheetPesanan({
    super.key,
    required this.orders,
    required this.sudahTiba,
  });

  @override
  State<SheetPesanan> createState() => _SheetPesananState();
}

class _SheetPesananState extends State<SheetPesanan> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // refresh tiap detik supaya countdown jalan
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String duaDigit(int n) => n < 10 ? '0$n' : '$n';

  @override
  Widget build(BuildContext context) {
    List<OrderData> list = [];
    for (var o in widget.orders) {
      if (o.sudahTiba == widget.sudahTiba) {
        list.add(o);
      }
    }

    return SizedBox(
      height: 480,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.sudahTiba ? 'Pesanan Sudah Tiba' : 'Pesanan Dikirim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPine,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        widget.sudahTiba
                            ? 'Belum ada pesanan yang sudah tiba'
                            : 'Belum ada pesanan yang sedang dikirim',
                        style: TextStyle(color: AppColors.deepGreen),
                      ),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        var order = list[i];
                        var tgl =
                            '${duaDigit(order.createdAt.day)}/${duaDigit(order.createdAt.month)}/${order.createdAt.year} ${duaDigit(order.createdAt.hour)}:${duaDigit(order.createdAt.minute)}';
                        var statusText = '';
                        if (widget.sudahTiba) {
                          statusText =
                              'Tiba ${duaDigit(order.arriveAt.hour)}:${duaDigit(order.arriveAt.minute)}:${duaDigit(order.arriveAt.second)}';
                        } else {
                          var sisa = order.sisaWaktu;
                          statusText =
                              'Sisa ${duaDigit(sisa.inMinutes)}:${duaDigit(sisa.inSeconds % 60)}';
                        }

                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tgl,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.softMint,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.deepGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Kurir: ${order.kurir}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Alamat: ${order.alamat != '' ? order.alamat : '-'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Divider(),
                                for (var item in order.items)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        item.thumbnail != ''
                                            ? Image.network(
                                                item.thumbnail,
                                                width: 45,
                                                height: 45,
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) => Icon(
                                                  Icons.shopping_bag_outlined,
                                                ),
                                              )
                                            : Icon(
                                                Icons.shopping_bag_outlined,
                                                size: 32,
                                              ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${item.quantity}x Rp ${formatRp(item.price)}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Pembayaran'),
                                    Text(
                                      'Rp ${formatRp(order.totalBayar)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
