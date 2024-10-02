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
    final stateConnection = ref.watch(connectionProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Kategori",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.bgColor,
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final kategoriListAsync = ref.watch(kategoriListProvider);
                final kategoriList = kategoriListAsync.maybeWhen(
                  data: (data) => data,
                  orElse: () => [],
                );

                showSearch(
                  context: context,
                  delegate:
                      MySearchDelegate(kategoriList: kategoriList, ref: ref),
                );
              }),
        ],
      ),
      body: stateConnection == StateConnection.loading
          ? const Center(child: CircularProgressIndicator())
          : stateConnection == StateConnection.error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Gagal terhubung ke database'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(connectionProvider.notifier).checkconnection();
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () => ref.refresh(kategoriListProvider.future),
                  child: kategoriListView(ref),
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

Widget kategoriListView(WidgetRef ref) {
  final kategoriListAsync = ref.watch(kategoriListProvider);

  return kategoriListAsync.when(
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
                    ref.invalidate(kategoriListProvider); // Refresh data
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
  );
}

class MySearchDelegate extends SearchDelegate {
  final List kategoriList;
  final WidgetRef ref;

  MySearchDelegate({required this.kategoriList, required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List filteredList = kategoriList.where((kategori) {
      return kategori.namaK.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text('Tidak ada kategori terdaftar'),
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.only(top: 10.0),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final kategori = filteredList[index];
          return InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return PutKategoriDialog(
                    kategori: kategori,
                    onSuccess: () {
                      ref.invalidate(kategoriListProvider);
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // Close the dialog
                      }
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
        });
  }
}
