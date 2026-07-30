import 'package:equatable/equatable.dart';

/// Domain entity representing a single live TV channel.
///
/// [streamUrls] contains up to 4 stream URLs (live_url1..4) provided by the API.
/// If the list is empty, the channel is considered offline ([isLive] == false).
class LiveChannel extends Equatable {
  final int id;
  final String channelName;
  final String logoUrl;

  /// All available stream URLs for this channel (live_url1 … live_url4).
  /// Empty when the channel is currently off-air.
  final List<String> streamUrls;

  final String currentProgram;
  final String upcomingProgram;

  const LiveChannel({
    required this.id,
    required this.channelName,
    required this.logoUrl,
    required this.streamUrls,
    this.currentProgram = '',
    this.upcomingProgram = '',
  });

  /// Whether this channel is currently broadcasting.
  bool get isLive => streamUrls.isNotEmpty;

  /// Convenience getter – the first (primary) stream URL.
  /// Returns empty string when offline.
  String get primaryUrl => streamUrls.isNotEmpty ? streamUrls.first : '';

  /// Returns the URL at [index], or falls back to the primary URL.
  String urlAt(int index) {
    if (index >= 0 && index < streamUrls.length) return streamUrls[index];
    return primaryUrl;
  }

  @override
  List<Object?> get props => [
    id,
    channelName,
    logoUrl,
    streamUrls,
    currentProgram,
    upcomingProgram,
  ];
}
