import 'package:flutter/material.dart';
import '../models/catatan.dart';
import '../helpers/db_helper.dart';

class CatatanForm extends StatefulWidget {
  final Catatan? catatan; // null = tambah, ada isi = edit

  CatatanForm({this.catatan});

  @override
  _CatatanFormState createState() => _CatatanFormState();
}

class _CatatanFormState extends State<CatatanForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _kategoriList = ['Mengajar', 'Meneliti', 'Pengabdian', 'Lainnya'];
  String _selectedKategori = 'Mengajar';
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.catatan?.judul ?? '');
    _deskripsiController =
        TextEditingController(text: widget.catatan?.deskripsi ?? '');

    if (widget.catatan != null) {
      final datetime = DateTime.parse(widget.catatan!.tanggal);
      _selectedTime = TimeOfDay(hour: datetime.hour, minute: datetime.minute);
      _selectedKategori = widget.catatan!.kategori;
    } else {
      _selectedTime = TimeOfDay.now();
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final now = widget.catatan != null
          ? DateTime.parse(widget.catatan!.tanggal)
          : DateTime.now();

      final fullDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final catatan = Catatan(
        id: widget.catatan?.id,
        judul: _judulController.text,
        deskripsi: _deskripsiController.text,
        kategori: _selectedKategori,
        tanggal: fullDateTime.toIso8601String(),
      );

      if (widget.catatan == null) {
        await DBHelper.insertCatatan(catatan);
      } else {
        await DBHelper.updateCatatan(catatan);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;

    final tanggalString = widget.catatan != null
        ? DateTime.parse(widget.catatan!.tanggal)
        .toLocal()
        .toString()
        .split(' ')[0]
        : DateTime.now().toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Kegiatan'),
                validator: (value) =>
                value!.isEmpty ? 'Kegiatan tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Rincian Kegiatan'),
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? 'Rincian Kegiatan tidak boleh kosong' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                items: _kategoriList
                    .map((kategori) => DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Kategori'),
              ),

              SizedBox(height: 20),
              TextFormField(
                initialValue: tanggalString,
                decoration: InputDecoration(labelText: 'Tanggal'),
                enabled: false,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Waktu: ${_selectedTime.format(context)}"),
                  TextButton(
                    child: Text("Pilih Waktu"),
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: Text(isEdit ? 'Update' : 'Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
