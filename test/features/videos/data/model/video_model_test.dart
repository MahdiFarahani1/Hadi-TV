import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';
import 'package:haditv/features/videos/data/models/video/video_model.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';

void main() {
  group('video model', () {
    late VideoModel videoModel;
    late Map<String, dynamic> json;

    setUp(() {
      videoModel = const VideoModel(
        id: 1,
        title: 'video 1',
        categoryId: 8,
        dateTime: 2020,
        photoUrl: 'photo.url',
        showCounter: 2,
        speaker: SpeakerModel(id: 1, name: 'reza', photoUrl: 'photo.url'),
        speakerId: 1,
        speakerName: 'reza',
        videoUrl: 'video.url',
        description: 'desc',
        img: 'img.url',
      );
      json = {
        'id': 1,
        'title': 'video 1',
        'category_id': 8,
        'date_time': 2020,
        'photo_url': 'photo.url',
        'show_counter': 2,
        'speaker': {'id': 1, 'name': 'reza', 'photo_url': 'photo.url'},
        'speaker_id': 1,
        'speaker_name': 'reza',
        'video_url': 'video.url',
        'description': 'desc',
        'img': 'img.url',
      };
    });
    test('should use default values when optional fields are missing', () {
      final json = {
        'id': 1,
        'title': 'video 1',
        'category_id': 8,
        'date_time': 2020,
        'photo_url': 'photo.url',
        'show_counter': 2,
        'speaker': {'id': 1, 'name': 'reza', 'photo_url': 'photo.url'},
        'speaker_id': 1,
        'speaker_name': 'reza',
        'video_url': 'video.url',
      };
      final model = VideoModel.fromJson(json);
      expect(model.id, 1);
      expect(model.title, 'video 1');
      expect(model.categoryId, 8);
      expect(model.dateTime, 2020);
      expect(model.photoUrl, 'photo.url');
      expect(model.showCounter, 2);
      expect(
        model.speaker,
        const SpeakerModel(id: 1, name: 'reza', photoUrl: 'photo.url'),
      );
      expect(model.speakerId, 1);
      expect(model.speakerName, 'reza');
      expect(model.videoUrl, 'video.url');
      expect(model.description, null);
      expect(model.img, null);
    });

    test('video model from json test', () {
      final model = VideoModel.fromJson(json);
      expect(model.id, 1);
      expect(model.title, 'video 1');
      expect(model.categoryId, 8);
      expect(model.dateTime, 2020);
      expect(model.photoUrl, 'photo.url');
      expect(model.showCounter, 2);
      expect(
        model.speaker,
        const SpeakerModel(id: 1, name: 'reza', photoUrl: 'photo.url'),
      );
      expect(model.speakerId, 1);
      expect(model.speakerName, 'reza');
      expect(model.videoUrl, 'video.url');
      expect(model.description, 'desc');
      expect(model.img, 'img.url');
    });
    test('video model to entity test', () {
      final entity = videoModel.toEntity();
      expect(entity.id, 1);
      expect(entity.title, 'video 1');
      expect(entity.categoryId, 8);
      expect(entity.dateTime, 2020);
      expect(entity.photoUrl, 'photo.url');
      expect(entity.showCounter, 2);
      expect(
        entity.speaker,
        const Speaker(id: 1, name: 'reza', photoUrl: 'photo.url'),
      );
      expect(entity.speakerId, 1);
      expect(entity.speakerName, 'reza');
      expect(entity.videoUrl, 'video.url');
      expect(entity.description, 'desc');
      expect(entity.img, 'img.url');
    });
  });
}
