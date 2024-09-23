import 'dart:async';

import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUi extends StatelessWidget {
  const SettingsUi({super.key});

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController btnLogout =
        RoundedLoadingButtonController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
      ),
      body: Center(
        child: RoundedLoadingButton(
          controller: btnLogout,
          onPressed: () {
            _logout(btnLogout);
            btnLogout.success();
            Timer(const Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            });
          },
          color: Colors.red,
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(RoundedLoadingButtonController controller) async {
    SharedPreferences prefuser = await SharedPreferences.getInstance();
    await prefuser.clear();
  }
}
