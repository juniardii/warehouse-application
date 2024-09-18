import 'dart:convert';
import 'dart:io';

import 'package:bayduri_app/model/produk/produk.dart';
import 'package:bayduri_app/model/server.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class ProdukCon {
  final dio = Dio(BaseOptions(baseUrl: Server.serverProduk));

  Future<List<Produk>> getProduk() async {
    try {
      final response = await dio.get('/get_produk.php');
      if (response.statusCode == 200) {
        // Jika data adalah string, decode ke JSON
        final jsonData = jsonDecode(response.data as String);
        final data = jsonData['data'];
        if (data is List) {
          List<Produk> produks =
              data.map((json) => Produk.fromJson(json)).toList();
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

  Future<String> createProduk(Produk produk, File? imageFile) async {
    try {
      var formData = FormData.fromMap({
        'Id_Kategori': produk.idKategori,
        'Nama_Produk': produk.namaProduk,
        'Deskripsi_Produk': produk.deskripsiProduk,
        'Harga_Produk': produk.hargaProduk,
        'Stok_Produk': produk.stokProduk,
        'Gambar_Produk': imageFile != null
            ? await MultipartFile.fromFile(
                imageFile.path,
                filename: p.basename(imageFile.path),
              )
            : null
      });

      final response = await dio.post(
        '/add_produk.php',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200) {
        final responseD = jsonDecode(response.data as String);
        final responseData = responseD['message'];
        return responseData;
      } else {
        throw Exception('Failed to create Produk');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan. Silakan coba lagi');
    }
  }

  Future<String> putProduk(Produk produk, File? imageFile) async {
    try {
      var formData = FormData.fromMap({
        'Id_Produk': produk.idProduk,
        'Id_Kategori': produk.idKategori,
        'Nama_Produk': produk.namaProduk,
        'Deskripsi_Produk': produk.deskripsiProduk,
        'Harga_Produk': produk.hargaProduk,
        'Stok_Produk': produk.stokProduk,
        'Gambar_Produk': imageFile != null
            ? await MultipartFile.fromFile(
                imageFile.path,
                filename: p.basename(imageFile.path),
              )
            : null
      });
      final response = await dio.post(
        '/update_produk.php',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200) {
        final responseD = jsonDecode(response.data as String);
        final responseData = responseD['message'];
        return responseData;
      } else {
        throw Exception('status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
  }

  Future<String> deleteProduk(int idProduk) async {
    try {
      final response = await dio.delete(
        '/delete_produk.php',
        data: {'Id_Produk': idProduk.toString()},
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
