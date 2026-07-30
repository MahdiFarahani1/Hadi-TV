import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';

class GetSpeakersUsecase {
  final VideoRepository repository;

  GetSpeakersUsecase(this.repository);

  Future<Either<Failure, List<Speaker>>> call({String lang = 'en'}) {
    return repository.getSpeakers(lang: lang);
  }
}
