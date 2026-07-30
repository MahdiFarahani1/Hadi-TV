import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';

part 'video_category_model.freezed.dart';
part 'video_category_model.g.dart';

@freezed
class VideoCategoryModel with _$VideoCategoryModel {
  const VideoCategoryModel._();

  const factory VideoCategoryModel({
    required int id,
    required String title,
    @JsonKey(name: "parent_id") @Default(0) int parentId,
  }) = _VideoCategoryModel;

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$VideoCategoryModelFromJson(json);

  VideoCategory toEntity() =>
      VideoCategory(id: id, title: title, parentId: parentId);
}
