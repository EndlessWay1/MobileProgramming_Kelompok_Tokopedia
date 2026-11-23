import 'package:aplikasi_tokped/features/live/widgets/ReelSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:aplikasi_tokped/config.dart';

class ReelVideo extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const ReelVideo({super.key, required this.videoUrl, this.isActive = true});

  @override
  State<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<ReelVideo> {
  VideoPlayerController? c; // controller for video

  bool isInitializing = true;
  String? errorMessage;

  bool play = true;

  @override
  void initState() {
    super.initState();

    final id = extractGoogleDriveId(widget.videoUrl);
    if (id == null) {
      isInitializing = false;
      errorMessage = 'Invalid video URL';
      debugPrint(widget.videoUrl);

      return;
    }
    initializeVideo(id);
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

    final id = extractGoogleDriveId(widget.videoUrl);
    if (id == null) {
      setState(() => errorMessage = 'Invalid video URL');
      debugPrint(widget.videoUrl);
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
                  Icon(Icons.favorite_border, size: 28, color: Colors.white),
                  SizedBox(height: 5),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  Icon(Icons.comment, size: 28, color: Colors.white),
                  SizedBox(height: 5),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  Icon(Icons.send, size: 28, color: Colors.white),
                  SizedBox(height: 5),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
