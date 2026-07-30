import 'package:equatable/equatable.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';

class Video extends Equatable {
  final int id;
  final int categoryId;
  final String title;
  final String? img;
  final int dateTime;
  final String? description;
  final int speakerId;
  final int showCounter;
  final String videoUrl;
  final String photoUrl;
  final String speakerName;
  final Speaker speaker;

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.img,
    required this.videoUrl,
    required this.dateTime,
    required this.showCounter,
    required this.photoUrl,
    required this.speakerName,
    required this.speaker,
    required this.categoryId,
    required this.speakerId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    img,
    videoUrl,
    dateTime,
    showCounter,
    photoUrl,
    speakerName,
    speaker,
  ];
}
