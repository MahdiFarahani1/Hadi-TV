import 'package:haditv/features/articles/domain/entities/article.dart';

class ArticleFixtures {
  static final article = Article(
    id: 1,
    categoryId: 10,
    title: 'Test Article',
    photoUrl: 'https://example.com/article.jpg',
    readTime: '5 min',
    articleDate: '2026-01-01',
    articleUrl: 'https://example.com/article',
  );

  static final article2 = Article(
    id: 2,
    categoryId: 20,
    title: 'Test Article 2',
    photoUrl: 'https://example.com/article2.jpg',
    readTime: '3 min',
    articleDate: '2026-01-02',
    articleUrl: 'https://example.com/article2',
  );
  static final article3 = Article(
    id: 3,
    categoryId: 20,
    title: 'Test Article 3',
    photoUrl: 'https://example.com/article3.jpg',
    readTime: '3 min',
    articleDate: '2026-01-02',
    articleUrl: 'https://example.com/article3',
  );
  static final articles = [article, article2, article3];
}
