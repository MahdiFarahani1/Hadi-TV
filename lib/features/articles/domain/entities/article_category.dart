import 'package:equatable/equatable.dart';

class ArticleCategory extends Equatable {
  final int id;
  final int parentId;
  final String title;

  const ArticleCategory({
    required this.id,
    required this.parentId,
    required this.title,
  });

  @override
  List<Object?> get props => [id, parentId, title];
}
