import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/live_tv/domain/repositories/live_tv_repository.dart';

class GetLiveChannelsUseCase {
  final LiveTvRepository repository;

  GetLiveChannelsUseCase(this.repository);

  Future<Either<Failure, List<LiveChannel>>> call() {
    return repository.getLiveChannels();
  }
}
