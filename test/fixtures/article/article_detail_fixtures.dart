import 'package:haditv/features/articles/domain/entities/article_detail.dart';

class ArticleDetailFixtures {
  static final articleDetail = ArticleDetail(
    id: 1,
    categoryId: 10,
    title: 'Test Article Detail',
    content: '<p>This is the <b>article</b> content for testing.</p>',
    photoUrl: 'https://example.com/detail.jpg',
    readTime: '4 min',
    createdAt: '2026-01-01',
    articleUrl: 'https://example.com/article/1',
  );

  static final articleDetailWithoutUrl = ArticleDetail(
    id: 2,
    categoryId: 20,
    title: 'Article Detail Without URL',
    content: '<p>Second content</p>',
    photoUrl: '',
    readTime: '2 min',
    createdAt: '2026-01-02',
    articleUrl: '',
  );
}
