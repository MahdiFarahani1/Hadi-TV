import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/live_tv/domain/repositories/live_tv_repository.dart';
import 'package:haditv/features/live_tv/data/datasources/live_tv_remote_data_source.dart';

class LiveTvRepositoryImpl implements LiveTvRepository {
  final LiveTvRemoteDataSource remoteDataSource;

  LiveTvRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LiveChannel>>> getLiveChannels() async {
    try {
      final models = await remoteDataSource.getLiveChannels();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

