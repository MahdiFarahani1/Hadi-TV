// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpeakerModel _$SpeakerModelFromJson(Map<String, dynamic> json) {
  return _SpeakerModel.fromJson(json);
}

/// @nodoc
mixin _$SpeakerModel {
  int get id => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_show')
  int? get idShow => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String get photoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpeakerModelCopyWith<SpeakerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeakerModelCopyWith<$Res> {
  factory $SpeakerModelCopyWith(
    SpeakerModel value,
    $Res Function(SpeakerModel) then,
  ) = _$SpeakerModelCopyWithImpl<$Res, SpeakerModel>;
  @useResult
  $Res call({
    int id,
    String? lang,
    String name,
    String? email,
    String? description,
    String? slug,
    @JsonKey(name: 'id_show') int? idShow,
    @JsonKey(name: 'photo_url') String photoUrl,
  });
}

/// @nodoc
class _$SpeakerModelCopyWithImpl<$Res, $Val extends SpeakerModel>
    implements $SpeakerModelCopyWith<$Res> {
  _$SpeakerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = freezed,
    Object? name = null,
    Object? email = freezed,
    Object? description = freezed,
    Object? slug = freezed,
    Object? idShow = freezed,
    Object? photoUrl = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            lang: freezed == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            idShow: freezed == idShow
                ? _value.idShow
                : idShow // ignore: cast_nullable_to_non_nullable
                      as int?,
            photoUrl: null == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpeakerModelImplCopyWith<$Res>
    implements $SpeakerModelCopyWith<$Res> {
  factory _$$SpeakerModelImplCopyWith(
    _$SpeakerModelImpl value,
    $Res Function(_$SpeakerModelImpl) then,
  ) = __$$SpeakerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? lang,
    String name,
    String? email,
    String? description,
    String? slug,
    @JsonKey(name: 'id_show') int? idShow,
    @JsonKey(name: 'photo_url') String photoUrl,
  });
}

/// @nodoc
class __$$SpeakerModelImplCopyWithImpl<$Res>
    extends _$SpeakerModelCopyWithImpl<$Res, _$SpeakerModelImpl>
    implements _$$SpeakerModelImplCopyWith<$Res> {
  __$$SpeakerModelImplCopyWithImpl(
    _$SpeakerModelImpl _value,
    $Res Function(_$SpeakerModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = freezed,
    Object? name = null,
    Object? email = freezed,
    Object? description = freezed,
    Object? slug = freezed,
    Object? idShow = freezed,
    Object? photoUrl = null,
  }) {
    return _then(
      _$SpeakerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        lang: freezed == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        idShow: freezed == idShow
            ? _value.idShow
            : idShow // ignore: cast_nullable_to_non_nullable
                  as int?,
        photoUrl: null == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeakerModelImpl extends _SpeakerModel {
  const _$SpeakerModelImpl({
    required this.id,
    this.lang,
    required this.name,
    this.email,
    this.description,
    this.slug,
    @JsonKey(name: 'id_show') this.idShow,
    @JsonKey(name: 'photo_url') required this.photoUrl,
  }) : super._();

  factory _$SpeakerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeakerModelImplFromJson(json);

  @override
  final int id;
  @override
  final String? lang;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? description;
  @override
  final String? slug;
  @override
  @JsonKey(name: 'id_show')
  final int? idShow;
  @override
  @JsonKey(name: 'photo_url')
  final String photoUrl;

  @override
  String toString() {
    return 'SpeakerModel(id: $id, lang: $lang, name: $name, email: $email, description: $description, slug: $slug, idShow: $idShow, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeakerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.idShow, idShow) || other.idShow == idShow) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    lang,
    name,
    email,
    description,
    slug,
    idShow,
    photoUrl,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeakerModelImplCopyWith<_$SpeakerModelImpl> get copyWith =>
      __$$SpeakerModelImplCopyWithImpl<_$SpeakerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeakerModelImplToJson(this);
  }
}

abstract class _SpeakerModel extends SpeakerModel {
  const factory _SpeakerModel({
    required final int id,
    final String? lang,
    required final String name,
    final String? email,
    final String? description,
    final String? slug,
    @JsonKey(name: 'id_show') final int? idShow,
    @JsonKey(name: 'photo_url') required final String photoUrl,
  }) = _$SpeakerModelImpl;
  const _SpeakerModel._() : super._();

  factory _SpeakerModel.fromJson(Map<String, dynamic> json) =
      _$SpeakerModelImpl.fromJson;

  @override
  int get id;
  @override
  String? get lang;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get description;
  @override
  String? get slug;
  @override
  @JsonKey(name: 'id_show')
  int? get idShow;
  @override
  @JsonKey(name: 'photo_url')
  String get photoUrl;
  @override
  @JsonKey(ignore: true)
  _$$SpeakerModelImplCopyWith<_$SpeakerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
