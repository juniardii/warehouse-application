class Kategori {
  final String idK;
  final String namaK;

  Kategori({
    required this.idK,
    required this.namaK,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idK: json['Id_Kategori'],
      namaK: json['Nama_Kategori'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Id_Kategori': idK,
      'Nama_Kategori': namaK,
    };
  }
}
