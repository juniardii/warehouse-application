import 'dart:io';

import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:bayduri_app/model/produk/produk.dart';
import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:bayduri_app/riverpod/produk/produk_provider.dart';
import 'package:bayduri_app/utils/my_color.dart';
import 'package:bayduri_app/view/home/stok/addproduk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProdukUi extends ConsumerStatefulWidget {
  final Produk produk;
  final VoidCallback onSuccess;

  const UpdateProdukUi(
      {super.key, required this.produk, required this.onSuccess});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProdukUiState();
}

class _UpdateProdukUiState extends ConsumerState<UpdateProdukUi> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _namaPcontroller = TextEditingController();
  final TextEditingController _deskripsiPcontroller = TextEditingController();
  final TextEditingController _hargaPcontroller = TextEditingController();
  final TextEditingController _stokPcontroller = TextEditingController();
  String? _errorMessage;
  String? valueChoose;
  String? _dropdownErrorMessage; // Variabel untuk pesan error dropdown
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _namaPcontroller.text = widget.produk.namaProduk;
    _deskripsiPcontroller.text = widget.produk.deskripsiProduk;
    _hargaPcontroller.text = widget.produk.hargaProduk;
    _stokPcontroller.text = widget.produk.stokProduk;
    valueChoose = widget.produk.idKategori;
  }

  @override
  Widget build(BuildContext context) {
    final kategoriListAsync = ref.watch(kategoriListProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop || _isSubmitting) {
          return;
        }
        if (context.mounted && _isSubmitting == false) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Ubah Produk',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColor.bgColor,
          actions: [
            IconButton(
              onPressed: _isSubmitting
                  ? null
                  : _delete, // Nonaktifkan tombol saat proses berjalan
              icon: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Icon(
                      Icons.delete_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
            IconButton(
              padding: const EdgeInsets.only(right: 10.0, left: 5.0),
              onPressed: _isSubmitting
                  ? null
                  : _update, // Nonaktifkan tombol saat proses berjalan
              icon: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Icon(
                      Icons.check_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ],
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
                        ? widget.produk.gambarProduk.isNotEmpty
                            ? Image.network(
                                widget.produk
                                    .gambarProduk, // Tampilkan gambar dari URL
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                    'Tidak ada foto!\n klik jika ingin menambahkan foto'),
                              )
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
                          // Periksa apakah valueChoose cocok dengan salah satu dari kategori yang tersedia
                          if (!data
                              .any((kategori) => kategori.idK == valueChoose)) {
                            valueChoose =
                                null; // Set valueChoose ke null jika tidak ditemukan yang cocok
                          }

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
              ]),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
      );

  Future<void> _update() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      if (valueChoose == null) {
        setState(() {
          _dropdownErrorMessage = "Pilih Kategori";
          _isSubmitting = false;
        });
      } else {
        final produk = Produk(
          idProduk: widget.produk.idProduk,
          idKategori: valueChoose!,
          namaProduk: _namaPcontroller.text,
          deskripsiProduk: _deskripsiPcontroller.text,
          hargaProduk: _hargaPcontroller.text,
          stokProduk: _stokPcontroller.text,
          gambarProduk: '',
        );

        try {
          final responseData = await ref.watch(updateProdukProvider(
            AddProdukParams(
              produk: produk,
              imageFile: _image,
            ),
          ).future);

          if (!mounted) return;

          setState(() {
            _errorMessage = responseData;
            _isSubmitting = false;
          });

          if (responseData == 'Produk berhasil diupdate') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kategori Berhasil DiUbah'),
                duration: Duration(seconds: 2),
              ),
            );
            if (mounted) {
              widget.onSuccess();
              Navigator.of(context).pop();
            }
          } else {
            setState(() {
              _errorMessage = responseData;
              _isSubmitting = false;
            });
          }
        } catch (e) {
          // Tangani error jika ada
          setState(() {
            _errorMessage = '$e';
            _isSubmitting = false;
          });
        } finally {
          setState(() {
            _isSubmitting = false; // Akhiri proses penghapusan
          });
        }
      }
    }
  }

  Future<void> _delete() async {
    try {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });
      final responsemessage = await ref.read(
          deleteProdukProvider(int.tryParse(widget.produk.idProduk) ?? 0)
              .future);
      if (!mounted) return;
      if (responsemessage == 'Produk berhasil dihapus') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk Berhasil DiHapus'),
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          widget.onSuccess();
          Navigator.of(context).pop();
        } else {
          setState(() {
            _errorMessage = responsemessage;
            _isSubmitting = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = responsemessage;
          _isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi Kesalahan, Silahkan Coba Lagi';
          _isSubmitting = false;
        });
      }
    } finally {
      setState(() {
        _isSubmitting = false; // Akhiri proses penghapusan
      });
    }
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
}
