import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/articles/data/models/article/article_model.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';

void main() {
  group('ArticleModel', () {
    // =========================================================
    // FROM JSON
    // =========================================================

    group('fromJson', () {
      test('should create ArticleModel from valid JSON', () {
        // Arrange
        final json = {
          'id': 12,
          'category_id': 4,
          'title': 'فدک عطیه الهی',
          'photo_url': 'https://example.com/image.jpg',
          'readTime': '5 min',
          'article_date': '2020-01-17',
          'article_url': 'https://example.com/article',
        };

        // Act
        final result = ArticleModel.fromJson(json);

        // Assert
        expect(result.id, 12);
        expect(result.categoryId, 4);
        expect(result.title, 'فدک عطیه الهی');
        expect(result.photoUrl, 'https://example.com/image.jpg');
        expect(result.readTime, '5 min');
        expect(result.articleDate, '2020-01-17');
        expect(result.articleUrl, 'https://example.com/article');
      });

      test('should use default values when optional fields are missing', () {
        // Arrange
        final json = {'id': 12, 'title': 'فدک عطیه الهی'};

        // Act
        final result = ArticleModel.fromJson(json);

        // Assert
        expect(result.id, 12);
        expect(result.title, 'فدک عطیه الهی');

        expect(result.categoryId, 0);
        expect(result.photoUrl, '');
        expect(result.readTime, '');
        expect(result.articleDate, '');
        expect(result.articleUrl, '');
      });
    });

    // =========================================================
    // TO ENTITY
    // =========================================================

    group('toEntity', () {
      test('should convert ArticleModel to Article correctly', () {
        // Arrange
        const model = ArticleModel(
          id: 12,
          categoryId: 4,
          title: 'فدک عطیه الهی',
          photoUrl: 'https://example.com/image.jpg',
          readTime: '5 min',
          articleDate: '2020-01-17',
          articleUrl: 'https://example.com/article',
        );

        // Act
        final result = model.toEntity();

        // Assert
        expect(result, isA<Article>());
        expect(result.id, 12);
        expect(result.categoryId, 4);
        expect(result.title, 'فدک عطیه الهی');
        expect(result.photoUrl, 'https://example.com/image.jpg');
        expect(result.readTime, '5 min');
        expect(result.articleDate, '2020-01-17');
        expect(result.articleUrl, 'https://example.com/article');
      });
    });
  });
}
