// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoCategoryModel _$VideoCategoryModelFromJson(Map<String, dynamic> json) {
  return _VideoCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$VideoCategoryModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: "parent_id")
  int get parentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoCategoryModelCopyWith<VideoCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCategoryModelCopyWith<$Res> {
  factory $VideoCategoryModelCopyWith(
          VideoCategoryModel value, $Res Function(VideoCategoryModel) then) =
      _$VideoCategoryModelCopyWithImpl<$Res, VideoCategoryModel>;
  @useResult
  $Res call({int id, String title, @JsonKey(name: "parent_id") int parentId});
}

/// @nodoc
class _$VideoCategoryModelCopyWithImpl<$Res, $Val extends VideoCategoryModel>
    implements $VideoCategoryModelCopyWith<$Res> {
  _$VideoCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? parentId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoCategoryModelImplCopyWith<$Res>
    implements $VideoCategoryModelCopyWith<$Res> {
  factory _$$VideoCategoryModelImplCopyWith(_$VideoCategoryModelImpl value,
          $Res Function(_$VideoCategoryModelImpl) then) =
      __$$VideoCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, @JsonKey(name: "parent_id") int parentId});
}

/// @nodoc
class __$$VideoCategoryModelImplCopyWithImpl<$Res>
    extends _$VideoCategoryModelCopyWithImpl<$Res, _$VideoCategoryModelImpl>
    implements _$$VideoCategoryModelImplCopyWith<$Res> {
  __$$VideoCategoryModelImplCopyWithImpl(_$VideoCategoryModelImpl _value,
      $Res Function(_$VideoCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? parentId = null,
  }) {
    return _then(_$VideoCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoCategoryModelImpl extends _VideoCategoryModel {
  const _$VideoCategoryModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: "parent_id") this.parentId = 0})
      : super._();

  factory _$VideoCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoCategoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: "parent_id")
  final int parentId;

  @override
  String toString() {
    return 'VideoCategoryModel(id: $id, title: $title, parentId: $parentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, parentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoCategoryModelImplCopyWith<_$VideoCategoryModelImpl> get copyWith =>
      __$$VideoCategoryModelImplCopyWithImpl<_$VideoCategoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _VideoCategoryModel extends VideoCategoryModel {
  const factory _VideoCategoryModel(
          {required final int id,
          required final String title,
          @JsonKey(name: "parent_id") final int parentId}) =
      _$VideoCategoryModelImpl;
  const _VideoCategoryModel._() : super._();

  factory _VideoCategoryModel.fromJson(Map<String, dynamic> json) =
      _$VideoCategoryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: "parent_id")
  int get parentId;
  @override
  @JsonKey(ignore: true)
  _$$VideoCategoryModelImplCopyWith<_$VideoCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
