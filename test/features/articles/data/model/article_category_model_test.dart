import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/features/articles/data/models/article_category/article_category_model.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';

void main() {
  group('ArticleCategoryModel', () {
    group('fromJson', () {
      test('should create ArticleCategoryModel from valid JSON', () {
        // Arrange
        final json = {'id': 4, 'parent_id': 21, 'title': 'فدک عطیه الهی'};

        // Act
        final result = ArticleCategoryModel.fromJson(json);

        // Assert
        expect(result.id, 4);
        expect(result.parentId, 21);
        expect(result.title, 'فدک عطیه الهی');
      });
      test('should use default values when optional fields are missing', () {
        // Arrange
        final json = {'id': 4, 'title': 'فدک عطیه الهی'};
        //Act
        final result = ArticleCategoryModel.fromJson(json);
        //Assert
        expect(result.id, 4);
        expect(result.title, 'فدک عطیه الهی');
        expect(result.parentId, 0);
      });
    });
    group('toEntity', () {
      test(
        'should convert ArticleCategoryModel to ArticleCategory correctly',
        () {
          // Arrange
          const model = ArticleCategoryModel(
            id: 4,
            parentId: 21,
            title: 'فدک عطیه الهی',
          );

          // Act
          final result = model.toEntity();

          // Assert
          expect(result, isA<ArticleCategory>());
          expect(result.id, 4);
          expect(result.parentId, 21);
          expect(result.title, 'فدک عطیه الهی');
        },
      );
    });
  });
}
