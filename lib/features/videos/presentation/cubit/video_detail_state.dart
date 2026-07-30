import 'package:haditv/features/videos/domain/entities/video.dart';

abstract class VideoDetailState {
  const VideoDetailState();
}

class VideoDetailInitial extends VideoDetailState {
  const VideoDetailInitial();
}

class VideoDetailLoading extends VideoDetailState {
  const VideoDetailLoading();
}

class VideoDetailLoaded extends VideoDetailState {
  final Video video;
  final List<Video> relatedVideos;

  const VideoDetailLoaded({
    required this.video,
    required this.relatedVideos,
  });

  VideoDetailLoaded copyWith({
    Video? video,
    List<Video>? relatedVideos,
  }) {
    return VideoDetailLoaded(
      video: video ?? this.video,
      relatedVideos: relatedVideos ?? this.relatedVideos,
    );
  }
}

class VideoDetailError extends VideoDetailState {
  final String message;
  const VideoDetailError(this.message);
}
