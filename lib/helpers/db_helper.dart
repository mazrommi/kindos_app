// lib/helpers/db_helper.dart
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/catatan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'catatan.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            deskripsi TEXT,
            tanggal TEXT,
            kategori TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<int> insertCatatan(Catatan catatan) async {
    final db = await database;
    return await db.insert('catatan', catatan.toMap());
  }

  static Future<List<Catatan>> getAllCatatan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('catatan');
    return maps.map((e) => Catatan.fromMap(e)).toList();
  }

  static Future<int> updateCatatan(Catatan catatan) async {
    final db = await database;
    return await db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  static Future<int> deleteCatatan(int id) async {
    final db = await database;
    return await db.delete('catatan', where: 'id = ?', whereArgs: [id]);
  }

  static Future<File> exportToCSV() async {
    final db = await database;
    final result = await db.query('catatan');

    // Header
    List<List<String>> csvData = [
      ['ID', 'Judul', 'Deskripsi', 'Tanggal', 'Kategori']
    ];

    // Data
    for (var row in result) {
      csvData.add([
        row['id'].toString(),
        row['judul']?.toString() ?? '',
        row['deskripsi']?.toString() ?? '',
        row['tanggal']?.toString() ?? '',
        row['kategori']?.toString() ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    // Simpan ke file
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    final file = File('$path/catatan_dosen.csv');
    return await file.writeAsString(csv);
  }
}
