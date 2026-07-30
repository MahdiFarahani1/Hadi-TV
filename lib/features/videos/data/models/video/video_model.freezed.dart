// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) {
  return _VideoModel.fromJson(json);
}

/// @nodoc
mixin _$VideoModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_title')
  String? get categoryTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_name')
  String? get groupName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get img => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_time')
  int get dateTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'speaker_id')
  int get speakerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_counter')
  int get showCounter => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'speaker_name')
  String get speakerName => throw _privateConstructorUsedError;
  SpeakerModel get speaker => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoModelCopyWith<VideoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoModelCopyWith<$Res> {
  factory $VideoModelCopyWith(
    VideoModel value,
    $Res Function(VideoModel) then,
  ) = _$VideoModelCopyWithImpl<$Res, VideoModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'category_title') String? categoryTitle,
    @JsonKey(name: 'group_name') String? groupName,
    String title,
    String? img,
    @JsonKey(name: 'date_time') int dateTime,
    String? description,
    @JsonKey(name: 'speaker_id') int speakerId,
    @JsonKey(name: 'show_counter') int showCounter,
    @JsonKey(name: 'video_url') String videoUrl,
    @JsonKey(name: 'photo_url') String photoUrl,
    @JsonKey(name: 'speaker_name') String speakerName,
    SpeakerModel speaker,
  });

  $SpeakerModelCopyWith<$Res> get speaker;
}

/// @nodoc
class _$VideoModelCopyWithImpl<$Res, $Val extends VideoModel>
    implements $VideoModelCopyWith<$Res> {
  _$VideoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? categoryTitle = freezed,
    Object? groupName = freezed,
    Object? title = null,
    Object? img = freezed,
    Object? dateTime = null,
    Object? description = freezed,
    Object? speakerId = null,
    Object? showCounter = null,
    Object? videoUrl = null,
    Object? photoUrl = null,
    Object? speakerName = null,
    Object? speaker = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryName: freezed == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryTitle: freezed == categoryTitle
                ? _value.categoryTitle
                : categoryTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            img: freezed == img
                ? _value.img
                : img // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateTime: null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            speakerId: null == speakerId
                ? _value.speakerId
                : speakerId // ignore: cast_nullable_to_non_nullable
                      as int,
            showCounter: null == showCounter
                ? _value.showCounter
                : showCounter // ignore: cast_nullable_to_non_nullable
                      as int,
            videoUrl: null == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: null == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            speakerName: null == speakerName
                ? _value.speakerName
                : speakerName // ignore: cast_nullable_to_non_nullable
                      as String,
            speaker: null == speaker
                ? _value.speaker
                : speaker // ignore: cast_nullable_to_non_nullable
                      as SpeakerModel,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $SpeakerModelCopyWith<$Res> get speaker {
    return $SpeakerModelCopyWith<$Res>(_value.speaker, (value) {
      return _then(_value.copyWith(speaker: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideoModelImplCopyWith<$Res>
    implements $VideoModelCopyWith<$Res> {
  factory _$$VideoModelImplCopyWith(
    _$VideoModelImpl value,
    $Res Function(_$VideoModelImpl) then,
  ) = __$$VideoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'category_title') String? categoryTitle,
    @JsonKey(name: 'group_name') String? groupName,
    String title,
    String? img,
    @JsonKey(name: 'date_time') int dateTime,
    String? description,
    @JsonKey(name: 'speaker_id') int speakerId,
    @JsonKey(name: 'show_counter') int showCounter,
    @JsonKey(name: 'video_url') String videoUrl,
    @JsonKey(name: 'photo_url') String photoUrl,
    @JsonKey(name: 'speaker_name') String speakerName,
    SpeakerModel speaker,
  });

  @override
  $SpeakerModelCopyWith<$Res> get speaker;
}

/// @nodoc
class __$$VideoModelImplCopyWithImpl<$Res>
    extends _$VideoModelCopyWithImpl<$Res, _$VideoModelImpl>
    implements _$$VideoModelImplCopyWith<$Res> {
  __$$VideoModelImplCopyWithImpl(
    _$VideoModelImpl _value,
    $Res Function(_$VideoModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? categoryTitle = freezed,
    Object? groupName = freezed,
    Object? title = null,
    Object? img = freezed,
    Object? dateTime = null,
    Object? description = freezed,
    Object? speakerId = null,
    Object? showCounter = null,
    Object? videoUrl = null,
    Object? photoUrl = null,
    Object? speakerName = null,
    Object? speaker = null,
  }) {
    return _then(
      _$VideoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryName: freezed == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryTitle: freezed == categoryTitle
            ? _value.categoryTitle
            : categoryTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        img: freezed == img
            ? _value.img
            : img // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        speakerId: null == speakerId
            ? _value.speakerId
            : speakerId // ignore: cast_nullable_to_non_nullable
                  as int,
        showCounter: null == showCounter
            ? _value.showCounter
            : showCounter // ignore: cast_nullable_to_non_nullable
                  as int,
        videoUrl: null == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: null == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        speakerName: null == speakerName
            ? _value.speakerName
            : speakerName // ignore: cast_nullable_to_non_nullable
                  as String,
        speaker: null == speaker
            ? _value.speaker
            : speaker // ignore: cast_nullable_to_non_nullable
                  as SpeakerModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoModelImpl extends _VideoModel {
  const _$VideoModelImpl({
    required this.id,
    @JsonKey(name: 'category_id') required this.categoryId,
    @JsonKey(name: 'category_name') this.categoryName,
    @JsonKey(name: 'category_title') this.categoryTitle,
    @JsonKey(name: 'group_name') this.groupName,
    required this.title,
    this.img,
    @JsonKey(name: 'date_time') required this.dateTime,
    this.description,
    @JsonKey(name: 'speaker_id') required this.speakerId,
    @JsonKey(name: 'show_counter') required this.showCounter,
    @JsonKey(name: 'video_url') required this.videoUrl,
    @JsonKey(name: 'photo_url') required this.photoUrl,
    @JsonKey(name: 'speaker_name') required this.speakerName,
    required this.speaker,
  }) : super._();

  factory _$VideoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @override
  @JsonKey(name: 'category_title')
  final String? categoryTitle;
  @override
  @JsonKey(name: 'group_name')
  final String? groupName;
  @override
  final String title;
  @override
  final String? img;
  @override
  @JsonKey(name: 'date_time')
  final int dateTime;
  @override
  final String? description;
  @override
  @JsonKey(name: 'speaker_id')
  final int speakerId;
  @override
  @JsonKey(name: 'show_counter')
  final int showCounter;
  @override
  @JsonKey(name: 'video_url')
  final String videoUrl;
  @override
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  @override
  @JsonKey(name: 'speaker_name')
  final String speakerName;
  @override
  final SpeakerModel speaker;

  @override
  String toString() {
    return 'VideoModel(id: $id, categoryId: $categoryId, categoryName: $categoryName, categoryTitle: $categoryTitle, groupName: $groupName, title: $title, img: $img, dateTime: $dateTime, description: $description, speakerId: $speakerId, showCounter: $showCounter, videoUrl: $videoUrl, photoUrl: $photoUrl, speakerName: $speakerName, speaker: $speaker)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryTitle, categoryTitle) ||
                other.categoryTitle == categoryTitle) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.speakerId, speakerId) ||
                other.speakerId == speakerId) &&
            (identical(other.showCounter, showCounter) ||
                other.showCounter == showCounter) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.speakerName, speakerName) ||
                other.speakerName == speakerName) &&
            (identical(other.speaker, speaker) || other.speaker == speaker));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    categoryId,
    categoryName,
    categoryTitle,
    groupName,
    title,
    img,
    dateTime,
    description,
    speakerId,
    showCounter,
    videoUrl,
    photoUrl,
    speakerName,
    speaker,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoModelImplCopyWith<_$VideoModelImpl> get copyWith =>
      __$$VideoModelImplCopyWithImpl<_$VideoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoModelImplToJson(this);
  }
}

