//   const factory import 'package:flutter_test/flutter_test.dart';

// ArticleDetailModel({
//     required int id,
//     @JsonKey(name: 'category_id') @Default(0) int categoryId,
//     required String title,
//     @Default('') String content,
//     @JsonKey(name: 'photo_url') required String photoUrl,
//     @JsonKey(name: 'article_date') @Default('') String articleDate,
//     @JsonKey(name: 'article_url') @Default('') String articleUrl,
//     @Default('') String readTime,
//   }) = _ArticleDetailModel;

import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/articles/data/models/article_detail/article_detail_model.dart';

void main() {
  group('ArticleDetailModel', () {
    group('fromjson', () {
      test('should create ArticleDetailModel from valid JSON', () {
        // Arrange
        final json = {
          'id': 1,
          'category_id': 10,
          'title': 'title',
          'content': 'content',
          'photo_url': 'photo_url',
          'article_date': 'article_date',
          'article_url': 'article_url',
          'readTime': 'readTime',
        };

        // Act
        final result = ArticleDetailModel.fromJson(json);

        // Assert
        expect(result.id, 1);
        expect(result.categoryId, 10);
        expect(result.title, 'title');
        expect(result.content, 'content');
        expect(result.photoUrl, 'photo_url');
        expect(result.articleDate, 'article_date');
        expect(result.articleUrl, 'article_url');
        expect(result.readTime, 'readTime');
      });

      test('should use default values when optional fields are missing', () {
        // Arrange
        final json = {'id': 1, 'title': 'title', 'photo_url': 'photo_url'};

        // Act
        final result = ArticleDetailModel.fromJson(json);

        // Assert
        expect(result.id, 1);
        expect(result.title, 'title');
        expect(result.categoryId, 0);
        expect(result.content, '');
        expect(result.photoUrl, 'photo_url');
        expect(result.articleDate, '');
        expect(result.articleUrl, '');
        expect(result.readTime, '');
      });
    });

    group('toEntity', () {
      test('should convert ArticleDetailModel to ArticleDetail correctly', () {
        // Arrange
        const model = ArticleDetailModel(
          id: 1,
          categoryId: 10,
          title: 'title',
          content: 'content',
          photoUrl: 'photo_url',
          articleDate: 'article_date',
          articleUrl: 'article_url',
          readTime: 'readTime',
        );

        // Act
        final result = model.toEntity();

        // Assert
        expect(result.id, 1);
        expect(result.categoryId, 10);
        expect(result.title, 'title');
        expect(result.content, 'content');
        expect(result.photoUrl, 'photo_url');
        expect(result.createdAt, 'article_date');
        expect(result.articleUrl, 'article_url');
        expect(result.readTime, 'readTime');
      });
    });
  });
}
