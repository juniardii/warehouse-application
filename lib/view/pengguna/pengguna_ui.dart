import 'package:bayduri_app/utils/my_color.dart';
import 'package:flutter/material.dart';

class SearchUi extends StatelessWidget {
  const SearchUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengguna',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
      ),
      body: const Center(
        child: Text('Ini adalah Pengguna'),
      ),
    );
  }
}
