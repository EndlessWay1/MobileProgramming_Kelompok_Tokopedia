import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelVideo extends StatefulWidget {
  final String videoUrl;

  const ReelVideo({super.key, required this.videoUrl});

  @override
  State<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<ReelVideo> {
  late VideoPlayerController controller;

  bool isInitializing = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  static String? extractGoogleDriveId(String url) {
    final regex = RegExp(r'[?&]id=([^&]+)');
    final match = regex.firstMatch(url);

    return match?.group(1);
  }

  Future<void> initializeVideo() async {
    debugPrint('VIDEO: Starting initialization');
    debugPrint('VIDEO URL: ${extractGoogleDriveId(widget.videoUrl)!}');

    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'http://localhost:5000/api/videos/${extractGoogleDriveId(widget.videoUrl)!}',
      ),
    );

    controller.addListener(videoListener);

    try {
      await controller.initialize();

      if (!mounted) return;

      debugPrint('VIDEO: Initialized successfully');
      debugPrint('VIDEO SIZE: ${controller.value.size}');
      debugPrint('VIDEO DURATION: ${controller.value.duration}');

      setState(() {
        isInitializing = false;
      });

      await controller.play();
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
    if (!mounted) return;

    final value = controller.value;

    if (value.hasError) {
      debugPrint('VIDEO ERROR: ${value.errorDescription}');

      setState(() {
        errorMessage = value.errorDescription;
      });
    }

    if (value.isBuffering) {
      debugPrint('VIDEO: Buffering...');
    }
  }

  @override
  void dispose() {
    controller.removeListener(videoListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          'Video Error:\n$errorMessage',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return const Center(child: Text('Video unavailable'));
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 660,
              child: VideoPlayer(controller),
            ),
            if (value.isBuffering) Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
