import 'package:flutter/foundation.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

abstract class VideoListState {
  const VideoListState();
}

class VideoListInitial extends VideoListState {
  const VideoListInitial();
}

class VideoListLoading extends VideoListState {
  const VideoListLoading();
}

class VideoListLoaded extends VideoListState {
  final List<VideoCategory> categories;
  final List<Speaker> speakers;
  final List<Video> videos;
  final String selectedCategory;
  final int? selectedGid;
  final int? selectedSpeakerId;
  final int start;
  final bool hasReachedMax;
  final bool isItemsLoading;
  final bool isLoadingMore;

  const VideoListLoaded({
    required this.categories,
    required this.speakers,
    required this.videos,
    required this.selectedCategory,
    this.selectedGid,
    this.selectedSpeakerId,
    required this.start,
    required this.hasReachedMax,
    this.isItemsLoading = false,
    this.isLoadingMore = false,
  });

  VideoListLoaded copyWith({
    List<VideoCategory>? categories,
    List<Speaker>? speakers,
    List<Video>? videos,
    String? selectedCategory,
    ValueGetter<int?>? selectedGid,
    ValueGetter<int?>? selectedSpeakerId,
    int? start,
    bool? hasReachedMax,
    bool? isItemsLoading,
    bool? isLoadingMore,
  }) {
    return VideoListLoaded(
      categories: categories ?? this.categories,
      speakers: speakers ?? this.speakers,
      videos: videos ?? this.videos,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGid: selectedGid != null ? selectedGid() : this.selectedGid,
      selectedSpeakerId: selectedSpeakerId != null
          ? selectedSpeakerId()
          : this.selectedSpeakerId,
      start: start ?? this.start,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isItemsLoading: isItemsLoading ?? this.isItemsLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class VideoListError extends VideoListState {
  final String message;
  const VideoListError(this.message);
}
