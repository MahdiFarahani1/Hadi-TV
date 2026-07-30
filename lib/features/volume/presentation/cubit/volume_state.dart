import 'package:equatable/equatable.dart';

class VolumeState extends Equatable {
  final double volume;
  final double lastNonZeroVolume;

  const VolumeState({
    this.volume = 0.5,
    this.lastNonZeroVolume = 0.5,
  });

  bool get isMuted => volume <= 0.01;
  int get percentage => (volume * 100).round();

  VolumeState copyWith({
    double? volume,
    double? lastNonZeroVolume,
  }) {
    return VolumeState(
      volume: volume ?? this.volume,
      lastNonZeroVolume: lastNonZeroVolume ?? this.lastNonZeroVolume,
    );
  }

  @override
  List<Object?> get props => [volume, lastNonZeroVolume];
}
