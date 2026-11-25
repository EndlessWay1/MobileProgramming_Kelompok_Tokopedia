import 'package:aplikasi_tokped/core/app_colors.dart';
import 'package:flutter/material.dart';

import '../../data/secure_storage.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterPage({super.key, this.onRegisterSuccess});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var namaC = TextEditingController();
  var emailC = TextEditingController();
  var passC = TextEditingController();
  var alamatC = TextEditingController();

  bool sembunyiPass = true;
  bool loading = false;
  String errorText = '';

  void daftar() async {
    var nama = namaC.text.trim();
    var email = emailC.text.trim();
    var pass = passC.text;
    var alamat = alamatC.text.trim();

    // cek satu-satu input user
    if (nama == '') {
      setState(() {
        errorText = 'Username tidak boleh kosong';
      });
      return;
    }
    if (email == '') {
      setState(() {
        errorText = 'Email tidak boleh kosong';
      });
      return;
    }
    if (!email.contains('@')) {
      setState(() {
        errorText = 'Format email tidak valid';
      });
      return;
    }
    if (pass == '') {
      setState(() {
        errorText = 'Password tidak boleh kosong';
      });
      return;
    }
    if (pass.length < 6) {
      setState(() {
        errorText = 'Password minimal 6 karakter';
      });
      return;
    }
    if (alamat == '') {
      setState(() {
        errorText = 'Alamat pengiriman tidak boleh kosong';
      });
      return;
    }

    setState(() {
      errorText = '';
      loading = true;
    });

    await ProfileStorage.saveProfile(
      username: nama,
      email: email,
      password: pass,
      location: alamat,
    );

    if (!mounted) return;
    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi berhasil!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    if (widget.onRegisterSuccess != null) {
      widget.onRegisterSuccess!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleMintWhite,
      appBar: AppBar(
        backgroundColor: AppColors.paleMintWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkPine),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            SizedBox(height: 8),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.softMint,
              child: Icon(Icons.person, color: AppColors.deepGreen, size: 30),
            ),
            SizedBox(height: 18),
            Text(
              'Daftar Akun',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPine,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Silakan registrasi akun untuk melanjutkan.',
              style: TextStyle(color: AppColors.deepGreen),
            ),
            SizedBox(height: 28),

            CustomTextField(
              controller: namaC,
              hint: 'Username',
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: emailC,
              hint: 'Email',
              type: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: passC,
              hint: 'Password',
              isPassword: sembunyiPass,
              suffix: IconButton(
                icon: Icon(
                  sembunyiPass ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.deepGreen,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    sembunyiPass = !sembunyiPass;
                  });
                },
              ),
            ),
            SizedBox(height: 12),

            CustomTextField(
              controller: alamatC,
              hint: 'Alamat (cth: Jl. Pegangsaan Dua No. 77, Jakarta)',
              type: TextInputType.streetAddress,
            ),

            if (errorText != '')
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorText,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ),

            SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : daftar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  loading ? 'Menyimpan...' : 'Lanjutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
