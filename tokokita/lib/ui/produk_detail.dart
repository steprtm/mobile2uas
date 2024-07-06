import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _buildEditDeleteButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDeleteButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tombol Edit
          OutlinedButton(
            child: const Text("EDIT"),
            onPressed: () {
              print('Editing product: ${widget.produk!.namaProduk}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(produk: widget.produk!),
                ),
              );
            },
          ),
          const SizedBox(width: 16.0),
          // Tombol Hapus
          OutlinedButton(
            child: const Text("DELETE"),
            onPressed: () => _confirmDelete(),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            OutlinedButton(
              child: const Text("Ya"),
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                bool deleted =
                    await ProdukBloc.deleteProduk(id: widget.produk!.id!);
                if (deleted) {
                  // Safely navigate back only if the widget's context is valid
                  if (mounted) {
                    // Check if the widget is still mounted
                    Navigator.pop(context); // Navigate back
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Gagal menghapus produk",
                    ),
                  );
                }
              },
            ),
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