abstract class _VideoModel extends VideoModel {
  const factory _VideoModel({
    required final int id,
    @JsonKey(name: 'category_id') required final int categoryId,
    required final String title,
    final String? img,
    @JsonKey(name: 'date_time') required final int dateTime,
    final String? description,
    @JsonKey(name: 'speaker_id') required final int speakerId,
    @JsonKey(name: 'show_counter') required final int showCounter,
    @JsonKey(name: 'video_url') required final String videoUrl,
    @JsonKey(name: 'photo_url') required final String photoUrl,
    @JsonKey(name: 'speaker_name') required final String speakerName,
    required final SpeakerModel speaker,
  }) = _$VideoModelImpl;
  const _VideoModel._() : super._();

  factory _VideoModel.fromJson(Map<String, dynamic> json) =
      _$VideoModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String? get categoryName;
  @override
  @JsonKey(name: 'category_title')
  String? get categoryTitle;
  @override
  @JsonKey(name: 'group_name')
  String? get groupName;
  @override
  String get title;
  @override
  String? get img;
  @override
  @JsonKey(name: 'date_time')
  int get dateTime;
  @override
  String? get description;
  @override
  @JsonKey(name: 'speaker_id')
  int get speakerId;
  @override
  @JsonKey(name: 'show_counter')
  int get showCounter;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl;
  @override
  @JsonKey(name: 'photo_url')
  String get photoUrl;
  @override
  @JsonKey(name: 'speaker_name')
  String get speakerName;
  @override
  SpeakerModel get speaker;
  @override
  @JsonKey(ignore: true)
  _$$VideoModelImplCopyWith<_$VideoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
