import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/kategori/add_kategori.dart';
import 'package:bayduri_app/view/home/kategori/update_kategori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KategoriUi extends ConsumerWidget {
  const KategoriUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriListAsync = ref.watch(kategoriListProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Kategori",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(kategoriListProvider.future),
        child: kategoriListAsync.when(
          data: (kategoriList) => ListView.builder(
            padding: const EdgeInsets.only(top: 10.0),
            itemCount: kategoriList.length,
            itemBuilder: (context, index) {
              final kategori = kategoriList[index];
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Tambahkan ini agar tidak bisa di-dismiss
                    builder: (context) {
                      return PutKategoriDialog(
                        kategori: kategori,
                        onSuccess: () {
                          ref.invalidate(kategoriListProvider);
                        },
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: MyColor.bgColor,
                        width: 0.1,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            kategori.namaK,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Tambahkan ini agar tidak bisa di-dismiss
            builder: (context) {
              return AddKategoriDialog(
                onSuccess: () {
                  ref.invalidate(kategoriListProvider);
                },
              );
            },
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
