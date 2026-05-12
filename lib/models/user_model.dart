class UserModel {
  final String status;
  final EmployeeData employee;

  UserModel({required this.status, required this.employee});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      employee: EmployeeData.fromJson(json['data']),
    );
  }
}

class EmployeeData {
  final int id;
  final String namaLengkap;
  final String gender;
  final String noHp;
  final String? foto;
  final String? email;
  final String? alamat;

  EmployeeData({
    required this.id,
    required this.namaLengkap,
    required this.gender,
    required this.noHp,
    this.foto,
    this.email,
    this.alamat,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'],
      namaLengkap: json['nama_lengkap'],
      gender: json['gender'],
      noHp: json['no_hp'],
      foto:
          json['foto_url'], // Assuming Laravel sends full URL or at least path
      email: json['email'],
      alamat: json['alamat'],
    );
  }
}
