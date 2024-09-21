class Pengguna {
  final String idPengguna;
  final String idJabatan;
  final String namaPengguna;
  final String nomorPengguna;
  final String gambarPengguna;
  final String username;
  final String password;

  Pengguna({
    required this.idPengguna,
    required this.idJabatan,
    required this.namaPengguna,
    required this.nomorPengguna,
    required this.gambarPengguna,
    required this.username,
    required this.password,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      idPengguna: json['Id_Pengguna'] ?? '',
      idJabatan: json['Id_Jabatan'] ?? '',
      namaPengguna: json['Nama_Pengguna'] ?? '',
      nomorPengguna: json['Nomor_Pengguna'] ?? '',
      gambarPengguna: json['Gambar_Pengguna'] ?? '',
      username: json['Username'] ?? '',
      password: json['Password'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Id_Pengguna': idPengguna,
      'Id_Jabatan': idJabatan,
      'Nama_Pengguna': namaPengguna,
      'Nomor_Pengguna': nomorPengguna,
      'Gambar_Pengguna': gambarPengguna,
      'Username': username,
      'Password': password,
    };
  }
}
