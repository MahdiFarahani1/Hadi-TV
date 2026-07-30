import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/home/domain/usecases/get_home_content_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeContentUseCase getHomeContentUseCase;

  HomeCubit({required this.getHomeContentUseCase}) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    final result = await getHomeContentUseCase();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (content) => emit(
        HomeLoaded(
          featuredVideos: content.featuredVideos,
          featuredArticles: content.featuredArticles,
          latestVideos: content.latestVideos,
          latestArticles: content.latestArticles,
          trending: content.trending,
          recommended: content.recommended,
          liveChannels: content.liveChannels,
        ),
      ),
    );
  }
}
