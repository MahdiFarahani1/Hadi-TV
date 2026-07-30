import 'package:equatable/equatable.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

class HomeContent extends Equatable {
  final List<Video> featuredVideos;
  final List<Article> featuredArticles;
  final List<Video> latestVideos;
  final List<Article> latestArticles;
  final List<Video> trending;
  final List<Video> recommended;
  final List<LiveChannel> liveChannels;

  const HomeContent({
    required this.featuredVideos,
    required this.featuredArticles,
    required this.latestVideos,
    required this.latestArticles,
    required this.trending,
    required this.recommended,
    required this.liveChannels,
  });

  @override
  List<Object?> get props => [
    featuredVideos,
    featuredArticles,
    latestVideos,
    latestArticles,
    trending,
    recommended,
    liveChannels,
  ];
}
