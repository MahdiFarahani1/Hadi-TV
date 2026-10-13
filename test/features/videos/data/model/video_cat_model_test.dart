import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/videos/data/models/video_category/video_category_model.dart';

void main() {
  group('video category model', () {
    late VideoCategoryModel videoCategoryModel;
    late Map<String, dynamic> json;

    setUp(() {
      videoCategoryModel = const VideoCategoryModel(
        id: 1,
        title: 'cat 1',
        parentId: 0,
      );
      json = {'id': 1, 'title': 'cat 1', 'parent_id': 0};
    });
    test('should use default values when optional fields are missing', () {
      final json = {'id': 1, 'title': 'cat 1'};
      final model = VideoCategoryModel.fromJson(json);
      expect(model.id, 1);
      expect(model.title, 'cat 1');
      expect(model.parentId, 0);
    });

    test('video category model from json test', () {
      final model = VideoCategoryModel.fromJson(json);
      expect(model.id, 1);
      expect(model.title, 'cat 1');
      expect(model.parentId, 0);
    });
    test('video category model to entity test', () {
      final entity = videoCategoryModel.toEntity();
      expect(entity.id, 1);
      expect(entity.title, 'cat 1');
      expect(entity.parentId, 0);
    });
  });
}
