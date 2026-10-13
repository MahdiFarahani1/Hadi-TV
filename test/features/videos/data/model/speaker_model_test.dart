import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';

void main() {
  group('speaker model', () {
    late SpeakerModel speakerModel;
    late Map<String, dynamic> json;

    setUp(() {
      speakerModel = const SpeakerModel(
        id: 1,
        name: 'Ali',
        photoUrl: 'ali.jpg',
        description: 'desc',
        slug: 'slug',
        idShow: 1,
        lang: 'en',
        email: 'email',
      );
      json = {'id': 1, 'name': 'Ali', 'photo_url': 'ali.jpg'};
    });
    test('should use default values when optional fields are missing', () {
      final json = {'id': 1, 'name': 'Ali', 'photo_url': 'ali.jpg'};
      final model = SpeakerModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Ali');
      expect(model.photoUrl, 'ali.jpg');
      expect(model.description, null);
      expect(model.slug, null);
      expect(model.idShow, null);
      expect(model.lang, null);
      expect(model.email, null);
    });

    test('speaker model from json test', () {
      final model = SpeakerModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Ali');
      expect(model.photoUrl, 'ali.jpg');
    });
    test('speaker model to entity test', () {
      final entity = speakerModel.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'Ali');
      expect(entity.photoUrl, 'ali.jpg');
      expect(entity.description, 'desc');
      expect(entity.slug, 'slug');
      expect(entity.idShow, 1);
      expect(entity.lang, 'en');
      expect(entity.email, 'email');
    });
  });
}
