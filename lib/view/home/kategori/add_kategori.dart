import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddKategoriDialog extends ConsumerStatefulWidget {
  final VoidCallback
      onSuccess; // Callback untuk memberi tahu keberhasilan/refresh data

  const AddKategoriDialog({super.key, required this.onSuccess});

  @override
  ConsumerState<AddKategoriDialog> createState() => _AddKategoriDialogState();
}

class _AddKategoriDialogState extends ConsumerState<AddKategoriDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kategoriController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage; // Variabel untuk menyimpan pesan error

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Kategori'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _kategoriController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
                errorText: _errorMessage, // Tampilkan pesan error di sini
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama kategori tidak boleh kosong';
                } else if (value.length < 3) {
                  return 'Nama kategori minimal 3 karakter';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        )
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null; // Reset error message saat mulai submit
      });

      final kategori = Kategori(
        idK:
            '0', // ID akan di-generate oleh backend atau ditentukan sesuai kebutuhan
        namaK: _kategoriController.text,
      );

      try {
        final responseData =
            await ref.watch(addKategoriProvider(kategori).future);

        if (!mounted) return;

        if (responseData != 'Kategori berhasil ditambahkan') {
          setState(() {
            _errorMessage = responseData; // Simpan pesan error
            _isSubmitting = false;
          });
        } else if (responseData == 'Kategori berhasil ditambahkan') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kategori berhasil ditambahkan'),
              duration: Duration(seconds: 2),
            ),
          );

          // Tunggu beberapa detik sebelum menutup dialog
          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            widget.onSuccess(); // Panggil callback setelah berhasil
            Navigator.of(context).pop(); // Tutup dialog setelah berhasil
          }
        } else {
          // Tampilkan pesan error lain
          setState(() {
            _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
            _isSubmitting = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
            _isSubmitting = false;
          });
        }
      }
    }
  }
}
