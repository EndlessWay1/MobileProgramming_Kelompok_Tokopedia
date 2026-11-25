import 'package:aplikasi_tokped/core/app_colors.dart';
import 'package:flutter/material.dart';

// widget text field biar ga nulis decoration ulang terus
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool? isPassword;
  final TextInputType? type;
  final Widget? suffix;

  CustomTextField({
    required this.controller,
    required this.hint,
    this.icon,
    this.isPassword,
    this.type,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: rapihin lagi styling bordernya nanti kalau sempet
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.deepGreen, size: 20)
            : null,
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
