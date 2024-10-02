import 'dart:async';

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
