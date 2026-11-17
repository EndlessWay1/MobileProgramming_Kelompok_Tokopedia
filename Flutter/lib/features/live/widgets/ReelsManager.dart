import 'package:aplikasi_tokped/features/live/widgets/ReelVideo.dart';
import 'package:aplikasi_tokped/models/shopping_item.dart';
import 'package:flutter/material.dart';

class ReelManager extends StatefulWidget {
  final List<ShoppingItem> shopping_item;

  const ReelManager({super.key, required this.shopping_item});

  @override
  State<ReelManager> createState() => _ReelManagerState();
}

class _ReelManagerState extends State<ReelManager> {
  late List<ShoppingItem> itemsAvail;
  late final PageController controller;
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
      itemBuilder: (context, index) {
        return Column(
          children: [
            ReelVideo(
              videoUrl: itemsAvail[index].video,
              key: ValueKey(itemsAvail[index].id),
            ),
          ],
        );
      },
    );
  }
}
