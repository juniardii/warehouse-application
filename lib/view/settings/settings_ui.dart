import 'package:bayduri_app/utils/my_color.dart';
import 'package:flutter/material.dart';

class SettingsUi extends StatelessWidget {
  const SettingsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
      ),
      body: const Center(
        child: Text('Ini adalah Settings'),
      ),
    );
  }
}
