import 'package:aplikasi_tokped/features/live/widgets/ReelSkeleton.dart';
import 'package:aplikasi_tokped/features/live/widgets/ReelsManager.dart';
import 'package:aplikasi_tokped/models/shopping_item.dart';
import 'package:aplikasi_tokped/utils.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late Future<List<ShoppingItem>> shoppingItem;

  @override
  void initState() {
    super.initState();

    shoppingItem = fetchShoppingItem();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FutureBuilder(
          future: shoppingItem,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "An error has occured while loading the video",
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              // return Text(snapshot.data.toString());
              return ReelManager(shopping_item: snapshot.data!);
            } else {
              return ReelSkeleton();
            }
          }),
        ),
      ),
    );
  }
}
