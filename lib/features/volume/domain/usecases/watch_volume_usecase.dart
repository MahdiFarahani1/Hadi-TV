import 'package:haditv/features/volume/domain/repositories/volume_repository.dart';

class WatchVolumeUseCase {
  final VolumeRepository repository;

  WatchVolumeUseCase(this.repository);

  Stream<double> call() => repository.watchVolume();
}
