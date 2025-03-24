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
    final formattedTanggal = tanggalFormat.format(DateTime.parse(catatan.tanggal));

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
            Text('Kegiatan:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.judul, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Rincian Kegiatan:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.deskripsi, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Kategori:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(catatan.kategori, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Tanggal & Waktu:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(formattedTanggal, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
