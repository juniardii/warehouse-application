import 'package:bayduri_app/model/server.dart';
import 'package:bayduri_app/riverpod/produk/produk_provider.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/stok/addproduk_ui.dart';
import 'package:bayduri_app/view/home/stok/update_produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StokProdukUi extends ConsumerWidget {
  const StokProdukUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final produkListAsync = ref.watch(produkListProvider);

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: MyColor.bgColor,
          title: const Text(
            'Stok Produk',
            style: TextStyle(color: Colors.white),
          )),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(produkListProvider.future),
        child: produkListAsync.when(
          data: (produkList) => ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final produk = produkList[index];
              return InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProdukUi(
                        produk: produk,
                        onSuccess: () {
                          ref.invalidate(
                              produkListProvider); // Refresh produkListProvider
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(
                      bottom: 10.0, left: 2.0, right: 2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          produk.gambarProduk.isNotEmpty
                              ? produk.gambarProduk
                              : Server.servernofotoproduk,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk.namaProduk,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                produk.deskripsiProduk,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Harga: Rp ${produk.hargaProduk}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Stok: ${produk.stokProduk}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          error: (err, stack) => Text('Error: $err'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProdukUi(
                onSuccess: () {
                  ref.invalidate(
                      produkListProvider); // Refresh produkListProvider
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
