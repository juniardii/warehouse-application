import 'dart:async';

import 'package:bayduri_app/controller/pengguna/pengguna_con.dart';
import 'package:bayduri_app/model/pengguna/pengguna.dart';
import 'package:bayduri_app/view/bottom_nav_bar_owner.dart';
import 'package:flutter/material.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formValidasi = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passToggle = true;
  final RoundedLoadingButtonController _btnLogin =
      RoundedLoadingButtonController();
  String? _errorMessageApi;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenwidth = mediaQuery.size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: screenHeight,
                width: screenwidth,
                decoration: const BoxDecoration(gradient: MyColor.myGradient),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0, left: 22.0),
                    child: Image.asset(
                      'assets/logo_bayduri_nobg.png',
                      height: 100,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(120)),
                    color: Colors.white,
                  ),
                  height: screenHeight,
                  width: screenwidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Form(
                      key: _formValidasi,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_rounded),
                            ),
                            validator: (value) {
                              bool usernamevalid =
                                  RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value!);
                              if (value.isEmpty) {
                                return "Masukkan Username";
                              } else if (!usernamevalid) {
                                return "Username tidak boleh mengandung karakter khusus";
                              } else if (_usernameController.text.length < 6) {
                                return "tidak kurang dari 6 karakter";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _passwordController,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
                                child: Icon(passToggle
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan Password";
                              } else if (_passwordController.text.length < 6) {
                                return "Password Minimal 6 karakter";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (_errorMessageApi != null)
                            Text(
                              _errorMessageApi!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          RoundedLoadingButton(
                            color: MyColor.bgColor,
                            successColor: Colors.green,
                            controller: _btnLogin,
                            onPressed: () => _validation(_btnLogin),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validation(RoundedLoadingButtonController controller) async {
    if (_formValidasi.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final loginCon = LoginCon();

      try {
        final response = await loginCon.login(username, password);

        if (response['status'] == 'sukses') {
          // Ambil data pengguna
          final penggunaJson = response['data'][0];
          final pengguna = Pengguna.fromJson(penggunaJson);

          // Simpan data pengguna ke SharedPreferences
          SharedPreferences prefuser = await SharedPreferences.getInstance();
          await prefuser.setString('id_pengguna', pengguna.idPengguna);
          await prefuser.setString('id_jabatan', pengguna.idJabatan);
          await prefuser.setString('nama_pengguna', pengguna.namaPengguna);
          await prefuser.setString('nomor_pengguna', pengguna.nomorPengguna);
          await prefuser.setString('gambar_pengguna', pengguna.gambarPengguna);
          await prefuser.setString('username', pengguna.username);
          await prefuser.setString('password', pengguna.password);
          await prefuser.setBool('isloggedin', true);

          if (!mounted) return;

          // Tampilkan pesan sukses
          controller.success();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login successful: ${prefuser.getString('nama_pengguna')}')),
          );

          // Navigasi ke halaman berikutnya jika diperlukan
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavbarOwner()),
          );
        } else {
          setState(() {
            controller.error();
            _errorMessageApi = response['message'];
          });
        }
      } catch (e) {
        setState(() {
          _errorMessageApi = 'Terjadi kesalahan: ${e.toString()}';
        });
      }
    } else {
      controller.error();
    }
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        controller.reset();
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefuser = await SharedPreferences.getInstance();
    bool isLoggedIn = prefuser.getBool('isloggedin') ?? false;

    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavbarOwner()),
      );
    }
  }
}
