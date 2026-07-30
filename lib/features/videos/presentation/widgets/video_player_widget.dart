import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:haditv/config/theme/app_theme.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final Player _player;
  late final VideoController _controller;
  final ValueNotifier<bool> _isInitialized = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Initialize media_kit Player
    _player = Player();
    _controller = VideoController(_player);

    _player.stream.completed.listen((completed) {
      if (completed) {
        // Handle stream completion if needed
      }
    });

    _player.open(Media(widget.videoUrl)).then((_) {
      if (mounted) {
        _isInitialized.value = true;
      }
    });
  }

  @override
  void dispose() {
    _isInitialized.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isInitialized,
          builder: (context, isInitialized, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                if (isInitialized)
                  Video(
                    controller: _controller,
                    controls: MaterialVideoControls,
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
