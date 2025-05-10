import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/catatan.dart';
import 'catatan_form.dart';

class CatatanDetailPage extends StatelessWidget {
  final Catatan catatan;

  const CatatanDetailPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final tanggalFormat = DateFormat('dd MMM yyyy - HH:mm WIB');
    final formattedTanggal =
        tanggalFormat.format(DateTime.parse(catatan.tanggal));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatatanForm(catatan: catatan),
                ),
              );
              if (result == true) {
                Navigator.pop(context, true);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kegiatan:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.judul, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Rincian Kegiatan:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.deskripsi, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Kategori:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.kategori, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Tanggal & Waktu:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(formattedTanggal, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
