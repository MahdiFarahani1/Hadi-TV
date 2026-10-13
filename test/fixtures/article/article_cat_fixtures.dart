import 'package:haditv/features/articles/domain/entities/article_category.dart';

class ArticleCategoryFixtures {
  static const cat = ArticleCategory(
    id: 1,
    parentId: 0,
    title: 'Test Cat Article',
  );

  static const cat2 = ArticleCategory(
    id: 2,
    parentId: 0,
    title: 'Test Cat2 Article',
  );
  static const cat3 = ArticleCategory(
    id: 3,
    parentId: 0,
    title: 'Test Cat3 Article',
  );
  static final categories = [cat, cat2, cat3];
}
