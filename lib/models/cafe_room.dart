class CafeRoom {
  final int id;
  final String codeIlmu;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  CafeRoom({
    required this.id,
    required this.codeIlmu,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CafeRoom.fromJson(Map<String, dynamic> json) {
    return CafeRoom(
      id: _toInt(json['id']),
      codeIlmu: json['codeIlmu']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }
}
