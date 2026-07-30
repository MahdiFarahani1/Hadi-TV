import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';

part 'article_category_model.freezed.dart';
part 'article_category_model.g.dart';

@freezed
class ArticleCategoryModel with _$ArticleCategoryModel {
  const ArticleCategoryModel._();

  const factory ArticleCategoryModel({
    required int id,
    @JsonKey(name: "parent_id") @Default(0) int parentId,
    required String title,
  }) = _ArticleCategoryModel;

  factory ArticleCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleCategoryModelFromJson(json);

  ArticleCategory toEntity() =>
      ArticleCategory(id: id, parentId: parentId, title: title);
}
