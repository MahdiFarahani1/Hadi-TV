import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class ArticleModel with _$ArticleModel {
  const ArticleModel._();

  const factory ArticleModel({
    required int id,
    @JsonKey(name: 'category_id') @Default(0) int categoryId,
    required String title,
    @JsonKey(name: 'photo_url') @Default('') String photoUrl,
    @Default('') String readTime,
    @JsonKey(name: 'article_date') @Default('') String articleDate,
    @JsonKey(name: 'article_url') @Default('') String articleUrl,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Article toEntity() => Article(
    id: id,
    categoryId: categoryId,
    title: title,
    photoUrl: photoUrl,
    readTime: readTime,
    articleDate: articleDate,
    articleUrl: articleUrl,
  );
}
