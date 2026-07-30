import 'package:haditv/features/volume/data/datasources/volume_local_data_source.dart';
import 'package:haditv/features/volume/domain/repositories/volume_repository.dart';

class VolumeRepositoryImpl implements VolumeRepository {
  final VolumeLocalDataSource _localDataSource;

  VolumeRepositoryImpl(this._localDataSource);

  @override
  Future<double> getVolume() => _localDataSource.getVolume();

  @override
  Future<void> setVolume(double volume) => _localDataSource.setVolume(volume);

  @override
  Stream<double> watchVolume() => _localDataSource.watchVolume();
}
