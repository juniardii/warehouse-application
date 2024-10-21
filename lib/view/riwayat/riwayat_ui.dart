import 'package:bayduri_app/utils/my_color.dart';
import 'package:flutter/material.dart';

class RiwayatUi extends StatelessWidget {
  const RiwayatUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          final cardWidth = constraints.maxWidth / crossAxisCount;
          final cardHeight = cardWidth * 0.8;

          return GridView.builder(
            padding: const EdgeInsets.all(25),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: cardWidth / cardHeight,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: 2,
            itemBuilder: (context, index) {
              return _buildGridCard(context, index, cardWidth, cardHeight);
            },
          );
        },
      ),
    );
  }

  Widget _buildGridCard(
      BuildContext context, int index, double width, double height) {
    final icons = [
      'assets/logo_history_pemesanan.png',
      'assets/logo_history_penjualan.png',
    ];
    final titles = [
      'Riwayat\nPemesanan',
      'Riwayat\nPenjualan',
    ];

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Tambahkan navigasi atau aksi di sini
        },
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Image.asset(
                  icons[index],
                  width: width * 0.4,
                  height: height * 0.4,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                titles[index],
                style: const TextStyle(fontSize: 17.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
