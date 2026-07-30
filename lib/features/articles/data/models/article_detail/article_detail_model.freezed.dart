// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArticleDetailModel _$ArticleDetailModelFromJson(Map<String, dynamic> json) {
  return _ArticleDetailModel.fromJson(json);
}

/// @nodoc
mixin _$ArticleDetailModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'article_date')
  String get articleDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'article_url')
  String get articleUrl => throw _privateConstructorUsedError;
  String get readTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleDetailModelCopyWith<ArticleDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleDetailModelCopyWith<$Res> {
  factory $ArticleDetailModelCopyWith(
          ArticleDetailModel value, $Res Function(ArticleDetailModel) then) =
      _$ArticleDetailModelCopyWithImpl<$Res, ArticleDetailModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'category_id') int categoryId,
      String title,
      String content,
      @JsonKey(name: 'photo_url') String photoUrl,
      @JsonKey(name: 'article_date') String articleDate,
      @JsonKey(name: 'article_url') String articleUrl,
      String readTime});
}

/// @nodoc
class _$ArticleDetailModelCopyWithImpl<$Res, $Val extends ArticleDetailModel>
    implements $ArticleDetailModelCopyWith<$Res> {
  _$ArticleDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? title = null,
    Object? content = null,
    Object? photoUrl = null,
    Object? articleDate = null,
    Object? articleUrl = null,
    Object? readTime = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      articleDate: null == articleDate
          ? _value.articleDate
          : articleDate // ignore: cast_nullable_to_non_nullable
              as String,
      articleUrl: null == articleUrl
          ? _value.articleUrl
          : articleUrl // ignore: cast_nullable_to_non_nullable
              as String,
      readTime: null == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticleDetailModelImplCopyWith<$Res>
    implements $ArticleDetailModelCopyWith<$Res> {
  factory _$$ArticleDetailModelImplCopyWith(_$ArticleDetailModelImpl value,
          $Res Function(_$ArticleDetailModelImpl) then) =
      __$$ArticleDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'category_id') int categoryId,
      String title,
      String content,
      @JsonKey(name: 'photo_url') String photoUrl,
      @JsonKey(name: 'article_date') String articleDate,
      @JsonKey(name: 'article_url') String articleUrl,
      String readTime});
}

/// @nodoc
class __$$ArticleDetailModelImplCopyWithImpl<$Res>
    extends _$ArticleDetailModelCopyWithImpl<$Res, _$ArticleDetailModelImpl>
    implements _$$ArticleDetailModelImplCopyWith<$Res> {
  __$$ArticleDetailModelImplCopyWithImpl(_$ArticleDetailModelImpl _value,
      $Res Function(_$ArticleDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? title = null,
    Object? content = null,
    Object? photoUrl = null,
    Object? articleDate = null,
    Object? articleUrl = null,
    Object? readTime = null,
  }) {
    return _then(_$ArticleDetailModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      articleDate: null == articleDate
          ? _value.articleDate
          : articleDate // ignore: cast_nullable_to_non_nullable
              as String,
      articleUrl: null == articleUrl
          ? _value.articleUrl
          : articleUrl // ignore: cast_nullable_to_non_nullable
              as String,
      readTime: null == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleDetailModelImpl extends _ArticleDetailModel {
  const _$ArticleDetailModelImpl(
      {required this.id,
      @JsonKey(name: 'category_id') this.categoryId = 0,
      required this.title,
      this.content = '',
      @JsonKey(name: 'photo_url') required this.photoUrl,
      @JsonKey(name: 'article_date') this.articleDate = '',
      @JsonKey(name: 'article_url') this.articleUrl = '',
      this.readTime = ''})
      : super._();

  factory _$ArticleDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleDetailModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  final String title;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  @override
  @JsonKey(name: 'article_date')
  final String articleDate;
  @override
  @JsonKey(name: 'article_url')
  final String articleUrl;
  @override
  @JsonKey()
  final String readTime;

  @override
  String toString() {
    return 'ArticleDetailModel(id: $id, categoryId: $categoryId, title: $title, content: $content, photoUrl: $photoUrl, articleDate: $articleDate, articleUrl: $articleUrl, readTime: $readTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.articleDate, articleDate) ||
                other.articleDate == articleDate) &&
            (identical(other.articleUrl, articleUrl) ||
                other.articleUrl == articleUrl) &&
            (identical(other.readTime, readTime) ||
                other.readTime == readTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, title, content,
      photoUrl, articleDate, articleUrl, readTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleDetailModelImplCopyWith<_$ArticleDetailModelImpl> get copyWith =>
      __$$ArticleDetailModelImplCopyWithImpl<_$ArticleDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleDetailModelImplToJson(
      this,
    );
  }
}

abstract class _ArticleDetailModel extends ArticleDetailModel {
  const factory _ArticleDetailModel(
      {required final int id,
      @JsonKey(name: 'category_id') final int categoryId,
      required final String title,
      final String content,
      @JsonKey(name: 'photo_url') required final String photoUrl,
      @JsonKey(name: 'article_date') final String articleDate,
      @JsonKey(name: 'article_url') final String articleUrl,
      final String readTime}) = _$ArticleDetailModelImpl;
  const _ArticleDetailModel._() : super._();

  factory _ArticleDetailModel.fromJson(Map<String, dynamic> json) =
      _$ArticleDetailModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  String get title;
  @override
  String get content;
  @override
  @JsonKey(name: 'photo_url')
  String get photoUrl;
  @override
  @JsonKey(name: 'article_date')
  String get articleDate;
  @override
  @JsonKey(name: 'article_url')
  String get articleUrl;
  @override
  String get readTime;
  @override
  @JsonKey(ignore: true)
  _$$ArticleDetailModelImplCopyWith<_$ArticleDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
