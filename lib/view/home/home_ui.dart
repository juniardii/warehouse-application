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
        body: GridView.count(
          padding: const EdgeInsets.all(25),
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KategoriUi()),
                  );
                },
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_kategori.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Kategori",
                        style: TextStyle(fontSize: 17.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StokProdukUi()),
                  );
                },
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_cek_produk.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Stok Produk",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_pemesanan.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Pemesanan",
                        style: TextStyle(fontSize: 17.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_penjualan.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Penjualan",
                        style: TextStyle(fontSize: 17.0),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
