// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';

import 'package:bayduri_app/controller/pengguna/pengguna_con.dart';
import 'package:bayduri_app/model/pengguna/pengguna.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  _checkdata();
  //_Tester();
}

Future<void> _checkdata() async {
  SharedPreferences prefuser = await SharedPreferences.getInstance();
  print(
      'ini adalah username dari prefuser : ${prefuser.getString('username')}');
  await prefuser.clear();
  print(
      'ini adalah username dari prefuser 2 : ${prefuser.getString('username')}');
}

Future<void> _Tester() async {
  final loginCon = LoginCon();
  try {
    final response = await loginCon.login('admin4', 'admin4');

    if (response['status'] == 'sukses') {
      // Ambil data pengguna
      final penggunaJson = response['data'][0];
      final pengguna = Pengguna.fromJson(penggunaJson);

      print('hahahaha : ${pengguna.namaPengguna}');

      // Simpan data pengguna ke SharedPreferences
      SharedPreferences prefuser = await SharedPreferences.getInstance();
      // await prefuser.setString('id_pengguna', pengguna.idPengguna);
      // await prefuser.setString('id_jabatan', pengguna.idJabatan);
      // await prefuser.setString('nama_pengguna', pengguna.namaPengguna);
      // await prefuser.setString('nomor_pengguna', pengguna.nomorPengguna);
      // await prefuser.setString('gambar_pengguna', pengguna.gambarPengguna);
      await prefuser.setString('username', pengguna.username);
      // await prefuser.setString('password', pengguna.password);
      print(
          'ini adalah username dari prefuser : ${prefuser.getString('username')}');
    } else {
      print('${response['message']}');
    }
  } catch (e) {
    print('${e.toString()}');
  }
}
