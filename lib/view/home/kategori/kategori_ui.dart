import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/kategori/add_kategori.dart';
import 'package:bayduri_app/view/home/kategori/update_kategori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class KategoriUi extends ConsumerStatefulWidget {
  const KategoriUi({super.key});

  @override
  ConsumerState<KategoriUi> createState() => _KategoriUiState();
}

class _KategoriUiState extends ConsumerState<KategoriUi> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  void _clearSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateConnection = ref.watch(connectionProvider);

    return PopScope(
      canPop: !isSearching,
      onPopInvokedWithResult: (didPop, result) async {
        if (isSearching) {
          _clearSearch();
          Navigator.pop(context);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: [
              if (!isSearching)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Kategori",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width:
                      isSearching ? MediaQuery.of(context).size.width * 0.7 : 0,
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: isSearching ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Cari Kategori...',
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: MyColor.bgColor,
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  }
                });
              },
            ),
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
                          ref
                              .read(connectionProvider.notifier)
                              .checkconnection();
                        },
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () => ref.refresh(kategoriListProvider.future),
                    child: KategoriListView(),
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
      ),
    );
  }
}

class KategoriListView extends ConsumerWidget {
  const KategoriListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriListAsync = ref.watch(kategoriListProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return kategoriListAsync.when(
      data: (kategoriList) {
        final filteredList = kategoriList
            .where((kategori) =>
                kategori.namaK.toLowerCase().contains(searchQuery))
            .toList();

        if (filteredList.isEmpty) {
          return const Center(child: Text('Tidak ada kategori yang cocok...'));
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
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
