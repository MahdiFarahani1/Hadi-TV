import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/data/datasources/video_remote_data_source.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';
import 'package:haditv/features/videos/data/models/video/video_model.dart';
import 'package:haditv/features/videos/data/models/video_category/video_category_model.dart';
import 'package:haditv/features/videos/data/repositories/video_repository_impl.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoDatasource extends Mock implements VideoRemoteDataSource {}

void main() {
  late MockVideoDatasource mockVideoDatasource;
  late VideoRepositoryImpl videoRepositoryImpl;

  setUp(() {
    mockVideoDatasource = MockVideoDatasource();
    videoRepositoryImpl = VideoRepositoryImpl(mockVideoDatasource);
  });
  group('get Videos', () {
    test(
      'should return Right list of Videos when data source suceeds and search query is provided',
      () async {
        final models = [
          const VideoModel(
            id: 1,
            categoryId: 20,
            title: 'video 1',
            dateTime: 2002 - 02 - 10,
            speakerId: 1,
            showCounter: 10,
            videoUrl: 'video.mp4',
            photoUrl: 'photo.jpg',
            speakerName: 'Ali',
            speaker: SpeakerModel(id: 1, name: 'Ali', photoUrl: 'photo.jpg'),
          ),
          const VideoModel(
            id: 2,
            categoryId: 20,
            title: 'video 2',
            dateTime: 2002 - 02 - 11,
            speakerId: 2,
            showCounter: 10,
            videoUrl: 'video.mp4',
            photoUrl: 'photo.jpg',
            speakerName: 'reza',
            speaker: SpeakerModel(id: 2, name: 'reza', photoUrl: 'photo.jpg'),
          ),
        ];
        when(
          () => mockVideoDatasource.getVideos(),
        ).thenAnswer((_) async => models);
        final result = await videoRepositoryImpl.getVideos();
        expect(result.isRight(), true);
        final videos = result.getOrElse(() => []);
        expect(videos, isA<List<Video>>());
        expect(videos.length, 2);
        expect(videos[0].id, 1);
        expect(videos[0].title, 'video 1');
        final resultSearch = await videoRepositoryImpl.getVideos(
          query: 'video 1',
        );
        expect(resultSearch.isRight(), true);
        final videosSearch = resultSearch.getOrElse(() => []);
        expect(videosSearch.length, 1);
        expect(videosSearch[0].id, 1);
        expect(videosSearch[0].title, 'video 1');

        verify(() => mockVideoDatasource.getVideos()).called(2);
      },
    );

    test(
      'should return Left with Failure when data source throws Failure (videos)',
      () async {
        // Arrange
        const failure = ServerFailure(statusCode: 500, message: 'error');

        when(() => mockVideoDatasource.getVideos()).thenThrow(failure);

        // Act
        final result = await videoRepositoryImpl.getVideos();

        // Assert
        expect(result, const Left(failure));

        verify(() => mockVideoDatasource.getVideos()).called(1);
      },
    );
  });

  group('get Categories', () {
    test(
      'should return Right list of categories when data source suceeds',
      () async {
        final models = [
          const VideoCategoryModel(id: 1, title: 'cat 1', parentId: 0),
          const VideoCategoryModel(id: 2, title: 'cat 2', parentId: 8),
        ];
        when(
          () => mockVideoDatasource.getCategories(),
        ).thenAnswer((_) async => models);
        final result = await videoRepositoryImpl.getCategories();
        expect(result.isRight(), true);
        final categories = result.getOrElse(() => []);
        expect(categories.length, 2);
        expect(categories[0].id, 1);
        expect(categories[0].title, 'cat 1');

        verify(() => mockVideoDatasource.getCategories()).called(1);
      },
    );

    test(
      'should return Left with Failure when data source throws Failure (videos categories)',
      () async {
        // Arrange
        const failure = ServerFailure(statusCode: 500, message: 'error');

        when(() => mockVideoDatasource.getCategories()).thenThrow(failure);

        // Act
        final result = await videoRepositoryImpl.getCategories();

        // Assert
        expect(result, const Left(failure));

        verify(() => mockVideoDatasource.getCategories()).called(1);
      },
    );
  });

  group('get Speakers', () {
    test(
      'should return Right list of speakers when data source suceeds',
      () async {
        final models = [
          const SpeakerModel(id: 1, name: 'Ali', photoUrl: 'photo.jpg'),
          const SpeakerModel(id: 2, name: 'reza', photoUrl: 'photo.jpg'),
        ];
        when(
          () => mockVideoDatasource.getSpeakers(),
        ).thenAnswer((_) async => models);
        final result = await videoRepositoryImpl.getSpeakers();
        expect(result.isRight(), true);
        final categories = result.getOrElse(() => []);
        expect(categories.length, 2);
        expect(categories[0].id, 1);
        expect(categories[0].name, 'Ali');

        verify(() => mockVideoDatasource.getSpeakers()).called(1);
      },
    );

    test(
      'should return Left with Failure when data source throws Failure (speakers)',
      () async {
        // Arrange
        const failure = ServerFailure(statusCode: 500, message: 'error');

        when(() => mockVideoDatasource.getSpeakers()).thenThrow(failure);

        // Act
        final result = await videoRepositoryImpl.getSpeakers();

        // Assert
        expect(result, const Left(failure));

        verify(() => mockVideoDatasource.getSpeakers()).called(1);
      },
    );
  });
}
