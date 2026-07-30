import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

abstract class LiveTvRepository {
  Future<Either<Failure, List<LiveChannel>>> getLiveChannels();
}
