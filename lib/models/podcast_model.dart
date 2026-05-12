class PodcastModel {
  final int id;
  final String judul;
  final String kategori;
  final String linkYoutube;
  final String thumbnailUrl;
  bool isBookmarked;

  PodcastModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.linkYoutube,
    required this.thumbnailUrl,
    this.isBookmarked = false,
  });

  // Getters for compatibility with existing UI code
  String get title => judul;
  String get category => kategori;
  String get imageUrl => thumbnailUrl;
  String get videoUrl => linkYoutube;
  String get duration => '00:00'; // Placeholder as not in API

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      id: _toInt(json['id']),
      judul: json['judul']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      linkYoutube: json['link_youtube']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
    );
  }

  /// Safely convert dynamic to int
  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }
}
