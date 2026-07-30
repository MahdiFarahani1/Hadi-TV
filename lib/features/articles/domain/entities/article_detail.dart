class ArticleDetail {
  int id;
  int categoryId;
  String title;
  String content;
  String photoUrl;
  String readTime;
  String createdAt;
  String articleUrl;

  ArticleDetail({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.photoUrl,
    required this.readTime,
    required this.createdAt,
    required this.articleUrl,
  });
}
