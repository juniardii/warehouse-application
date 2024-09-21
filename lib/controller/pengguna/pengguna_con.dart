import 'dart:convert';

import 'package:bayduri_app/model/server.dart';
import 'package:dio/dio.dart';

class PenggunaCon {
  final dio = Dio(BaseOptions(baseUrl: Server.serverInduk));
}

class LoginCon {
  final dio = Dio(BaseOptions(baseUrl: Server.serverInduk));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/login.php',
        data: {
          'Username': username,
          'Password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is String) {
          final decodedData = jsonDecode(responseData);
          return decodedData;
        } else {
          return responseData;
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
