class Produk {
  final String idProduk;
  final String idKategori;
  final String namaProduk;
  final String gambarProduk;
  final String deskripsiProduk;
  final String hargaProduk;
  final String stokProduk;

  Produk({
    required this.idProduk,
    required this.idKategori,
    required this.namaProduk,
    required this.gambarProduk,
    required this.deskripsiProduk,
    required this.hargaProduk,
    required this.stokProduk,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      idProduk: json['Id_Produk'] ?? '',
      idKategori: json['Id_Kategori'] ?? '',
      namaProduk: json['Nama_Produk'] ?? '',
      gambarProduk: json['Gambar_Produk'] ?? '',
      deskripsiProduk: json['Deskripsi_Produk'] ?? '',
      hargaProduk: json['Harga_Produk'] ?? '',
      stokProduk: json['Stok_Produk'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Id_Produk': idProduk,
      'Id_Kategori': idKategori,
      'Nama_Produk': namaProduk,
      'Gambar_Produk': gambarProduk,
      'Deskripsi_Produk': deskripsiProduk,
      'Harga_Produk': hargaProduk,
      'Stok_Produk': stokProduk,
    };
  }
}
