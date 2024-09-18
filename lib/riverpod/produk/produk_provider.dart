import 'package:bayduri_app/controller/produk/produk_con.dart';
import 'package:bayduri_app/model/produk/produk.dart';
import 'package:bayduri_app/view/home/stok/addproduk_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final produkProvider = Provider<ProdukCon>((ref) {
  return ProdukCon();
});

final produkListProvider = AutoDisposeFutureProvider<List<Produk>>((ref) async {
  final produkCon = ref.read(produkProvider);
  return produkCon.getProduk();
});

final addProdukProvider =
    AutoDisposeFutureProvider.family<String, AddProdukParams>(
        (ref, params) async {
  final produkCon = ref.read(produkProvider);
  return produkCon.createProduk(params.produk, params.imageFile);
});

final updateProdukProvider =
    AutoDisposeFutureProvider.family<String, AddProdukParams>(
        (ref, params) async {
  final produkCon = ref.read(produkProvider);
  return produkCon.putProduk(params.produk, params.imageFile);
});

final deleteProdukProvider =
    AutoDisposeFutureProvider.family<String, int>((ref, id) async {
  final produkCon = ref.read(produkProvider);
  final responseData = await produkCon.deleteProduk(id);
  return responseData;
});
