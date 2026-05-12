import 'package:cafein/utils/constants.dart';

class MediaModel {
  final int id;
  final String namaMedia;
  final String? noVolume;
  final String? tahun;
  final String? headline;
  final String cover;
  final String coverUrl;
  final String attachmentUrl;
  final String? keterangan;

  MediaModel({
    required this.id,
    required this.namaMedia,
    this.noVolume,
    this.tahun,
    this.headline,
    required this.cover,
    required this.coverUrl,
    required this.attachmentUrl,
    this.keterangan,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: _toInt(json['id']),
      namaMedia: json['nama_media']?.toString() ?? '',
      noVolume: json['no_volume']?.toString(),
      tahun: json['tahun']?.toString(),
      headline: json['headline']?.toString(),
      cover: json['cover']?.toString() ?? '',
      coverUrl: _fixUrl(json['cover_url']?.toString() ?? ''),
      attachmentUrl: _fixUrl(json['attachment_url']?.toString() ?? ''),
      keterangan: json['keterangan']?.toString(),
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

  /// Replace the host in API-returned URLs with the host from BASE_URL.
  /// e.g. if BASE_URL = http://10.0.2.2:8000/api and
  ///      url = http://localhost:8000/storage/media/cover.jpg
  ///      → returns http://10.0.2.2:8000/storage/media/cover.jpg
  static String _fixUrl(String url) {
    if (url.isEmpty) return url;
    try {
      final baseUri = Uri.parse(AppConstants.BASE_URL);
      final imageUri = Uri.parse(url);
      // Replace scheme + host + port with BASE_URL's
      return imageUri.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
      ).toString();
    } catch (_) {
      return url;
    }
  }
}
