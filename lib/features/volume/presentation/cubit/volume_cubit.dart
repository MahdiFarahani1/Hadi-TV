import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/volume/domain/usecases/get_volume_usecase.dart';
import 'package:haditv/features/volume/domain/usecases/set_volume_usecase.dart';
import 'package:haditv/features/volume/domain/usecases/watch_volume_usecase.dart';
import 'volume_state.dart';

class VolumeCubit extends Cubit<VolumeState> {
  final GetVolumeUseCase _getVolumeUseCase;
  final SetVolumeUseCase _setVolumeUseCase;
  final WatchVolumeUseCase _watchVolumeUseCase;
  StreamSubscription<double>? _subscription;

  VolumeCubit({
    required GetVolumeUseCase getVolumeUseCase,
    required SetVolumeUseCase setVolumeUseCase,
    required WatchVolumeUseCase watchVolumeUseCase,
  })  : _getVolumeUseCase = getVolumeUseCase,
        _setVolumeUseCase = setVolumeUseCase,
        _watchVolumeUseCase = watchVolumeUseCase,
        super(const VolumeState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final initialVol = await _getVolumeUseCase();
      emit(state.copyWith(
        volume: initialVol,
        lastNonZeroVolume: initialVol > 0 ? initialVol : state.lastNonZeroVolume,
      ));

      _subscription = _watchVolumeUseCase().listen((vol) {
        emit(state.copyWith(
          volume: vol,
          lastNonZeroVolume: vol > 0 ? vol : state.lastNonZeroVolume,
        ));
      });
    } catch (_) {}
  }

  Future<void> setVolume(double newVol) async {
    final clamped = newVol.clamp(0.0, 1.0);
    emit(state.copyWith(
      volume: clamped,
      lastNonZeroVolume: clamped > 0 ? clamped : state.lastNonZeroVolume,
    ));
    await _setVolumeUseCase(clamped);
  }

  Future<void> toggleMute() async {
    if (state.isMuted) {
      final target =
          state.lastNonZeroVolume > 0.05 ? state.lastNonZeroVolume : 0.5;
      await setVolume(target);
    } else {
      await setVolume(0.0);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
