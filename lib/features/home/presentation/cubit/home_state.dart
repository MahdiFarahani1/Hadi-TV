import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Video> featuredVideos;
  final List<Article> featuredArticles;
  final List<Video> latestVideos;
  final List<Article> latestArticles;
  final List<Video> trending;
  final List<Video> recommended;
  final List<LiveChannel> liveChannels;

  const HomeLoaded({
    required this.featuredVideos,
    required this.featuredArticles,
    required this.latestVideos,
    required this.latestArticles,
    required this.trending,
    required this.recommended,
    required this.liveChannels,
  });
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
