import 'dart:math';

import 'package:aplikasi_tokped/features/live/widgets/CommentSheets.dart';
import 'package:aplikasi_tokped/features/live/widgets/ReelBag.dart';
import 'package:aplikasi_tokped/features/live/widgets/ReelSkeleton.dart';
import 'package:aplikasi_tokped/features/product/presentation/pages/product_detail_page.dart';
import 'package:aplikasi_tokped/models/shopping_item.dart';
import 'package:aplikasi_tokped/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:aplikasi_tokped/config.dart';
import 'package:flutter/services.dart';

class ReelStats {
  final int likes, shares, comments;
  const ReelStats({
    required this.likes,
    required this.shares,
    required this.comments,
  });
}

class ReelVideo extends StatefulWidget {
  final ShoppingItem item;

  final bool isActive;
  final ReelStats initialStats;

  // fetching from the db
  // final Stream<ReelStats> statsStream;

  const ReelVideo({
    super.key,
    this.isActive = true,
    required this.initialStats,
    required this.item,
    // required this.statsStream,
  });

  @override
  State<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<ReelVideo> {
  VideoPlayerController? c; // controller for video

  bool isInitializing = true;
  String? errorMessage;

  bool play = true;
  int likes = 0;
  int comments = 0;
  int shares = 0;
  bool liked = false;
  bool shared = false;

  double rotation = 0;

  String? id;

  @override
  void initState() {
    super.initState();
    rotation = Random().nextDouble();

    id = extractGoogleDriveId(widget.item.video);
    if (id == null) {
      isInitializing = false;
      errorMessage = 'Invalid video URL';
      debugPrint(widget.item.video);

      return;
    }
    initializeVideo(id!);

    likes = widget.initialStats.likes;
    comments = widget.initialStats.comments;
    shares = widget.initialStats.shares;
  }

  static String formatNumberCount(int num) {
    // one mill club
    String val = num.toString();
    if (num >= 1_000_000) {
      val = '${val.substring(0, val.length - 3)}M';
    } else if (num >= 1_000) {
      val = '${val.substring(0, val.length - 3)}K';
    }
    return val;
  }

  static String? extractGoogleDriveId(String url) {
    final regex = RegExp(r'[?&]id=([^&]+)');
    final match = regex.firstMatch(url);

    return match?.group(1);
  }

  Future<void> initializeVideo(String id) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse('${AppConfig.baseUrl}/api/videos/$id'),
    );

    c = controller;
    controller.addListener(videoListener);

    try {
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        isInitializing = false;
      });

      if (widget.isActive) await controller.play();
    } catch (e, stackTrace) {
      debugPrint('VIDEO INITIALIZATION FAILED: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        isInitializing = false;
        errorMessage = e.toString();
      });
    }
  }

  void videoListener() {
    if (!mounted || c == null) return;

    final error = c!.value.errorDescription;

    if (c!.value.hasError && error != errorMessage) {
      debugPrint('VIDEO ERROR: $error');

      setState(() {
        errorMessage = error;
      });
    }
  }

  @override
  void dispose() {
    c?.removeListener(videoListener);
    c?.dispose();

    super.dispose();
  }

  void retry() {
    c?.removeListener(videoListener);
    c?.dispose();
    debugPrint('RETRY');

    c = null;

    final id = extractGoogleDriveId(widget.item.video);
    if (id == null) {
      setState(() => errorMessage = 'Invalid video URL');
      debugPrint(widget.item.video);
      return;
    }

    setState(() {
      isInitializing = true;
      errorMessage = null;
    });
    initializeVideo(id);
  }

  @override
  void didUpdateWidget(covariant ReelVideo old) {
    super.didUpdateWidget(old);

    if (c == null || !c!.value.isInitialized) {
      return;
    }

    if (widget.isActive && !old.isActive) {
      play = true;
      c!.play();
    } else if (!widget.isActive && old.isActive) {
      c!.pause();
    }
  }

  Future<void> showCommentsSheet(
    BuildContext context, {
    required String reelId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets the sheet go taller than half the screen
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return CommentsSheet(
            reelId: reelId,
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(
              "An Error has occured: $errorMessage",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF05150E)),
            ),
            SizedBox(height: 10),
            IconButton(
              onPressed: retry,
              icon: Icon(Icons.refresh),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFF28a976),
                hoverColor: Color(0xFF56d7a3),
              ),
            ),
          ],
        ),
      );
    }
    // wait for video controller to be init
    if (isInitializing || c == null || !c!.value.isInitialized) {
      return const ReelSkeleton();
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: c!,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => play = !play);
                play ? c!.play() : c!.pause();
              },
              child: SizedBox(
                width: double.infinity,
                height: 660,
                child: VideoPlayer(c!),
              ),
            ),

            if (value.isBuffering) const CircularProgressIndicator(),

            if (!play)
              CircleAvatar(
                backgroundColor: Colors.white24,
                radius: 35,
                child: Icon(Icons.play_arrow, size: 35),
              ),

            Positioned(
              top: 430,
              right: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // LIKES
                  IconButton(
                    onPressed: () => setState(() {
                      liked = !liked;
                      likes = likes + (liked ? 1 : -1);
                    }),
                    icon: Icon(
                      !liked ? Icons.favorite_border : Icons.favorite,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 5),
                  Text(
                    formatNumberCount(likes),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  // COMMENT
                  IconButton(
                    onPressed: () => showCommentsSheet(context, reelId: id!),
                    icon: Icon(Icons.comment, size: 28, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formatNumberCount(comments),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  // SHARE/SEND
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.item.video),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Video Download Link Copied to clipboard',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      setState(() {
                        if (!shared) {
                          shares = shares + 1;
                          shared = true;
                        }
                      });
                    },
                    icon: Icon(Icons.send, size: 28, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formatNumberCount(shares),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 580,
              left: 30,
              child: Transform.rotate(
                angle: rotation,
                child: ReelBag(
                  thumbnail: widget.item.thumbnail,
                  onTap: () async {
                    c?.pause();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          product: toMock(widget.item),
                          shoppingItem: widget.item,
                        ),
                      ),
                    );
                    if (mounted && play && widget.isActive) c?.play();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
