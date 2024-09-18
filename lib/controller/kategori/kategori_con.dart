import 'dart:convert';

import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:bayduri_app/model/server.dart';
import 'package:dio/dio.dart';

class KategoriCon {
  final dio = Dio(BaseOptions(
    baseUrl: Server.serverKategori,
    contentType: Headers.formUrlEncodedContentType,
  ));

  Future<List<Kategori>> getKategori() async {
    try {
      final response = await dio.get('/get_kategori.php');
      if (response.statusCode == 200) {
        // Jika data adalah string, decode ke JSON
        final jsonData = jsonDecode(response.data as String);
        final data = jsonData['data'];
        if (data is List) {
          List<Kategori> produks =
              data.map((json) => Kategori.fromJson(json)).toList();
          return produks;
        } else {
          throw Exception('Data is not a list');
        }
      } else {
        throw Exception(
            'Failed to load products, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> createKategori(Kategori kategori) async {
    try {
      final response = await dio.post(
        '/add_kategori.php', // Endpoint untuk request POST
        data: {
          'Nama_Kategori':
              kategori.namaK // Data yang akan dikirim dalam body request
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data as String);
        return responseData['message'];
      } else {
        throw Exception(
            'Failed to add category, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal Menambahkan Kategori: $e');
      // Tangani error, misalnya tampilkan pesan kepada pengguna
    }
  }

  Future<String> putKategori(Kategori kategori) async {
    //data yang dikirim
    final data = {
      'Id_Kategori': kategori.idK,
      'Nama_Kategori': kategori.namaK,
    };
    try {
      final response = await dio.put(
        '/update_kategori.php',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data as String);
        return responseData['message'];
      } else {
        throw Exception('status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
  }

  Future<String> deleteKategori(int idKategori) async {
    try {
      final response = await dio.delete(
        '/delete_kategori.php',
        data: {'Id_Kategori': idKategori.toString()},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data as String);
        return responseData['message'];
      } else {
        throw Exception('status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
  }
}
