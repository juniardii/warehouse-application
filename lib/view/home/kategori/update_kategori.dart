import 'package:bayduri_app/model/kategori/kategori.dart';
import 'package:bayduri_app/riverpod/kategori/kategori_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PutKategoriDialog extends ConsumerStatefulWidget {
  final Kategori kategori;
  final VoidCallback onSuccess;

  const PutKategoriDialog({
    super.key,
    required this.kategori,
    required this.onSuccess,
  });

  @override
  ConsumerState<PutKategoriDialog> createState() => _PutKategoriDialogState();
}

class _PutKategoriDialogState extends ConsumerState<PutKategoriDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaKategori = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _namaKategori.text = widget.kategori.namaK;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Kategori'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _namaKategori,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
                errorText: _errorMessage,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama Kategori Tidak Boleh Kosong';
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
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _delete,
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Hapus'),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const CircularProgressIndicator()
              : const Text('Ubah'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final namakategori = _namaKategori.text;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      final kategori = Kategori(
        idK: widget.kategori.idK.toString(),
        namaK: namakategori,
      );

      try {
        final responseMessage =
            await ref.read(updateKategoriProvider(kategori).future);

        if (!mounted) return;

        if (responseMessage == 'Kategori Berhasil DiUbah') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kategori Berhasil DiUbah'),
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            widget.onSuccess();
            Navigator.of(context).pop();
          }
        } else {
          setState(() {
            _errorMessage = responseMessage;
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

  Future<void> _delete() async {
    try {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      final responseMessage = await ref.read(
          deleteKategoriProvider(int.tryParse(widget.kategori.idK) ?? 0)
              .future);
      if (!mounted) {
        return;
      }

      if (responseMessage == 'Kategori Berhasil Dihapus') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategori Berhasil DiHapus'),
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          widget.onSuccess();
          Navigator.of(context).pop();
        } else {
          setState(() {
            _errorMessage = responseMessage;
            _isSubmitting = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = responseMessage;
          _isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi Kesalahan, Silahkan coba lagi';
          _isSubmitting = false;
        });
      }
    }
  }
}
