import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReelSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade400,
      ),
      child: Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            //  likes
            const Center(child: CircularProgressIndicator()),
            Positioned(
              top: 430,
              right: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Bone.circle(size: 28),
                  SizedBox(height: 5),
                  Bone(
                    width: 20,
                    height: 8,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  SizedBox(height: 16),

                  Bone.circle(size: 28),
                  SizedBox(height: 5),
                  Bone(
                    width: 20,
                    height: 8,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  SizedBox(height: 16),

                  Bone.circle(size: 28),
                  SizedBox(height: 5),
                  Bone(
                    width: 20,
                    height: 8,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // expand to full,
    );
  }
}
