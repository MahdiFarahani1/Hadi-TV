abstract class VolumeRepository {
  Future<double> getVolume();
  Future<void> setVolume(double volume);
  Stream<double> watchVolume();
}
