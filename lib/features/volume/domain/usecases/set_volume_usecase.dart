import 'package:haditv/features/volume/domain/repositories/volume_repository.dart';

class SetVolumeUseCase {
  final VolumeRepository repository;

  SetVolumeUseCase(this.repository);

  Future<void> call(double volume) => repository.setVolume(volume);
}
