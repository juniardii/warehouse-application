import 'package:bayduri_app/model/produk/produk.dart';
import 'package:bayduri_app/riverpod/produk/produk_provider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddProdukUi extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess; // Callback

  const AddProdukUi({super.key, this.onSuccess});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddprodukUiState();
}

class _AddprodukUiState extends ConsumerState<AddProdukUi> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _namaPcontroller = TextEditingController();
  final TextEditingController _deskripsiPcontroller = TextEditingController();
  final TextEditingController _hargaPcontroller = TextEditingController();
  final TextEditingController _stokPcontroller = TextEditingController();
  final RoundedLoadingButtonController _btnSubmit =
      RoundedLoadingButtonController();
  String? _errorMessage;
  String? valueChoose;
  String? _dropdownErrorMessage; // Variabel untuk pesan error dropdown

  @override
  Widget build(BuildContext context) {
    final kategoriListAsync = ref.watch(kategoriListProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop || _btnSubmit.currentState == ButtonState.loading) {
          return;
        }
        if (context.mounted && _btnSubmit.currentState != ButtonState.loading) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Tambah Produk',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColor.bgColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: screenHeight / 4,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _image == null
                        ? const Center(
                            child: Text(
                                'Tidak ada foto!\n klik jika ingin menambahkan foto'))
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _namaPcontroller,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    errorText: _errorMessage,
                    border: border(),
                    // Tampilkan pesan error di sini
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Produk tidak boleh kosong';
                    } else if (value.length < 3) {
                      return 'Nama Produk minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deskripsiPcontroller,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Produk',
                    errorText: _errorMessage,
                    border: border(),
                    // Tampilkan pesan error di sini
                  ),
                  maxLength: 255,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi Produk tidak boleh kosong';
                    } else if (value.length < 3) {
                      return 'Deskripsi Produk minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _hargaPcontroller,
                  decoration: InputDecoration(
                    labelText: 'Harga Produk',
                    hintText: 'Rp :',
                    errorText: _errorMessage,
                    border: border(),
                    // Tampilkan pesan error di sini
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga Produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stokPcontroller,
                  decoration: InputDecoration(
                    labelText: 'Stok Produk',
                    errorText: _errorMessage,
                    border: border(),
                    // Tampilkan pesan error di sini
                  ),
                  keyboardType:
                      TextInputType.number, // Mengatur keyboard number
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Membatasi input angka
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok Produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _dropdownErrorMessage == null
                          ? Colors.grey
                          : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kategoriListAsync.when(
                        data: (data) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text("Pilih Kategori"),
                              value: valueChoose,
                              isExpanded:
                                  true, // Agar Dropdown menyesuaikan lebar layar
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoose = newValue;
                                  _dropdownErrorMessage = null;
                                });
                              },
                              items: data.map((Kategori kategori) {
                                return DropdownMenuItem<String>(
                                  value: kategori.idK,
                                  child: Text(kategori.namaK),
                                );
                              }).toList(),
                            ),
                          );
                        },
                        error: (err, stack) => Text(
                            'Error: $err'), // Menampilkan error jika ada masalah
                        loading: () => const CircularProgressIndicator(),
                      ),
                      if (_dropdownErrorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _dropdownErrorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RoundedLoadingButton(
                  controller: _btnSubmit,
                  onPressed: () => _validation(_btnSubmit),
                  color: MyColor.bgColor,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
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

  InputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
      );

  Future<void> _validation(RoundedLoadingButtonController controller) async {
    // Validasi form biasa
    if (_formKey.currentState?.validate() ?? false) {
      // Validasi dropdown
      if (valueChoose == null) {
        setState(() {
          _dropdownErrorMessage = "Pilih Kategori";
        });
        controller.error();
        Timer(const Duration(seconds: 2), () {
          controller.reset();
        });
        return; // Kembalikan jika dropdown tidak valid
      } else {
        // Jika valid, lakukan sesuatu
        final produk = Produk(
          idProduk: '',
          idKategori: valueChoose!,
          namaProduk: _namaPcontroller.text,
          deskripsiProduk: _deskripsiPcontroller.text,
          hargaProduk: int.parse(_hargaPcontroller.text).toString(),
          stokProduk: int.parse(_stokPcontroller.text).toString(),
          gambarProduk: '',
        );

        try {
          final responseData = await ref.watch(addProdukProvider(
            AddProdukParams(
              produk: produk,
              imageFile: _image,
            ),
          ).future);

          if (responseData != 'Produk berhasil ditambahkan') {
            setState(() {
              _errorMessage = responseData;
            });
            controller.error();
          } else {
            // Tunggu beberapa detik sebelum menutup halaman

            if (mounted) {
              controller.success();
              Timer(const Duration(seconds: 2), () {
                controller.reset();

                // Tampilkan Snackbar untuk sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produk berhasil ditambahkan'),
                    duration: Duration(seconds: 2),
                  ),
                );
                widget.onSuccess?.call();

                Navigator.of(context).pop(); // Tutup halaman setelah sukses
              });
            }
          }
        } catch (e) {
          setState(() {
            _errorMessage = '$e';
          });
          controller.error();
        }
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            controller.reset();
          }
        });
      }
    } else {
      // Jika form tidak valid, tampilkan pesan error
      controller.error();
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          controller.reset();
        }
      });
    }
  }
}

class AddProdukParams {
  final Produk produk;
  final File? imageFile;

  AddProdukParams({
    required this.produk,
    this.imageFile,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddProdukParams &&
          runtimeType == other.runtimeType &&
          produk == other.produk &&
          imageFile?.path == other.imageFile?.path;

  @override
  int get hashCode => produk.hashCode ^ (imageFile?.path.hashCode ?? 0);
}
