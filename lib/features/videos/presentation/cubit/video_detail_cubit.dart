import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'video_detail_state.dart';

class VideoDetailCubit extends Cubit<VideoDetailState> {
  final GetVideosUseCase getVideosUseCase;

  VideoDetailCubit({required this.getVideosUseCase})
    : super(const VideoDetailInitial());

  Future<void> loadVideo(Video video) async {
    emit(const VideoDetailLoading());
    final result = await getVideosUseCase(
      gid: video.categoryId,
      start: 0,
      limit: 6,
    );

    result.fold((failure) => emit(VideoDetailError(failure.message)), (
      results,
    ) {
      final related = results.where((v) => v.id != video.id).toList();
      emit(VideoDetailLoaded(video: video, relatedVideos: related));
    });
  }
}
