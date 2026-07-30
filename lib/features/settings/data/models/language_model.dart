import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';

part 'language_model.freezed.dart';
part 'language_model.g.dart';

@freezed
class LanguageModel with _$LanguageModel {
  const LanguageModel._();

  const factory LanguageModel({
    required int id,
    required String title,
    @JsonKey(name: 'main_title') @Default('') String mainTitle,
    required String abbr,
    @Default('ltr') String direction,
    @JsonKey(name: 'id_show') @Default(0) int idShow,
  }) = _LanguageModel;

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageModelFromJson(json);

  Language toEntity() => Language(
    id: id,
    title: title,
    mainTitle: mainTitle,
    abbr: abbr,
    direction: direction,
    idShow: idShow,
  );
}
