import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

abstract class LiveTvState {
  const LiveTvState();
}

class LiveTvInitial extends LiveTvState {
  const LiveTvInitial();
}

class LiveTvLoading extends LiveTvState {
  const LiveTvLoading();
}

class LiveTvLoaded extends LiveTvState {
  final List<LiveChannel> channels;
  final LiveChannel selectedChannel;

  /// Index of the currently active stream URL within [selectedChannel.streamUrls].
  final int selectedUrlIndex;

  const LiveTvLoaded({
    required this.channels,
    required this.selectedChannel,
    this.selectedUrlIndex = 0,
  });

  /// The URL that the player should currently play.
  String get activeStreamUrl => selectedChannel.urlAt(selectedUrlIndex);

  LiveTvLoaded copyWith({
    List<LiveChannel>? channels,
    LiveChannel? selectedChannel,
    int? selectedUrlIndex,
  }) {
    return LiveTvLoaded(
      channels: channels ?? this.channels,
      selectedChannel: selectedChannel ?? this.selectedChannel,
      // Reset URL index when switching channels, unless explicitly provided.
      selectedUrlIndex: selectedUrlIndex ??
          (selectedChannel != null ? 0 : this.selectedUrlIndex),
    );
  }
}

class LiveTvError extends LiveTvState {
  final String message;
  const LiveTvError(this.message);
}
