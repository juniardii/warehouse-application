import 'package:bayduri_app/utils/my_color.dart';
import 'package:flutter/material.dart';

class LikeUi extends StatelessWidget {
  const LikeUi({super.key});

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
        body: GridView.count(
          padding: const EdgeInsets.all(25),
          crossAxisCount: 2,
          children: <Widget>[
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
                        'assets/logo_history_pemesanan.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Riwayat\nPemesanan",
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
                        'assets/logo_history_penjualan.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        "Riwayat\nPenjualan",
                        textAlign: TextAlign.center,
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
