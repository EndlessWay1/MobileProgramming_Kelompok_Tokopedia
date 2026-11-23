import 'package:aplikasi_tokped/features/live/widgets/ReelVideo.dart';
import 'package:aplikasi_tokped/models/shopping_item.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class ReelManager extends StatefulWidget {
  final List<ShoppingItem> shopping_item;

  const ReelManager({super.key, required this.shopping_item});

  @override
  State<ReelManager> createState() => _ReelManagerState();
}

class _ReelManagerState extends State<ReelManager> {
  late List<ShoppingItem> itemsAvail;
  late final PageController controller;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    controller = PageController(initialPage: 0, viewportFraction: 1);
    itemsAvail = widget.shopping_item
        .where((json) => json.video.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (itemsAvail.isEmpty) {
      return const Center(child: Text('No videos available'));
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: itemsAvail.length,
      onPageChanged: (i) => setState(() => currentPage = i),
      itemBuilder: (context, index) {
        return ReelVideo(
          key: ValueKey(itemsAvail[index].id),
          isActive: index == currentPage,
          initialStats:
              // The number is randomized, to visualized the fetching data from backend, and make the data more real
              ReelStats(
                likes: Random().nextInt(10) + 10,
                shares: Random().nextInt(5) + 10,
                comments: Random().nextInt(4) + 1,
              ),
          item: itemsAvail[index],
        );
      },
    );
  }
}
