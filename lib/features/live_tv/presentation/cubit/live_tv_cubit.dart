import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/live_tv/domain/usecases/get_live_channels_usecase.dart';
import 'live_tv_state.dart';

class LiveTvCubit extends Cubit<LiveTvState> {
  final GetLiveChannelsUseCase getLiveChannelsUseCase;

  LiveTvCubit(this.getLiveChannelsUseCase) : super(const LiveTvInitial());

  Future<void> loadChannels({LiveChannel? initialChannel}) async {
    emit(const LiveTvLoading());
    final result = await getLiveChannelsUseCase();

    result.fold(
      (failure) => emit(LiveTvError(failure.message)),
      (channels) {
        if (channels.isEmpty) {
          emit(const LiveTvError('No live channels available right now.'));
          return;
        }

        // Prefer an explicitly passed channel, then the first live channel,
        // then fall back to the first channel in the list.
        final selected = initialChannel ??
            channels.firstWhere(
              (c) => c.isLive,
              orElse: () => channels.first,
            );

        emit(LiveTvLoaded(channels: channels, selectedChannel: selected));
      },
    );
  }

  /// Switch to a different channel. Resets the URL index to 0.
  void selectChannel(LiveChannel channel) {
    if (state is LiveTvLoaded) {
      final current = state as LiveTvLoaded;
      emit(current.copyWith(selectedChannel: channel));
    }
  }

  /// Switch to a different stream URL within the currently selected channel.
  void selectUrl(int urlIndex) {
    if (state is LiveTvLoaded) {
      final current = state as LiveTvLoaded;
      if (urlIndex >= 0 &&
          urlIndex < current.selectedChannel.streamUrls.length) {
        emit(current.copyWith(selectedUrlIndex: urlIndex));
      }
    }
  }
}
