class AturanModel {
  final int id;
  final int idJenis;
  final String? nomor;
  final String? tahun;
  final String? tglTerbit;
  final String shortDesc;
  final String? keterangan;
  final String? doc;
  final String? oleh;
  final String namaJenis;
  final List<dynamic> idKategori; // [{id, text}]
  final List<String> namaKategori;
  final String docUrl;
  final List<dynamic> parentData;
  final List<dynamic> childData;
  final String status;

  AturanModel({
    required this.id,
    required this.idJenis,
    this.nomor,
    this.tahun,
    this.tglTerbit,
    required this.shortDesc,
    this.keterangan,
    this.doc,
    this.oleh,
    required this.namaJenis,
    required this.idKategori,
    required this.namaKategori,
    required this.docUrl,
    required this.parentData,
    required this.childData,
    required this.status,
  });

  factory AturanModel.fromJson(Map<String, dynamic> json) {
    return AturanModel(
      id: _toInt(json['id']),
      idJenis: _toInt(json['id_jenis']),
      nomor: json['nomor']?.toString(),
      tahun: json['tahun']?.toString(),
      tglTerbit: json['tgl_terbit']?.toString(),
      shortDesc: json['short_desc']?.toString() ?? '',
      keterangan: json['keterangan']?.toString(),
      doc: json['doc']?.toString(),
      oleh: json['oleh']?.toString(),
      namaJenis: json['nama_jenis']?.toString() ?? '',
      idKategori: json['id_kategori'] is List ? json['id_kategori'] : [],
      namaKategori: (json['nama_kategori'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      docUrl: json['doc_url']?.toString() ?? '',
      parentData: json['parent_data'] is List ? json['parent_data'] : [],
      childData: json['child_data'] is List ? json['child_data'] : [],
      status: json['status']?.toString() ?? 'Berlaku',
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

class JenisModel {
  final int id;
  final String name;

  JenisModel({required this.id, required this.name});

  factory JenisModel.fromJson(Map<String, dynamic> json) {
    return JenisModel(
      id: AturanModel._toInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

class KategoriModel {
  final int id;
  final String name;

  KategoriModel({required this.id, required this.name});

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: AturanModel._toInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}
