import 'dart:async';

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

enum StateConnection { loading, connected, error }

class NotifierConnection extends StateNotifier<StateConnection> {
  NotifierConnection() : super(StateConnection.loading);

  Future<void> checkconnection() async {
    try {
      state = StateConnection.loading;

      await Future.delayed(const Duration(seconds: 1));

      bool isConnect = await connectToDatabase();

      if (isConnect) {
        state = StateConnection.connected;
      } else {
        state = StateConnection.error;
        startAutoReconnect();
      }
    } catch (e) {
      state = StateConnection.error;
      startAutoReconnect();
    }
  }

  Future<bool> connectToDatabase() async {
    return true;
  }

  void startAutoReconnect() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != StateConnection.connected) {
        checkconnection(); // Cek ulang koneksi jika belum terhubung
      } else {
        timer.cancel(); // Jika sudah terhubung, hentikan timer
      }
    });
  }
}

final connectionProvider =
    StateNotifierProvider<NotifierConnection, StateConnection>((ref) {
  return NotifierConnection()..checkconnection();
});
