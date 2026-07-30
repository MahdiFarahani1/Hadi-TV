import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';

part 'article_detail_model.freezed.dart';
part 'article_detail_model.g.dart';

@freezed
class ArticleDetailModel with _$ArticleDetailModel {
  const ArticleDetailModel._();

  const factory ArticleDetailModel({
    required int id,
    @JsonKey(name: 'category_id') @Default(0) int categoryId,
    required String title,
    @Default('') String content,
    @JsonKey(name: 'photo_url') required String photoUrl,
    @JsonKey(name: 'article_date') @Default('') String articleDate,
    @JsonKey(name: 'article_url') @Default('') String articleUrl,
    @Default('') String readTime,
  }) = _ArticleDetailModel;

  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailModelFromJson(json);

  ArticleDetail toEntity() => ArticleDetail(
    id: id,
    categoryId: categoryId,
    title: title,
    content: content,
    photoUrl: photoUrl,
    readTime: readTime,
    createdAt: articleDate,
    articleUrl: articleUrl,
  );
}
