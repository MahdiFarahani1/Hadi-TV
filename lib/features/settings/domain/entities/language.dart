import 'package:equatable/equatable.dart';

/// Domain entity for a display language supported by Hadi TV.
class Language extends Equatable {
  final int id;

  /// English name of the language, e.g. "Farsi"
  final String title;

  /// Native name of the language, e.g. "فارسی"
  final String mainTitle;

  /// ISO abbreviation used in API calls, e.g. "FA"
  final String abbr;

  /// Text direction: "rtl" or "ltr"
  final String direction;

  /// Display order
  final int idShow;

  const Language({
    required this.id,
    required this.title,
    required this.mainTitle,
    required this.abbr,
    required this.direction,
    required this.idShow,
  });

  bool get isRtl => direction.toLowerCase() == 'rtl';

  /// Display label: native name if available, otherwise English name.
  String get displayName => mainTitle.trim().isNotEmpty ? mainTitle.trim() : title;

  @override
  List<Object?> get props => [id, title, mainTitle, abbr, direction, idShow];
}
