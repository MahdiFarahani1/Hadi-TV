import 'dart:async';
import 'package:volume_controller/volume_controller.dart';

abstract class VolumeLocalDataSource {
  Future<double> getVolume();
  Future<void> setVolume(double volume);
  Stream<double> watchVolume();
}

class VolumeLocalDataSourceImpl implements VolumeLocalDataSource {
  final VolumeController _volumeController;
  StreamController<double>? _streamController;

  VolumeLocalDataSourceImpl({VolumeController? volumeController})
      : _volumeController = volumeController ?? VolumeController.instance;

  @override
  Future<double> getVolume() async {
    try {
      return await _volumeController.getVolume();
    } catch (_) {
      return 0.5;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      _volumeController.setVolume(volume.clamp(0.0, 1.0));
    } catch (_) {}
  }

  @override
  Stream<double> watchVolume() {
    _streamController ??= StreamController<double>.broadcast(
      onListen: () {
        try {
          _volumeController.addListener((vol) {
            if (!(_streamController?.isClosed ?? true)) {
              _streamController?.add(vol);
            }
          });
        } catch (_) {}
      },
      onCancel: () {
        try {
          _volumeController.removeListener();
        } catch (_) {}
      },
    );
    return _streamController!.stream;
  }
}
