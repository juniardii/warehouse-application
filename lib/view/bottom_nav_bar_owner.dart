import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/home_ui.dart';
import 'package:bayduri_app/view/pengguna/pengguna_ui.dart';
import 'package:bayduri_app/view/riwayat/riwayat_ui.dart';
import 'package:bayduri_app/view/settings/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavbarOwner extends StatefulWidget {
  const NavbarOwner({super.key});

  @override
  State<NavbarOwner> createState() => _NavbarOwnerState();
}

class _NavbarOwnerState extends State<NavbarOwner> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeUi(),
    LikeUi(),
    SearchUi(),
    SettingsUi()
  ];

  @override
  void initState() {
    super.initState();
    // _testing();
  }

  // Future<void> _testing() async {
  //   SharedPreferences prefuser = await SharedPreferences.getInstance();
  //   print('${prefuser.getString('id_pengguna')}');
  //   print('${prefuser.getString('id_jabatan')}');
  //   print('${prefuser.getString('nama_pengguna')}');
  //   print('${prefuser.getString('nomor_pengguna')}');
  //   print('${prefuser.getString('gambar_pengguna')}');
  //   print('${prefuser.getString('username')}');
  //   print('${prefuser.getString('password')}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: MyColor.bgColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
              backgroundColor: const Color(0xFF004972),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromARGB(75, 158, 158, 158),
              gap: 8,
              padding: const EdgeInsets.all(15),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.history,
                  text: 'Riwayat',
                ),
                GButton(
                  icon: Icons.people,
                  text: 'Pengguna',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'setting',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
