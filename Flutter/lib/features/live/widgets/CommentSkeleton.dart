import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentSkeleton extends StatelessWidget {
  final ScrollController controller;

  const CommentSkeleton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
      ),
      child: ListView.builder(
        controller: controller,
        itemCount: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Bone.circle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // username
                    Bone(
                      width: 90,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    // comment text
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Bone(
                        height: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
