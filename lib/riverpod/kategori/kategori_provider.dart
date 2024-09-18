import 'package:bayduri_app/controller/kategori/kategori_con.dart';
import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kategoriProvider = Provider<KategoriCon>((ref) {
  return KategoriCon();
});

final kategoriListProvider =
    AutoDisposeFutureProvider<List<Kategori>>((ref) async {
  final kategoriCon = ref.watch(kategoriProvider);
  return kategoriCon.getKategori();
});

final addKategoriProvider =
    AutoDisposeFutureProvider.family<String, Kategori>((ref, kategori) async {
  final kategoriCon = ref.read(kategoriProvider);
  return kategoriCon.createKategori(kategori);
});

final updateKategoriProvider =
    AutoDisposeFutureProvider.family<String, Kategori>((ref, kategori) async {
  final kategoriCon = ref.read(kategoriProvider);
  final responseData = await kategoriCon.putKategori(kategori);
  return responseData;
});

final deleteKategoriProvider =
    AutoDisposeFutureProvider.family<String, int>((ref, id) async {
  final kategoriCon = ref.read(kategoriProvider);
  final responseData = await kategoriCon.deleteKategori(id);
  return responseData;
});
