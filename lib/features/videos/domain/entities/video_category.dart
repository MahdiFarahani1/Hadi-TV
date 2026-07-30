import 'package:equatable/equatable.dart';

class VideoCategory extends Equatable {
  final int id;
  final String title;
  final int parentId;

  const VideoCategory({
    required this.id,
    required this.title,
    required this.parentId,
  });

  @override
  List<Object?> get props => [id, title, parentId];
}
