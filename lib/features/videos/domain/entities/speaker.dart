class Speaker {
  final int id;
  final String? lang;
  final String name;
  final String? email;
  final String? description;
  final String? slug;
  final int? idShow;
  final String? photoUrl;

  Speaker({
    required this.id,
    this.lang,
    required this.name,
    this.email,
    this.description,
    this.slug,
    this.idShow,
    required this.photoUrl,
  });
}
