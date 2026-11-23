import 'package:aplikasi_tokped/widgets/custom_image_network.dart';
import 'package:flutter/material.dart';

class ReelBag extends StatelessWidget {
  final String thumbnail;
  final VoidCallback? onTap;

  const ReelBag({super.key, required this.thumbnail, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white, // Added color so the bag is visible
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CustomImageNetwork(imageUrl: thumbnail),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
