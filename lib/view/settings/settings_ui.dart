import 'dart:async';
import 'dart:io';

import 'package:bayduri_app/model/server.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUi extends ConsumerStatefulWidget {
  const SettingsUi({super.key});

  @override
  ConsumerState<SettingsUi> createState() => _SettingsUiState();
}

class _SettingsUiState extends ConsumerState<SettingsUi> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? uRLprofile;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: screenHeight / 4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
                child: _image == null
                    ? Image.network(
                        uRLprofile != null && uRLprofile!.isNotEmpty
                            ? uRLprofile!
                            : Server
                                .servernofotoprofile, // Tampilkan gambar dari URL
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            RoundedLoadingButton(
              controller: btnLogout,
              onPressed: () {
                _logout(btnLogout);
                btnLogout.success();
                Timer(const Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                });
              },
              color: Colors.red,
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _logout(RoundedLoadingButtonController controller) async {
    SharedPreferences prefuser = await SharedPreferences.getInstance();
    await prefuser.clear();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void initializePreferences() async {
    SharedPreferences prefuser =
        await SharedPreferences.getInstance(); // Diinisialisasi sekali
    uRLprofile = prefuser.getString('gambar_pengguna') ?? '';
  }
}
