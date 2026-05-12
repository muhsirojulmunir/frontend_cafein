class AuthModel {
  final String token;
  final UserData user;
  final String? message;

  AuthModel({
    required this.token,
    required this.user,
    this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthModel(
      token: data['token']?.toString() ?? '',
      user: UserData.fromJson(Map<String, dynamic>.from(data['user'])),
      message: data['message']?.toString(),
    );
  }
}

class UserData {
  final int id;
  final String username;
  final String accountName;
  final String email;
  final int level;
  final int status;
  final EmployeeData? employees;
  final List<BadgeData> badges;

  UserData({
    required this.id,
    required this.username,
    required this.accountName,
    required this.email,
    required this.level,
    required this.status,
    this.employees,
    this.badges = const [],
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: _toInt(json['id']),
      username: json['username']?.toString() ?? '',
      accountName: json['account_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      level: _toInt(json['level'], defaultValue: 5),
      status: _toInt(json['status']),
      employees: json['employees'] != null
          ? EmployeeData.fromJson(Map<String, dynamic>.from(json['employees']))
          : null,
      badges: json['badges'] != null
          ? (json['badges'] as List)
              .map((b) => BadgeData.fromJson(Map<String, dynamic>.from(b)))
              .toList()
          : [],
    );
  }

  String get fullname =>
      employees?.fullname ?? accountName;

  /// Safely convert dynamic to int
  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }
}

class BadgeData {
  final int id;
  final String name;
  final String? description;

  BadgeData({
    required this.id,
    required this.name,
    this.description,
  });

  factory BadgeData.fromJson(Map<String, dynamic> json) {
    return BadgeData(
      id: UserData._toInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

class EmployeeData {
  final int id;
  final String fullname;
  final String nickname;
  final String phone;
  final String employeeStatus;

  EmployeeData({
    required this.id,
    required this.fullname,
    required this.nickname,
    required this.phone,
    required this.employeeStatus,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: UserData._toInt(json['id']),
      fullname: json['fullname']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      employeeStatus: json['employee_status']?.toString() ?? '',
    );
  }
}
