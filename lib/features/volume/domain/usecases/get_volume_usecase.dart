import 'package:haditv/features/volume/domain/repositories/volume_repository.dart';

class GetVolumeUseCase {
  final VolumeRepository repository;

  GetVolumeUseCase(this.repository);

  Future<double> call() => repository.getVolume();
}
