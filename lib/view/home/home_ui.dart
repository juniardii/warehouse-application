import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/kategori/kategori_ui.dart';
import 'package:bayduri_app/view/home/stok/stok_ui.dart';
import 'package:flutter/material.dart';

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
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
            itemCount: 4, // Update item count based on the number of cards
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
      'assets/logo_kategori.png',
      'assets/logo_cek_produk.png',
      'assets/logo_pemesanan.png',
      'assets/logo_penjualan.png',
    ];
    final titles = [
      'Kategori',
      'Stok Produk',
      'Pemesanan',
      'Penjualan',
    ];
    final routes = [
      const KategoriUi(),
      const StokProdukUi(),
      null,
      null,
    ];

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (routes[index] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => routes[index]!),
            );
          }
        },
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                icons[index],
                width: width * 0.4,
                height: height * 0.4,
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
