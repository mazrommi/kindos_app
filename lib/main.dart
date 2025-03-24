import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/catatan.dart';
import 'helpers/db_helper.dart';
import 'pages/catatan_form.dart';
import 'pages/catatan_detail.dart';

void main() {
  runApp(const CatatanApp());
}

class CatatanApp extends StatelessWidget {
  const CatatanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Kinerja Dosen',
      home: const CatatanListPage(),
    );
  }
}

class CatatanListPage extends StatefulWidget {
  const CatatanListPage({super.key});

  @override
  _CatatanListPageState createState() => _CatatanListPageState();
}

class _CatatanListPageState extends State<CatatanListPage> {
  List<Catatan> _catatanList = [];
  List<Catatan> _filteredCatatanList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshCatatan();
    _searchController.addListener(() {
      _filterCatatan(_searchController.text);
    });
  }

  void _refreshCatatan() async {
    final data = await DBHelper.getAllCatatan();
    setState(() {
      _catatanList = data;
      _filteredCatatanList = data;
    });
  }

  void _hapusCatatan(int id) async {
    await DBHelper.deleteCatatan(id);
    _refreshCatatan();
  }

  void _bukaForm({Catatan? catatan}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatatanForm(catatan: catatan),
      ),
    );

    if (result == true) _refreshCatatan();
  }

  void _lihatDetail(Catatan catatan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatatanDetailPage(catatan: catatan),
      ),
    );
    if (result == true) _refreshCatatan();
  }

  void _filterCatatan(String keyword) {
    final filtered = _catatanList.where((catatan) {
      final lowerKeyword = keyword.toLowerCase();
      return catatan.judul.toLowerCase().contains(lowerKeyword) ||
          catatan.deskripsi.toLowerCase().contains(lowerKeyword) ||
          catatan.kategori.toLowerCase().contains(lowerKeyword) ||
          catatan.tanggal.toLowerCase().contains(lowerKeyword);
    }).toList();

    setState(() {
      _filteredCatatanList = filtered;
    });
  }

  void _exportData() async {
    final file = await DBHelper.exportToCSV();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data diekspor ke:\n${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CATATAN KINERJA DOSEN'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                'Cari Kegiatan, Rincian Kegiatan, kategori, atau tanggal',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredCatatanList.isEmpty
                ? const Center(child: Text('Tidak ada catatan.'))
                : ListView.builder(
              itemCount: _filteredCatatanList.length,
              itemBuilder: (context, index) {
                final catatan = _filteredCatatanList[index];

                final tanggalFormat =
                DateFormat('dd MMM yyyy - HH:mm');
                final formattedTanggal = tanggalFormat.format(
                  DateTime.parse(catatan.tanggal),
                );

                return ListTile(
                  title: Text(catatan.judul),
                  subtitle: Text(
                    '$formattedTanggal\nKategori: ${catatan.kategori}',
                  ),
                  onTap: () => _lihatDetail(catatan),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _bukaForm(catatan: catatan),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _hapusCatatan(catatan.id ?? 0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
